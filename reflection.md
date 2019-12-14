## Reflections on Milestone 4
### Dashboard strengths
- The app is aesthetically pleasing. Matching colour scheme across the dropdown menus, the sliders and the plots themselves. Unique visualizations such as the choropleth of Boston and heatmap are visually pleasing and informative. The app layout allows the user  access to the dropdown menus while also being able to see every single plot. That way the user can instantly see the change in each plot when a filter is applied.  
- The app incorporates a wide range of different visualizations in order to deliver a wide range of information regarding crime in Boston. 
- It gives the user a variety of ways to filter and select the dataset, with sliders and dropdown menus. It gives the user a lot of options to see which portion of the data are most relevant for each user. 
- The app is responsive to the sliders and dropdown menus. Every graph updates in order to display the user’s selected options. 

### Internal Critiques / Bugs 
- One potential point of improvement is the drop-down menu, where the initial default is going to include every single possible option to select from. However, this makes the drop-down box very long dragging out the entire webpage. There is now a lot of empty space below the plots just to accommodate the drop-down menu. One potential solution for this is to include an option in the drop-down menu called “All” for all the possible options. 
- We discovered a bug in Plotly while working with the Heat-map and Choropleth. The bug is that the legend will turn red from the default blue theme, when the count value in the Heat-map is very low or only when one neighbourhood is displayed in the Choropleth. We’ve talked to Firas about this issue, and he told us to stop pursuing this issue and stated it was a bug in Plotly.
- Another issue we've discovered using Plotly is that we could not get the Plotly modebar to disappear. We followed instructions provided online meant to fix the issue. However, the issue still persists after we tried multiple solutions. 

  
### Peer Feedback and Updates to App
We received valuable information both from watching our peers interact with our app, and also from their [helpful feedback](https://github.com/UBC-MDS/DSCI-532_gr202_dashboard/issues/54).  Overall, users enjoyed our aesthetics and the functionality of the app, and for the most part used the app as we had intended. However, a few specific areas of improvement were noted, which we address below: 
- The major complaint with the app, which was consistent across all reviewers was that our app deployment on Heroku is [very slow](https://github.com/UBC-MDS/DSCI-532_gr202_dashboard/issues/53), as has been documented above. We've significantly improved the speed of our app for Milestone 4
  - In order to improve the speed of our app, we've decided to use a smaller dataset which only incorporates the data associated with the top ten most commited crimes. This significantly reduced our overhead and our app can load much quicker than before. 
- Another suggestion we've received is that many wanted to be able to vizualize how the trend of crime changes over the years. So we've added 4 lines in the crime trend plots to visualize trends across years. 
- We were able to get custom tooltip for the choropleth, heatmap and the bar graph in order to display relevant information of those plots in an aesthetically pleasing manner. However, when we tried to customize the tooltip for the trend graph, the lines disappear. We believe this is most likely a Plotly or Dash bug. Therefore, we are just using default tooltip for the trend graph. (Which is why the month section of the tooltip shows a POSTIX date with year as 0)
- We've also incorporated increased interactivity on our plots (such as zooming and panning functionalities) utilizing Plotly. This implementation was carried out based on TA feedback. 
- We've talked to Firas regarding whether to normalize the choropleth map to percentages instead of counts. Firas suggested to leave the choropleth as it is, and just display the count of crime committed instead of percentages. 


### App Maintenance 
Every prevalent functions have [docstrings](https://github.com/UBC-MDS/DSCI-532_gr202_dashboard/issues/56) included in order to maintain and uphold best coding practices.

### Note 
Many of the issues referenced above were given to us on our personal Github repos. Therefore, we can't link it in this document. 

### Github Issues
- Teammate Issues 
  - Whenever a team member spotted a bug or issue related to the app, they created a GitHub issue ([example](https://github.com/UBC-MDS/DSCI-532_gr202_dashboard/issues/41)). A succinct and descriptive message regarding the problem is written. In which, other team members can attempt to fix the problem. After the problem is fixed, the specific commit was referenced to that issue. 
- TA Issues
  - Teamwork contract has been updated in the individual repo to be more specific as per the request of the [TA](https://github.com/UBC-MDS/DSCI-532_gr202_dashboard/issues/40).
  - [Proposal](https://github.com/UBC-MDS/DSCI-532_gr202_dashboard/blob/master/Proposal.md) has been updated to reference count instead of density and count instead of rates. 
