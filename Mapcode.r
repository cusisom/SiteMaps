# Code for importing tables and maps
# Will need to load a few packages
# setwd("C:/Users/danny/Documents/git/SiteMaps")

## ---- Loadpackages --------

library(leaflet)
require(leaflet.providers)
library(dplyr)
require(knitr)
require(gapminder)
library(htmltools)
require(magrittr)
require(tidyr)
library(leaflegend)
require(skimr)
require(knitr)

## ---- Loaddata --------

# load in the excel spreadsheet for the datatable

coords <- read.csv(print(
"C:/Users/danny/Documents/git/SiteMaps/Coordinates.csv"))

colnames(coords) <- c("Site_Number", "Lng", "Lat", "Site Name", "Age", "Period")

# I need to set some parameters for how I want the map to be designed. This first parameter is for the icons used. For more details visit https://roh.engineering/posts/2021/05/map-symbols-and-size-legends-for-leaflet/


custom_div <- tags$div(
  HTML("<h3>Custom Styled Div</h3><p>This is an absolutely positioned HTML element overlaying the map.</p>"),
  style = "position: absolute; 
           top: 20px; 
           right: 20px; 
           z-index: 1000; /* Ensures the div is above map tiles but below some controls */
           background-color: rgba(255, 255, 255, 0.8); 
           padding: 15px; 
           border-radius: 5px; 
           width: 200px;
           box-shadow: 0 4px 8px rgba(0,0,0,0.1);"
)


symbols <- makeSymbolsSize(
  values = 10,
  shape = 'diamond',
  color = 'black',
  fillColor = 'black',
  opacity = 1,
  baseSize = 10
)

tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title {
    background: rgba(255,255,255,0.7);
    padding: 10px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }
"))
title <- tags$div(tag.map.title, HTML("CLP Hominin Sites"))


## ---- Loadmap --------


m <- leaflet(data = coords)|> addTiles() |>
addControl(title, position = "topleft", className = "map-title") |>
addProviderTiles(providers$Esri.WorldPhysical) |>
  addMarkers(~Lng, ~Lat, 
  popup = paste("Site:", coords$Site, "<br>",
				"Age:", coords$Age),
  icon = symbols,
  label = ~Site_Number,
  labelOptions = labelOptions(noHide = TRUE, textOnly = TRUE, direction = 'left',
	offset = c(-4, -4),
	style = list(
		"color" = "black",
		"font-family" = "serif",
		"font-size" = "16px",
		"font-weight" = "bold"),
  
				))
m

htmltools::save_html(m, file = "C:/Users/danny/Documents/git/SiteMaps/paleomapex.html")

## ---- Loadtable --------


knitr::kable(coords, align = "c")

## ---- Loaddata2 --------


coords1 <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/EPleis.csv"))

## ---- Loadmap2 --------

d <- leaflet(data = coords1)|> addTiles() |>
addProviderTiles(providers$Esri.WorldPhysical) |>
  addMarkers(~Long, ~Lat, 
  popup = paste("Site:", coords1$Site, "<br>",
				"Age:", coords1$Proposed.Absolute.Age),
  icon = symbols,
  label = ~Number,
  labelOptions = labelOptions(noHide = TRUE, textOnly = TRUE, direction = 'left',
	offset = c(-2, -2),
	style = list(
		"color" = "black",
		"font-family" = "serif",
		"font-size" = "16px",
		"font-weight" = "bold"),
  
				))
d

htmltools::save_html(d, file = "C:/Users/danny/Documents/git/SiteMaps/paleomap2.html")

## ---- Loadtable2 --------

colnames(coords1) <- c("Number", "Site", "Proposed Absolute Age", "Dating Method", "Paleontology", "Archaeology", "Hominin Fossils", "Lat", "Long", "Ref.")

knitr::kable(coords1, align = "c")

## ---- Loaddata3 --------

coords3 <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/CalabrianWEA.csv"))

## ---- Loadmap3 --------

f <- leaflet(data = coords3)|> addTiles() |>
addProviderTiles(providers$Esri.WorldPhysical) |>
  addMarkers(~Lng, ~Lat, 
  popup = paste("Site:", coords1$Site, "<br>",
				"Age:", coords1$Proposed.Absolute.Age),
  icon = symbols,
  label = ~Number,
  labelOptions = labelOptions(noHide = TRUE, textOnly = TRUE, direction = 'left',
	offset = c(-2, -2),
	style = list(
		"color" = "black",
		"font-family" = "serif",
		"font-size" = "16px",
		"font-weight" = "bold"),
  
				))
f

htmltools::save_html(f, file = "C:/Users/danny/Documents/git/SiteMaps/paleomap3.html")

## ---- Loadtable3 --------

colnames(coords3) <- c("Number", "Site", "Proposed Absolute Age", "Dating Method", "Paleontology", "Archaeology", "Hominin Fossils", "Lat", "Long", "Ref.")

knitr::kable(coords3, align = "c")
