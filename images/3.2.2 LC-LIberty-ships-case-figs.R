library(tidyverse)
library(readxl)

getwd()
#setwd("~/Dropbox/Teaching/ENT 402/R/3.0 Liberty Ship Cost")
tb <- read_xlsx("Liberty Ship data.xlsx") 
tb

summary(tb)

#tb <- tb %>% 
#  mutate(Keel_Date = Delivery_Date - Total_Production_Days)

library(lubridate)
library(RColorBrewer)
library(ggthemes)
library(scales)
library(latex2exp)
library(nleqslv)

ggplot(tb, aes( x = Delivery_Date, y = Total_Production_Days, color = Yard)) + 
  geom_line() + 
  labs(y = "Days in Production", x = "Delivery Date") + 
  scale_y_continuous(lim = c(0,340)) + 
  theme_hc() + 
  #scale_color_manual(values = c("#336600","#336600","#336600","#336600","#336600","#336600")) +
  #scale_color_manual(values = c("#333300","#006633","#336600","#339900","#33FF00","#33FF33")) +
  scale_color_brewer(palette="GnBu", direction=-1) +
  theme(legend.justification=c(0, 1), legend.position=c(1.8, 1)) # puts legend outside the frame
  # deliveries

ggplot(tb, aes( x = Delivery_Date, y = VC, color = Yard)) + 
  geom_line() + 
  labs(y = "Variable Cost per Liberty Ship", x = "Delivery Date") + 
  scale_y_continuous(lim = c(0,5000000), labels=scales::dollar_format()) + 
  theme_hc() + 
  #scale_color_brewer(palette="Oranges", direction=-1) +
  scale_color_brewer(palette="OrRd", direction=-1) +
  theme(legend.justification=c(0, 1), legend.position=c(1.8, 1)) # puts legend outside the frame

#options(scipen=10000)

ggplot(tb, aes( x = Unit, y = VC, color = Yard)) + 
  geom_line() + 
  labs(y = "Variable Cost per Liberty Ship", x = "Cumulative Volume") + 
#  scale_x_continuous(labels = dollar) +
  scale_y_continuous(labels = dollar, lim = c(0,3600000)) + 
  theme_hc() + 
  #scale_color_brewer(palette="Oranges", direction=-1) +
  scale_color_brewer(palette="OrRd", direction=-1) +
  theme(legend.justification=c(0, 1), legend.position=c(1.8, 1)) # puts legend outside the frame


ggplot(tb, aes( x = Unit, y = VC, color = Yard)) + geom_line() # deliveries
ggplot(tb, aes( x = Delivery_Date, y = VC, color = Yard)) + geom_line() # deliveries

ggplot(tb, aes( x = Keel_Date, y = VC, color = Yard)) + geom_line() # deliveries

#
#
#

summary(tb)
mean(log(tb[tb$Unit == 1,]$VC)) # 14.74968
summary(lm(log(VC) ~ log(Unit) + log(Way),  data = tb)) # intercept = log(C1) = 14.755553

mean(log(tb[tb$Unit == 1 & tb$Yard == "Bethlehem",]$VC)) # 14.73235
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Bethlehem", ])) 

summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Bethlehem" & tb$Unit > 100, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Bethlehem" & tb$Unit > 200, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Bethlehem" & tb$Unit > 300, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Bethlehem" & tb$Unit > 350, ])) 

nrow(tb[tb$Yard == "Bethlehem",])

##################################################
##################################################

mean(log(tb[tb$Unit == 1 & tb$Yard == "California",]$VC)) # 14.73235
summary(lm(log(VC) ~ log(Unit) ,  data = tb[tb$Yard == "California", ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "California", ])) 

summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "California" & tb$Unit > 100, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "California" & tb$Unit > 200, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "California" & tb$Unit > 300, ])) 

nrow(tb[tb$Yard == "California",])


(exp(15.0761561) - tb[tb$Unit == 1 & tb$Yard == "California", ]$VC) / exp(15.0761561)


##################################################
##################################################

mean(log(tb[tb$Unit == 1 & tb$Yard == "Oregon",]$VC)) # 14.7769
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon", ])) 

summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon" & tb$Unit > 100, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon" & tb$Unit > 200, ]))
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon" & tb$Unit > 300, ])) 

