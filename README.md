# r-cannes  
R code to get statistics and charts on Cannes festival  
  
The code consists in loading statistics on the Cannes film festival nominations from csv files.  
Then clean and filter or reorder the data in a useful format.  
Before displaying palmes d'or nomination per countries on a google geo chart.

![Alt Text](https://github.com/benoitantelme/r-cannes/raw/master/screens/nominationMapScreen.png)

And nominations per genre and per decades on pie charts.  

![Alt Text](https://github.com/benoitantelme/r-cannes/raw/master/screens/pieChartsScreen.png)

The tests are using Runit and a script to launch them.  
There is still more data to be displayed on a different format, and analysis to be done.  
Also, I could not use the apply functions as much as I wanted to create the pie charts and merge them conveniently, I had to use for loops.  
  
  
Thanks to Stephen Follows for the initial csv data set, which is not distributed here.
https://github.com/benoitantelme/r-cannes