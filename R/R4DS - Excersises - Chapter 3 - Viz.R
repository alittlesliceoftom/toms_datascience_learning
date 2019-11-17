library(ggplot2)
library(tidyverse)
data(mpg)

# 3.2.4 Exercises
# Run ggplot(data = mpg). What do you see?
ggplot(data = mpg) ## empty figure background - 
#presumably as haven't passed instructions of what to plot

#   How many rows are in mpg? How many columns?
length(transpose(mpg)) # 234 rows.  - or nrow(mpg)
length(mpg) # 11 rows
# best - dim(dataset) - https://stats.stackexchange.com/questions/5253/how-do-i-get-the-number-of-rows-of-a-data-frame-in-r/5255#5255?newreg=e7a4fa34001d43caa1b8ef8e977953b6
dim(mpg) # 234 11

#   What does the drv variable describe? Read the help for ?mpg to find out.
?mpg # f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# Make a scatterplot of hwy vs cyl.
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl) )
## i think we want to add some jitter
ggplot(data = mpg) + geom_jitter(mapping = aes(x = hwy, y = cyl), height = 0.1, width = 0.1)

# What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))
ggplot(data = mpg) + geom_jitter(mapping = aes(x = class, y = drv), height = 0.1, width = 0.1)
# - you can't tell how many points at each class. ease with jitter, but still scatters are bad for categorical info

#3.3.1 - AES() = 'Aesthetic'
#1.
#inside the Aes, R maps blue as a label
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
#outside it's recognised as an assignment 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

#2. Which variables in mpg are categorical
classVariables = sapply(mpg, class)

#3 Map a continuous variable to color, size, and shape.
#How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ) ) 
# note we need color inside the aesthetic to make th plot right. 
# continuous variable used... continuously! on color
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ, size = displ, shape = displ) ) 
#Error: A continuous variable can not be mapped to shape 

#What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
?geom_point #-- modifies width of shape edge. 
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

#6. What happens if you map an aesthetic to something other than a variable name,
# like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = year%%5) ) 
# auto bins for you, great feature. Can you do multiple conditions?
# Yep - you just need to def a func that returns multiple. 


# 3.5 - Facets! - Facet_wrap and facet_grid
## Group data and graph groups. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = year)) + 
  facet_grid(drv ~ cyl) ##use a . instead of a var to lose cols or rows. 

# Questions
## 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cty, y = cyl, color = year))+
  facet_wrap(~displ)
## You get a rubbish graph, makes one per value. 

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

#What do the empty cells in plot with facet_grid(drv ~ cyl) mean? 
# Categoris with no values in data. 

# What do these plots make: 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# plots segmented along drive, then along cyl. Single category segmentation

#4. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
#What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
#Adv: Easy to look at each category in isolation. Allows you to use colour for something else!  
#Harder to see where one stops and another begins. 

#3.6 put vars with more unique vals in columns as screens wider than tall. 

### Section 3.6: Geom Objects:
#e.g. smooths: 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth(mapping = aes(linetype = drv)) +
  geom_point()
##note on above - you can have global and local mappings. 

# 3.6.1 -- Questions. 
# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
#A: geom_line(), geom_boxplot(), geom_bar(x = cat, y = count() )
#2. Run code in head and predict what would do:
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
## plot our mean and scatters, without error bars. By Drv on color. 

#3. What does show.legend = FALSE do? What happens if you remove it?
# Why do you think I used it earlier in the chapter?
# Unsure, to keep the graphs looking clean?

#4. What does the se argument to geom_smooth() do?
# Turn off or on standard error areas of Loess smoothing

#Will these two graphs look different? Why/why not?
#A: Graphs will look the same. Same data mapped global and local
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
  
#6. Recreate the R code necessary to generate the following graphs.
# did the 5th one, rest are variants. 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv) )+
  geom_smooth(mapping = aes(linetype = drv))

#### 3.7 Statistical Transforms!!
# Some geoms automatically apply their default stat. E.g. 
# geom_bar() == stat_count().
# This is because each method has the other method as it's default stat/geom.
?geom_bar
## Shows that default stat is "Count" - for geom_bar()
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

## show data proportionally:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
# you have to specify the group that the proportion is being calculated of. 

## 3.7 - Questions
#What is the default geom associated with stat_summary()?
# @todo - can't work out error - "Error: stat_summary requires the following missing aesthetics: y"
ggplot(data = diamonds) +
  geom_pointrange(mapping = aes(x = cut, y = depth ),
                  stat = "summary",
                  ymin = min,
                  ymax = max,
                  y = median)

#2. What does geom_col() do? How is it different to geom_bar()?
# Col represents values, whereas bar counts observations. 

#4. What variables does stat_smooth() compute? What parameters control its behaviour?
# Calculates 'smoothed conditional means' , i.e. a mean conditionalised on the x variable

#5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?
# We need to set this to tell R to group over all the categories. Otherwise it defaults to calculating the 
#proportion inside the group - (dumb behaviour IMO.) - and returns 1. 

# 3.8 - Position
#Notes: Geom Jitter is awesome
ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy), width = 0.2, height = 0.2)
# default of 0.4 is abit aggressive. 

#3.9 coordinate systems - you can do a simple + to change coord systems.
#Coord flip is most useful day to day == transpose.   
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()
#labs() is for label editing. 
?labs

#3.10 - Layered Gammar of Graphics!!
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
    mapping = aes(<MAPPINGS>),
    stat = <STAT>, 
    position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