exp(14.934077) 
  tb[tb$Unit == 1 & tb$Yard == "Oregon", ]$VC
(exp(14.934077) - tb[tb$Unit == 1 & tb$Yard == "Oregon", ]$VC) / exp(14.934077)
  

###################################################
###################################################
  
mean(log(tb[tb$Unit == 1 & tb$Yard == "Oregon",]$VC)) # 14.7769
  
# try this without controlling for the Way
# try this by giving each Way a slope

summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon", ])) 

summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon" & tb$Unit > 100, ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon" & tb$Unit > 200, ]))
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon" & tb$Unit > 300, ])) 

exp(14.934077) 
tb[tb$Unit == 1 & tb$Yard == "Oregon", ]$VC
(exp(14.934077) - tb[tb$Unit == 1 & tb$Yard == "Oregon", ]$VC) / exp(14.934077)  

 
 
###################################################################
###################################################################
###################################################################


summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Bethlehem", ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "California", ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Carolina", ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Delta", ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Houston", ])) 
summary(lm(log(VC) ~ log(Unit) + as.factor(Way),  data = tb[tb$Yard == "Oregon", ])) 






ggplot(tb, aes( x = Experience, y = Deliveries, color = Shipyard)) + geom_line() # deliveries
ggplot(tb, aes( x = Experience, y = Deliveries/Ways, color = Shipyard)) + geom_line() # deliveries/way
ggplot(tb[tb$Shipyard == "Bethlehem",], aes( x = Experience, y = Deliveries/Ways, color = Shipyard)) + geom_line()

tb <- tb %>%
  mutate(lDeliveries = log(Deliveries),
         lExperience = log(Experience),
         lWays = log(Ways),
         lCapital = log(as.numeric(Capital)),
         lLabor = log(Labor)
         ) %>%
  filter(lDeliveries >= 0 & lExperience >= 0 & lLabor >= 0)

summary(tb)
tb

lm(lDeliveries ~ lExperience + lWays + lLabor, data = tb)

summary(lm(lDeliveries ~ lExperience + lLabor + Shipyard, data = tb))

summary(lm(lDeliveries ~ lExperience + lWays + lLabor + Shipyard, data = tb))

summary(lm(lDeliveries ~ lExperience + lWays + lLabor + Shipyard, data = tb[tb$Shipyard == "Bethlehem", ]))

lc <- lm(lDeliveries ~ lExperience + lWays + lLabor + Shipyard, data = tb)
summary(lc)

class(lc)
names(lc)
confint(lc)
hist(residuals(lc))
#par(mar = c(4, 4, 2, 2), mfrow = c(1, 2))
plot(lc, which = c(1, 2))

acf(residuals(lc))
pacf(residuals(lc))


###################33
######################  LEARNING CURVE
####################3

lcb <- lm(log(VC) ~ log(Unit), data = filter(tb, Yard == 'Bethlehem'))
summary(lcb)
Int_b <- unname(coef(lcb)[1]); Int_b
b_b <-  unname(coef(lcb)[2]); b_b
### Create the learning curve function
N = 1 # initialize N

f_Cn <- function(N){
  exp(Int_b) * N^(b_b)
}

### Visualize the learning function
lc_bounds <- tibble(x = c(0, 384))    # Create tibble containing plot range
annotate_Cn <- "$C_n = 2456473 \\cdot N^{-0.05639041}"
ggplot(lc_bounds, aes(x)) +                     # Draw ggplot2 plot
  geom_function(fun = f_Cn, color = "#FE4401", size = 2) +
  geom_point(data = filter(tb, Yard == 'Bethlehem'), mapping = aes(x = Unit, y = VC), size = 1.0) +
  scale_y_continuous( lim = c(1500000,2500000), labels=scales::dollar_format()) +
  labs(#title = "Learning curve for construction of Liberty ships \n at the Bethlehem shipyard",
       x = "Cumulative Volume",
       y = "Variable Cost") +
  theme_hc() +
  annotate("text", x=200, y=2050000, label=TeX(annotate_Cn, output="character"),
           hjust=0.5, size = 4, color = "black", parse = TRUE) 


###################
######################  LEARNING CURVE with TC for BEQ
###################

