library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(tools)
library(lubridate)

# LOAD IN DATASETS
# read in data frames
df <- read_csv("data/crime_clean.csv", col_types = cols())
gdf <- read_csv("data/geo_fortified.csv", col_types = cols())


## FUNCTIONS
plot_filter <- function(df, year = NULL, neighbourhood = NULL, crime = NULL) {
    filtered_df <- df
    if (!is.null(year)) {
        if (typeof(year) == 'list') {
            year_list <- seq(year[[1]], year[[2]])
            filtered_df <- filter(filtered_df, YEAR %in% year_list)
        }
        else {
            filtered_df <- filter(filtered_df, YEAR == year)
        }
    }
    if (!is.null(neighbourhood)) {
        if (length(neighbourhood) == 0) {
            neighbourhood = NULL
        }
        else if (typeof(neighbourhood) == 'list') {
            filtered_df <- filter(filtered_df, DISTRICT %in% neighbourhood)
        }
        else {
            filtered_df <- filter(filtered_df, DISTRICT == neighbourhood)
        }
    }
    if (!is.null(crime)) {
        if (length(crime) == 0) {
            crime = NULL
        }
        else if (typeof(crime) == 'list') {
            filtered_df <- filter(filtered_df, OFFENSE_CODE_GROUP %in% crime)
        }
        else {
            filtered_df <- filter(filtered_df, OFFENSE_CODE_GROUP == crime)
        }
    }
    return(filtered_df)
}
# NOT SURE HOW TO REPLACE THIS
# # use the filtered dataframe to create the map
# # create the geo pandas merged dataframe
# def create_merged_gdf(df, gdf, neighbourhood):
#     df = df.groupby(by = 'DISTRICT').agg("count")
#     if neighbourhood != None:
#         neighbourhood = list(neighbourhood)
#         for index_label, row_series in df.iterrows():
#         # For each row update the 'Bonus' value to it's double
#             if index_label not in neighbourhood:
#                 df.at[index_label , 'YEAR'] = None
#     gdf = gdf.merge(df, left_on='Name', right_on='DISTRICT', how='inner')
#     return gdf



# mapping function based on all of the above
# CHOROPLETH FUNCTION
choro <- function(merged_df){
    choro <- ggplot(merged_df) +
             scale_fill_distiller(palette = "GnBu", direction  = 1) +
             geom_polygon(data = merged_df, aes(fill = count, x = long, y = lat, group = group)) +
             theme_void() +
             coord_map()
    return(choro)
}


# HEATMAP FUNCTION
heatmap <- function(df) {
    heatmap <- ggplot(df, aes(HOUR, DAY_OF_WEEK)) +
                #geom_tile() +
                geom_bin2d() +
                scale_fill_distiller(palette="GnBu", direction=1) +
                theme_minimal() +
                labs(title = 'Occurence of Crime by Hour and Day', x = "Hour of Day", y = "Day of Week", fill = "Crime Count") +
                theme(text = element_text(size = 18), plot.title = element_text(hjust = 0.5)) + 
                theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
    heatmap <- ggplotly(heatmap)
    options(repr.plot.width = 20, repr.plot.height = 10)
    return(heatmap)
}

# TREND PLOT FUNCTION
trendplot <- function(df){
    trend <- df %>%
        group_by(YEAR, MONTH) %>%
        summarise(count = n()) %>%
        mutate(date = make_date(YEAR, MONTH, 1)) %>%
        filter(date > "2015-06-01" & date < "2018-10-01") %>%
        ggplot(aes(x = date, y = count)) +
        geom_line(color = "#00AFBB") +
        labs(title = 'Crime Trend', x = "Date", y = "Crime Count") +
        scale_x_date(date_labels = "%b %Y")
      return(trend)
}

# MAKE CHOROPLETH FUNCTION
make_choropleth <- function(df, gdf, year = NULL, neighbourhood = NULL, crime = NULL) {
    inner_df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime) %>%
            group_by(DISTRICT) %>%
            summarize(count = n()) %>%
            mutate(DISTRICT = str_replace(DISTRICT, "Downtown5", "Charlestown")) 
    # merge with geo data
    merged_df <- inner_join(gdf, inner_df, by = "DISTRICT")
    return(choro(merged_df))
}


