# Code for importing tables and maps
# Will need to load a few packages
# setwd("C:/Users/danny/Documents/git/SiteMaps/SiteMaps")

## ---- Loadpackages --------

require(leaflet)
require(leaflet.providers)
require(dplyr)
require(knitr)
require(gapminder)
require(htmltools)
require(magrittr)

## ---- Loaddata --------

coords <- read.csv(print(
"C:/Users/danny/Documents/git/SiteMaps/Coordinates.csv"))

my_local_icon_path <- makeIcon(
  iconUrl = "C:/Users/danny/Documents/git/SiteMaps/simpleicon.png",
  iconWidth = 15,
  iconHeight = 15
)

## ---- Loadmap --------

title <- "
<style>
  .custom-title {
    color: #34495e;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
    background-color: rgba(204, 224, 255, 0.9);
    padding: 12px;
    border-radius: 8px;
    transition: background-color 0.3s, box-shadow 0.3s;
}
.custom-title:hover {
    background-color: rgba(204, 224, 255, 0.7);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}
</style>
<h1>
  Mid- to Late-Pleistocene Hominin Sites
</h1>"

legend <- "
<style>
  .custom-legend {
    background-color: rgba(255, 255, 255, 0.8);
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #ddd;
    transition: background-color 0.3s, transform 0.3s;
    width: 300px;
  }
  .custom-legend:hover {
    background-color: rgba(255, 255, 255, 0.9);
    transform: scale(1.05);
  }
</style>
<div>
 <p>
     <a href='https://cusisom.github.io/Research_Methods/' target='_blank'>Hominin Sites</a> identified on this map are also referenced in current research on Chibanian hominin variation. 
  </p>
</div>"

# Create the map
m <- leaflet(data = coords) %>% addTiles() %>%
addProviderTiles(providers$Esri.WorldImagery) %>%
  addMarkers(~Lng, ~Lat, 
  popup = paste("Site:", coords$Site, "<br>",
				"Age:", coords$Age),
  icon = my_local_icon_path,
  label = ~Number,
  labelOptions = labelOptions(noHide = TRUE, textOnly = TRUE, direction = 'left',
	offset = c(-4, -4),
	style = list(
		"color" = "darkgray",
		"font-family" = "serif",
		"font-size" = "16px",
		"font-weight" = "bold"),
  
				))


## ---- Loadtable --------

knitr::kable(coords)


