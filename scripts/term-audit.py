#!/usr/bin/env python3
"""Find terms the book uses before it defines them.

This exists because a class of defect kept surviving prose-check and getting
caught by eye instead. prose-check reads one file at a time and asks whether
the prose is well made. This asks a question only the whole book can answer:
when the reader meets this word, have they been told what it means?

Three findings, in reading order taken from _quarto.yml:

  LATE      the term is used in an earlier chapter than the one that defines it.
            "Contribution margin" was the case that prompted this: first used in
            ch12, defined nowhere, while bare "contribution" had been working
            quietly since ch8.

  UNDEFINED a term is glossed in the margin but never bolded in prose, so the
            definition floats beside text that never claims it.

  SPLIT     a term is defined in more than one place, which usually means two
            chapters are each introducing it as if new.

What counts as a definition: a margin gloss, which is the book's actual
definitional apparatus.

    ::: {.column-margin .def-margin}
    **Term** — what it means.
    :::

A bold is a MARKER of a teaching use rather than a definition. Counting every
bold-followed-by-a-copula produced more false positives than findings, because
"**Unit cost** is c" is a mapping and not a gloss.

Matching is deliberately forgiving, because "Access test" and "access testing"
and "the base rate" and "base rate" are the same term. Leading articles are
dropped and words are stemmed before comparison. It is forgiving in the other
direction too: a term of one short common word is skipped, because "margin" and
"growth" appear in ordinary sentences constantly and every one would be a hit.

Not part of the byte-identical shared tooling. prose-check.py, sync-refs.py and
base.css must match across the three books; this is an audit you run during a
revision pass, and it can be copied to another book unchanged.

    python3 scripts/term-audit.py            # all three findings
    python3 scripts/term-audit.py --late     # only use-before-definition
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# A term this short and this common is used in ordinary prose constantly; a
# first-use check on it reports noise rather than defects.
COMMON = {
    "margin", "growth", "cost", "price", "demand", "profit", "scale", "unit",
    "population", "evidence", "risk", "value", "quantity", "revenue",
}

GLOSS = re.compile(r"\{[^}]*\.def-margin[^}]*\}\s*\n\*\*([^*\n]+)\*\*\s*[—–-]")
# Definitions come from margin glosses only. A bold is a MARKER of a teaching
# use, not a definition -- "**Unit cost** is c" is a mapping, not a gloss -- and
# treating every bold-plus-copula as definitional produced more false positives
# than findings. Whether a glossed term is also bolded where it is taught is a
# separate question, reported below as UNDEFINED.
ARTICLE = re.compile(r"^(the|a|an)\s+", re.I)


def stem(w):
    w = w.lower()
    for suf in ("ing", "ies", "es", "ed", "s"):
        if len(w) > 4 and w.endswith(suf):
            return w[: -len(suf)]
    return w


def key(s):
    return tuple(stem(w) for w in re.findall(r"[A-Za-z']+", ARTICLE.sub("", s.strip())))


def prose_only(text):
    text = re.sub(r"\A---.*?^---", "", text, flags=re.S | re.M)
    text = re.sub(r"^```.*?^```", "", text, flags=re.S | re.M)
    text = re.sub(r"<!--.*?-->", "", text, flags=re.S)
    return text


def chapter_order():
    """Reading order as the book actually presents it."""
    y = open(os.path.join(ROOT, "_quarto.yml"), encoding="utf-8").read()
    y = y.split("format:")[0]
    seen, order = set(), []
    for m in re.finditer(r"^\s*(?:-\s*(?:part:\s*)?)([A-Za-z0-9_-]+\.qmd)", y, re.M):
        f = m.group(1)
        if f not in seen and os.path.exists(os.path.join(ROOT, f)):
            seen.add(f)
            order.append(f)
    return order


def main():
    only_late = "--late" in sys.argv
    order = chapter_order()
    if not order:
        print("term-audit: no chapters found in _quarto.yml")
        return 0

    texts = {f: prose_only(open(os.path.join(ROOT, f), encoding="utf-8").read())
             for f in order}
    pos = {f: i for i, f in enumerate(order)}

    # Where each term is defined, and how.
    defs = {}          # key -> list of (chapter_index, file, term, kind)
    for f in order:
        for kind, rx in (("gloss", GLOSS),):
            for m in rx.finditer(texts[f]):
                term = m.group(1).strip()
                k = key(term)
                if not k or (len(k) == 1 and k[0] in COMMON):
                    continue
                defs.setdefault(k, []).append((pos[f], f, term, kind))

    late, undefined, split = [], [], []

    for k, sites in defs.items():
        sites.sort()
        first_def_i, first_def_f, term, _ = sites[0]
        kinds = {s[3] for s in sites}
        files = sorted({s[1] for s in sites}, key=lambda x: pos[x])

        # SPLIT: defined in two different chapters
        if len(files) > 1:
            split.append((term, files))

        # First use anywhere in reading order, ignoring the definition markup.
        # Allow real inflections only. An unbounded [a-z]* lets the stem
        # "subscript" match "subscription", which is how the first run of this
        # script reported a term as used nineteen chapters early.
        INFL = r"(?:s|es|ing|ed|ies)?"
        pat = re.compile(
            r"\b" + (INFL + r"\s+").join(re.escape(w) for w in k) + INFL + r"\b", re.I)
        first_use_i, first_use_f = None, None
        for f in order:
            if f in ("index.qmd", "references.qmd"):
                continue   # front and back matter, not a place a term is met
            body = GLOSS.sub("", texts[f])
            if pat.search(body):
                first_use_i, first_use_f = pos[f], f
                break

        if first_use_i is not None and first_use_i < first_def_i:
            late.append((term, first_use_f, first_def_f, first_def_i - first_use_i))

        # UNDEFINED: glossed, but the term is never bolded in prose
        if kinds == {"gloss"}:
            bolded = any(
                any(key(b) == k for b in re.findall(r"\*\*([^*\n]+)\*\*", texts[f]))
                for f in order
            )
            if not bolded:
                undefined.append((term, first_def_f))

    print(f"term-audit — {len(order)} chapters in reading order, "
          f"{len(defs)} defined terms\n")

    if late:
        print(f"LATE — used before defined ({len(late)}), widest gap first")
        print("    A gap of one chapter is usually informal use followed by")
        print("    definition, which reads fine. A wide gap is worth a look.\n")
        for term, use_f, def_f, gap in sorted(late, key=lambda t: -t[3]):
            print(f"    {gap:>2} ch  {term:<26} {use_f:<28} -> {def_f}")
    else:
        print("LATE — none")

    if not only_late:
        print()
        if undefined:
            print(f"UNDEFINED — glossed but never claimed in prose ({len(undefined)})")
            for term, f in undefined:
                print(f"    {term:<28} gloss sits in {f}")
        else:
            print("UNDEFINED — none")
        print()
        if split:
            print(f"SPLIT — defined in more than one chapter ({len(split)})")
            for term, files in split:
                print(f"    {term:<28} {', '.join(files)}")
        else:
            print("SPLIT — none")

    return 0


if __name__ == "__main__":
    sys.exit(main())