lc_tc <- lm(log(TC) ~ log(Unit), data = filter(tb, Yard == 'Bethlehem'))
summary(lc_tc)
(Int_b_tc <- unname(coef(lc_tc)[1]))
(b_b_tc <-  unname(coef(lc_tc)[2]))

# Create the learning curve function
f_TC_n <- function(N){exp(Int_b_tc) * N^(b_b_tc)}

### Visualize the learning function
lc_bounds <- tibble(x = c(0, 384))    # Create tibble containing plot range
annotate_TCn <- "$TC_n = 2567945 \\cdot N^{-0.05629487}"
ggplot(lc_bounds, aes(x)) +                     # Draw ggplot2 plot
  geom_segment(aes(x = 85, y = 0, xend = 85, yend = f_TC_n(85) ), linetype="dotted", color = "black", size=0.5) +
  geom_function(fun = f_TC_n, color = "#DA0406", size = 2) +
  geom_point(data = filter(tb, Yard == 'Bethlehem'), mapping = aes(x = Unit, y = TC), size = 1.0) +
  scale_y_continuous( lim = c(00000,2500000), labels=scales::dollar_format()) +
  labs(#title = "Learning curve break-even analysis to cover total cost \n of construction of Liberty ships at the Bethlehem shipyard",
       x = "Cumulative Volume",
       y = "Total Cost") +
  theme_hc() +
  annotate("text", x=90, y=100000, label="Break-even quantity at 85 ships", hjust = 0, size = 4, parse=F) +  
  annotate("text", x=200, y=2150000, label=TeX(annotate_TCn, output="character"),
           hjust=0.5, size = 4, color = "black", parse = TRUE) 



###################
######################  Economies of Scale
###################

tmy <- filter(tb, Yard == 'Bethlehem') %>% 
  group_by(YM = floor_date(Delivery_Date, "month")) %>%  # floor_date rounds to the first day of the month creating a YM variable
  summarise(Q = n(),
            ATC = mean(TC),
            AVC = mean(VC)
  ) %>% 
  ungroup() %>% 
  mutate(N = cumsum(Q)); tmy

ggplot(tmy, aes(x = Q)) +
  geom_line(aes(y = ATC, color = "ATC"), size = 2) + 
  labs(y = "Average total cost per month", x = "Quantity per month") + 
  scale_y_continuous( lim = c(0,3000000), labels=scales::dollar_format()) +
  theme_hc() +
  scale_color_manual(values = "#FC4E07")  + 
  theme(legend.position = "none") 


summary(lib_scale <- lm(log(ATC) ~ log(Q), data = tmy)) # power
# summary(lib_scale <- lm(log(ATC) ~ Q, data = tmy)) # exponential -- choose power


(Int_ls <- coef(lib_scale)[[1]])
(b_ls <- coef(lib_scale)[[2]])


f_ATC_s <- function(Q){exp(Int_ls) * Q^(b_ls)}

### Visualize the learning function
lc_bounds <- tibble(x = c(0, 23))    # Create tibble containing plot range
annotate_ATC_s <- "$ATC = 2438134 \\cdot N^{-0.09123555}$"
ggplot(lc_bounds, aes(x)) +                     # Draw ggplot2 plot
  geom_function(fun = f_ATC_s, color = "#FC4E07", size = 2) +
  geom_point(data = tmy, mapping = aes(x = Q, y = ATC)) +
  scale_y_continuous( lim = c(1500000,2500000), labels=scales::dollar_format()) +
  labs(#title = "Scale curve break-even analysis to cover total cost \n of construction of Liberty ships at the Bethlehem shipyard",
       x = "Quantity",
       y = "Average Total Cost") +
  theme_hc() +
  annotate("text", x=12.5, y=2400000, label=TeX(annotate_ATC_s, output="character"),
           hjust=0.5, size = 4, color = "black", parse = TRUE) 




###################
######################  Combined Scale and Learning Effects
###################


lib_learn_scale <- lm(log(ATC) ~ log(Q) + log(N), tmy)
summary(lib_learn_scale)

(Int_atc_ls <- unname(coef(lib_learn_scale)[1]))
(b_atc_q <- unname(coef(lib_learn_scale)[2]))
(b_atc_n <- unname(coef(lib_learn_scale)[3]))  