# MAKE HEATMAP FUNCTION
make_heatmap_plot <- function(df, year = NULL, neighbourhood = NULL, crime = NULL) {
    df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime)
    return(heatmap(df))
}
# MAKE TRENDPLOT FUNCTION
make_trend_plot <- function(df, year = NULL, neighbourhood = NULL, crime = NULL) {
    df <- plot_filter(df, year = year, neighbourhood = neighbourhood, crime = crime)
    return(trendplot(df))
}

# YEAR RANGE SLIDER
yearMarks <- lapply(unique(df$YEAR), as.character)
names(yearMarks) <- unique(df$YEAR)

yearSlider <- dccRangeSlider(
  id = "year",
  marks = yearMarks,
  min = 2015,
  max = 2018,
  step = 4,
  value = NULL
)

# CRIME DROPDOWN
crime_key <- tibble(label = sort(toTitleCase(tolower(unique(as.character(df$OFFENSE_CODE_GROUP))))),
                   value = sort(as.character(unique(df$OFFENSE_CODE_GROUP))))

crimeDropdown <- dccDropdown(
  id = "crime",
  options = lapply(
    1:nrow(crime_key), function(i){
      list(label=crime_key$label[i], value=crime_key$value[i])
    }),
  value = NULL,
  style=list(width='95%'),
  multi = TRUE
)

# NEIGHBOURHOOD DROPDOWN

neigbourhood_key <- tibble(label = sort(toTitleCase(unique(as.character(df$DISTRICT)))),
                   value = sort(as.character(unique(df$DISTRICT))))

neighbourhoodDropdown <- dccDropdown(
  id = "neighbourhood",
  options = lapply(
    1:nrow(neigbourhood_key), function(i){
      list(label=neigbourhood_key$label[i], value=neigbourhood_key$value[i])
    }),
  value = NULL,
  style=list(width='95%'),
  multi = TRUE
)

graph <- dccGraph(
  id = 'choro-map',
  figure = ggplotly(make_choropleth(df, gdf))
)
graph2 <- dccGraph(
  id = 'line-graph',
  figure = ggplotly(make_trend_plot(df))
)
graph3 <- dccGraph(
  id = 'heat-map',
  figure = make_heatmap_plot(df)
)
graph4 <- dccGraph(
  id = 'bar-graph',
  # TODO: Update this with function calls for bar graph
  # figure = 
)

external_stylesheets = 'https://codepen.io/chriddyp/pen/bWLwgP.css'

app <- Dash$new(external_stylesheets = external_stylesheets) 


# colour dictionary
colors <- list(
  white = '#ffffff',
  light_grey = '#d2d7df',
  ubc_blue = "#082145"
)

app$layout(
  htmlDiv(
    list(
      htmlH2('Boston Crime Dashboard', 
             style = list( color = colors$white)),
      htmlP("This Dash app will allow users to explore crime in Boston across time and space. The data set consists of over 300,000 Boston crime records between 2015 and 2018. Simply drag the sliders to select your desired year range. Select one or multiple values from the drop down menus to select which neighbourhoods or crimes you would like to explore. These options will filter all the graphs in the dashboard.", style = list( color = colors$white))), style = list(backgroundColor = colors$ubc_blue, 'padding' =  10)),
 htmlDiv(
 list(
   #  htmlP("This is a thing", style = list( color = colors$white)),
     htmlP("Filter by year", style = list(textAlign = 'center')),
     yearSlider, 
     htmlBr(),
     htmlBr(),
     htmlP("Filter by neighbourhood", style = list(textAlign = 'center')),
     neighbourhoodDropdown,
     htmlBr(),
     htmlP("Filter by crime", style = list(textAlign = 'center')),
     crimeDropdown,
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr(),
     htmlBr()
     ), className = "two columns", style = list(backgroundColor = colors$light_grey, "margin-left"= "0px",
                                                "margin-top"= "0px", 'padding' =  20)),
 htmlDiv(
 list(
      graph, 
      graph2), className = "five columns")
,

htmlDiv(
 list(
      graph3, 
      graph4), className = "five columns")
)
 

app$run_server()