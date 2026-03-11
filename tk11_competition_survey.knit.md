# Designing a Competitive Demand Survey {#sec-toolkit-design-competition-survey .unnumbered}

---

This toolkit provides a practical structure for designing a survey that can estimate *demand in the presence of a rival product*.

It assumes you have already completed [Toolkit — Framing a Demand Learning Problem](tk1_frame_problem.qmd), including:

- a clear decision,    
- a defined customer,    
- a defined unit,
- a defined decision period,    
- and identification of the *focal product* and the *closest rival product*.

If those elements are not yet clear, return to the [problem framing toolkit](tk1_frame_problem.qmd) before proceeding.

The goal of this toolkit is not to guarantee accurate demand estimates. Its goal is to help you design a survey that produces *interpretable evidence about how customers choose between competing options*.

In competitive markets, demand depends on *two prices rather than one*:

$$ \mathsf{Q_A = f(P_A, P_B)} $$

Your demand changes when your price changes and when the rival’s price changes.

To estimate this relationship, your survey must collect structured data on both products simultaneously.

## How to Use This Toolkit

This toolkit is organized as a sequence of survey sections.

Each section includes:

- its purpose,    
- example question types or wording,    
- and notes on common failure modes.  

The structure closely mirrors the [survey design used for monopoly demand](tk2_survey_design.qmd). The key difference is that respondents must evaluate *two products at the same time*, allowing substitution effects to be measured.

You should be able to translate each section directly into your preferred survey tool.




## Screening the Population


#### Purpose

Ensure respondents belong to the customer population whose demand you are trying to learn.

Demand evidence is meaningful only if it comes from people who could plausibly face the decision you are studying.

#### What to Include
- One or more screening questions that establish eligibility    
- Clear exclusion of respondents who do not fit the target customer definition  

#### Example Prompts
- “Do you currently [engage in X / face Y problem / purchase Z]?”    
- “Which of the following best describes your role or situation?”  

#### Design Notes
- Screen early. Do not ask valuation questions before eligibility is confirmed.    
- Avoid overly permissive screens. Broad samples dilute demand signals.    
- If many respondents fail the screen, that is useful information—not a failure.  





## Establishing Context and Purpose

#### Purpose

Frame the survey as a request for informed judgment rather than a sales pitch.

Respondents should understand that their answers will help determine whether an offering moves forward and how it might be priced.

#### What to Include
- A brief description of what is being evaluated    
- Why honest answers matter    
- An implicit sense of consequence  

#### Example Language (Adapt, Do Not Copy)
- “We are evaluating whether to move forward with a new offering.”    
- “Your answers will help determine whether this is built and how it is priced.”    
- “Honest answers matter more than encouraging ones.”    

#### Design Notes
- Do not oversell the product.    
- Do not promise that the product will exist.    
- The goal is to make the decision feel real, not promotional.    





## Presenting the Two Products

#### Purpose

Ensure respondents understand both the focal product and the rival product well enough to imagine a real decision.

Competitive demand only makes sense if respondents recognize the two options as substitutes.

#### What to Include
- A clear description of the focal product    
- A clear description of the rival product  

Descriptions should be factual and neutral.

#### Design Notes
- The two products should solve the *same underlying problem*.    
- Avoid vague categories such as “other apps” or “competitors.”    
- Avoid persuasive language or marketing copy.  

Respondents should feel they are comparing two realistic options.





## Evaluating Appeal Before Price

#### Purpose

Allow respondents to express judgment about each product before price is introduced.

Separating evaluation from valuation reduces transactional bias.

#### What to Include
- An appeal rating for the focal product    
- Optionally an appeal rating for the rival product

#### Example Prompts
- “On a scale from 1–10, how appealing is this product overall?”    
- “What do you like most about this?”    
- “What concerns you or gives you pause?”  

#### Design Notes
- Appeal ratings provide diagnostic insight but do not measure demand.    
- Open-ended feedback can reveal design improvements.    






## *Willingness to Pay*

#### Purpose

Elicit monetary valuation boundaries for both products.

Because competition involves substitution, willingness to pay must be **collected for each product separately**.



#### *Maximum Willingness to Pay*

Ask respondents:

> *What is the most you would be willing to pay for Product A?*.  
> *What is the most you would be willing to pay for Product B?*


These responses anchor later quantity questions.

##### **Design Notes**

- Avoid asking for “reasonable” or “fair” prices.    
- Treat responses as valuation boundaries rather than promises.    
- Ensure respondents understand the defined unit and decision period.  





## Quantity Demand Under Competition

When customers may purchase multiple units, quantity must be measured explicitly.  

To estimate substitution effects, quantity responses must be observed under several price conditions involving *both products*.  

Rather than asking respondents to evaluate many price combinations, the survey uses **anchor scenarios** based on the willingness-to-pay values provided earlier.

This approach balances realism with respondent attention.


### Anchor Quantity Scenarios

For the focal product (Product A), ask quantity under four conditions:

| Price A | Price B |
+---------+---------+
| 0 | 0 |
| max WTP A | 0 |
| 0 | max WTP B |
| max WTP A | max WTP B |



::: {#tbl-example .cell tbl-cap='Training performance results.'}
::: {.cell-output-display}


|Algorithm           |Accuracy |Time  |
|:-------------------|:--------|:-----|
|Random Forest       |96.7%    |0.12s |
|Logistic Regression |81.2%    |0.08s |


:::
:::


<!--

::: {#tbl-PQs .cell tbl-cap='Ask questions about quantity under four conditions'}
::: {.cell-output-display}


|Price_A   |Price_B   |
|:---------|:---------|
|0         |0         |
|0         |max WTP B |
|max WTP_A |0         |
|0         |0         |


:::
:::

-->

Example prompts:

> - If Product A were free and Product B were permanently free, how many units of Product A would you buy per [period]?  
> - If Product A cost $[WTP A] and Product B were free, how many units of Product A would you buy?  
> - If Product A were free and Product B cost $[WTP B], how many units of Product A would you buy?  
> - If Product A cost $[WTP A] and Product B cost $[WTP B], how many units of Product A would you buy?  

Repeat the same four conditions for Product B.

These eight responses provide sufficient variation to estimate both demand curves.

The [Competition Analytics app](http://rconnect.byu.edu/CompetitionAnalytics) handles the estimation automatically.


### Why This Structure Is Used

This design minimizes survey fatigue while still capturing:

- own-price sensitivity    
- substitution intensity    
- baseline demand  

Respondents evaluate a small number of meaningful scenarios rather than dozens of artificial price pairs.

Avoid creating custom grids of price combinations.  
Long repetitive surveys produce unreliable data.




## Customer Characteristics

#### Purpose

Enable interpretation of variation in responses and refinement of the target customer definition.

Differences in willingness to pay are often systematic rather than random.

#### What to Include

- Characteristics plausibly related to demand
- Information that helps identify high-value segments

#### Design Notes

- Collect only variables you expect to use.    
- Avoid demographic fishing.    
- Place these questions last to avoid priming earlier responses.






## Minimum Data Structure for the Competition App

The competition analytics app requires data that allow estimation of two demand equations:

\begin{align}
\mathsf{Q_A} &= \mathsf{a_A - b_A P_A + d_A P_B} \\ 

\mathsf{Q_B} &= \mathsf{a_B - b_B P_B + d_B P_A}

\end{align}
  
These parameters capture:

- baseline demand    
- own-price sensitivity    
- substitution between products

Once demand is estimated, the remaining steps—data validation, cost estimation, scaling, and profit analysis—follow the same procedures introduced in earlier toolkits.












## Interpreting the Results (A Caution)

A well-designed competition survey does not “measure” demand directly.

It generates structured evidence about how customers respond to two interacting prices.

That evidence must still be:

- validated,    
- transformed into usable demand functions,    
- combined with cost estimates,    
- and evaluated through equilibrium analysis.  

Competition analytics does not eliminate uncertainty.  
It replaces speculation with structured inference.

The purpose of the survey is therefore not precision—it is *learning the structure of competition* well enough to make disciplined decisions.


<!--
::: {.callout-note title="How this toolkit fits" icon=false collapse=true}
This toolkit builds directly on the toolkit for [*reading a profit curve*](tk9_read_profit.qmd).

It assumes you can already recognize:

- impossible profit,
- fragile profit,
- and robust profit.

Sensitivity does not replace that judgment.
It sharpens it by revealing *where being wrong would matter most*.
:::
-->

