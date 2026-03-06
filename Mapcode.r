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
require(RefManageR)
require(devtools)
require(flextable)
require(ftExtra)
require(officer)

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

coordsX <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/CalabrianWEA.csv"))

coords3 <- coordsX %>%select(-Country, -Ref.)

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
  values = 5,
  shape = 'diamond',
  color = 'black',
  fillColor = 'blue',
  opacity = 2,
  baseSize = 9
)

## ---- Loadmap3 --------

f <- leaflet(data = coords3) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldPhysical) %>%
  # 1. Static Diamonds
  addMarkers(
    ~Lng, ~Lat, 
    popup = paste("Site:", coords3$Site, "<br>", "Age:", coords3$Proposed.Absolute.Age),
    icon = symbols
  ) %>%
  # 2. Draggable Ghost Labels
  addMarkers(
    ~Lng, ~Lat,
    # This makes the blue pin invisible but keeps the 'drag handle' active
    options = markerOptions(draggable = TRUE, opacity = 0), 
    label = ~Number,
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE, 
      direction = 'left', # Better for clicking directly on the number
      style = list(
        "color" = "black",
        "font-family" = "serif",
        "font-size" = "11px",
        "font-weight" = "bold")
    )
  )

f

htmltools::save_html(f, file = "C:/Users/danny/Documents/git/SiteMaps/Output/paleomap3.html")

## ---- Loadtable3 --------

colnames(coords3) <- c("Number", "Site", "Proposed Absolute Age (Ma)", "Dating Method", "Paleontology", "Archaeology", "Hominin Fossils", "Lat", "Long", "Ref")

knitr::kable(coords3, align = "c")

## ---- PrintTable3 --------

standard_border <- fp_border(color = "black", width = 1)

# 1. Create table with specific columns
ft <- flextable(coords3, col_keys = c("Number", "Site", "Proposed Absolute Age (Ma)", "Dating Method", "Paleontology", 
"Archaeology", "Hominin Fossils", "Ref"))

# 2. RENAME HEADERS (Crucial for fit!)
# This keeps the data the same but makes the labels shorter in Word
ft <- set_header_labels(ft, 
  `Proposed.Absolute.Age..Ma.` = "Age (Ma)",
  Dating.Method = "Dating Method",
  Hominin.Fossils = "Hominin Fossils"
)

# 3. Apply Markdown and Borders
ft <- colformat_md(ft, j = c("Dating Method", "Paleontology", "Hominin Fossils", "Ref")) |>
    border_outer(border = standard_border) |>
    border_inner_h(border = standard_border) |>
    border_inner_v(border = standard_border)

# 4. FIXED LAYOUT (Prevents the "Blank Table" error)
# This forces the table to be 100% of the page width and wrap text
ft <- set_table_properties(ft, layout = "fixed", width = 1) |>
      fontsize(size = 9, part = "all") |>
      align(align = "center", part = "header")

# 5. Since the table is now full-width, give specific columns more "room"
# You can set relative widths: 1.5 for text-heavy cols, 0.8 for short ones
ft <- width(ft, j = "Number", width = .3)
ft <- width(ft, j = "Site", width = 1)
ft <- width(ft, j = "Proposed Absolute Age (Ma)", width = 0.6)
ft <- width(ft, j = "Paleontology", width = 2.5) # Give the wide one more space

# 6. Ensure text wraps inside the cells so they don't look cramped
ft <- padding(ft, padding = 4, part = "all")

# 7. Save (Ensure the file is closed in Word first!)
save_as_docx(ft, path = "C:/Users/danny/Documents/git/SiteMaps/Output/Calabrian_Table.docx")

## ---- References1 --------

bib <- ReadBib("C:/Users/danny/Documents/git/SiteMaps/references.bib", check = FALSE)

# 1. Create a working copy
bib_clean <- bib
bib_clean$urldate <- NULL
bib_clean$doi <- NULL
bib_clean$url <- NULL

# 2. Sort it alphabetically (Standard APA)
bib_clean <- sort(bib_clean)

# 3. Print with manual numbering
for (i in seq_along(bib_clean)) {
  cat(paste0(i, ". ")) # This prints the number "1. ", "2. ", etc.
  print(bib_clean[i], .opts = list(
    style = "markdown", 
    bib.style = "authoryear", 
    first.inits = TRUE,
    dashed = FALSE
  ))
  cat("\n") # Adds a space between entries
}

## ---- Loaddata4 --------

coordsX <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/ChibanianWEA.csv"))

coords4 <- coordsX %>%select(-Country, -Ref., -Notes)

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


symbols <- makeSymbolIcons(
  shape = ifelse(coords4$Category == "Fossil", "star",
          ifelse(coords4$Category == "Arch", "circle", "diamond")),
  color = 'black',
  fillColor = 'white',
  opacity = 1,
  width = 10, 
  height = 10
)

## ---- Loadmap4 --------
# 1. Subset the data
coords_clustered <- coords4[coords4$Group %in% c("A", "B"), ]
coords_static    <- coords4[coords4$Group == "C", ]

# 2. Subset the icons to match the data
symbols_clustered <- symbols[coords4$Group %in% c("A", "B")]
symbols_static    <- symbols[coords4$Group == "C"]

f <- leaflet() %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldPhysical) %>%
  
  # 1. Clustered Markers (Groups A & B) - NO LABELS
  addMarkers(
    data = coords_clustered,
    ~Lng, ~Lat, 
    popup = paste("Site:", coords_clustered$Site, "<br>", "Age:", coords_clustered$Proposed.Absolute.Age),
    icon = symbols_clustered,
    clusterOptions = markerClusterOptions()
  ) %>%
  
  # 2. Static Markers (Group C)
  addMarkers(
    data = coords_static,
    ~Lng, ~Lat, 
    popup = paste("Site:", coords_static$Site, "<br>", "Age:", coords_static$Proposed.Absolute.Age),
    icon = symbols_static
  ) %>%
  
  # 3. Draggable Labels (ONLY for Group C)
  addMarkers(
    data = coords_static,
    ~Lng, ~Lat,
    options = markerOptions(draggable = TRUE, opacity = 0), 
    label = ~Number,
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE, 
      direction = 'left',
      style = list(
        "color" = "black",
        "font-family" = "serif",
        "font-size" = "11px",
        "font-weight" = "bold")
    )
  )

f


htmltools::save_html(f, file = "C:/Users/danny/Documents/git/SiteMaps/Output/paleomap4.html")

## ---- Loadtable4 --------

colnames(coords4) <- c("Number", "Site", "Proposed Absolute Age (Ma)", "Dating Method", "Paleontology", "Archaeology", "Hominin Fossils", "Lat", "Long", "Ref")

knitr::kable(coords4, align = "c")

## ---- PrintTable3 --------

standard_border <- fp_border(color = "black", width = 1)

# 1. Create table with specific columns
ft <- flextable(coords4, col_keys = c("Number", "Site", "Proposed Absolute Age (Ma)", "Dating Method", "Paleontology", 
"Archaeology", "Hominin Fossils", "Ref"))

# 2. RENAME HEADERS (Crucial for fit!)
# This keeps the data the same but makes the labels shorter in Word
ft <- set_header_labels(ft, 
  `Proposed.Absolute.Age..Ma.` = "Age (Ma)",
  Dating.Method = "Dating Method",
  Hominin.Fossils = "Hominin Fossils"
)

# 3. Apply Markdown and Borders
ft <- colformat_md(ft, j = c("Dating Method", "Paleontology", "Hominin Fossils", "Ref")) |>
    border_outer(border = standard_border) |>
    border_inner_h(border = standard_border) |>
    border_inner_v(border = standard_border)

# 4. FIXED LAYOUT (Prevents the "Blank Table" error)
# This forces the table to be 100% of the page width and wrap text
ft <- set_table_properties(ft, layout = "fixed", width = 1) |>
      fontsize(size = 9, part = "all") |>
      align(align = "center", part = "header")

# 5. Since the table is now full-width, give specific columns more "room"
# You can set relative widths: 1.5 for text-heavy cols, 0.8 for short ones
ft <- width(ft, j = "Number", width = .3)
ft <- width(ft, j = "Site", width = 1)
ft <- width(ft, j = "Proposed Absolute Age (Ma)", width = 0.6)
ft <- width(ft, j = "Paleontology", width = 2.5) # Give the wide one more space

# 6. Ensure text wraps inside the cells so they don't look cramped
ft <- padding(ft, padding = 4, part = "all")

save_as_docx(ft, path = "C:/Users/danny/Documents/git/SiteMaps/Output/ChibanianWEA_Table.docx")

## ---- References2 --------

bib <- ReadBib("C:/Users/danny/Documents/git/SiteMaps/references2.bib", check = FALSE)

# 1. Create a working copy
bib_clean <- bib
bib_clean$urldate <- NULL
bib_clean$doi <- NULL
bib_clean$url <- NULL

# 2. Sort it alphabetically (Standard APA)
bib_clean <- sort(bib_clean)

# 3. Print with manual numbering
for (i in seq_along(bib_clean)) {
  cat(paste0(i, ". ")) # This prints the number "1. ", "2. ", etc.
  print(bib_clean[i], .opts = list(
    style = "markdown", 
    bib.style = "authoryear", 
    first.inits = TRUE,
    dashed = FALSE
  ))
  cat("\n") # Adds a space between entries
}

## ---- Loaddata5 --------


coords5 <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/CalabrianEA.csv"))



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
  values = 5,
  shape = 'diamond',
  color = 'black',
  fillColor = 'black',
  opacity = 15,
  baseSize = 10
)

## ---- Loadmap5 --------

f <- leaflet(data = coords5) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldPhysical) %>%
  # 1. Static Diamonds
  addMarkers(
    ~Lng, ~Lat, 
    popup = paste("Site:", coords5$Site, "<br>", "Age:", coords5$Proposed.Absolute.Age),
    icon = symbols
  ) %>%
  # 2. Draggable Ghost Labels
  addMarkers(
    ~Lng, ~Lat,
    # This makes the blue pin invisible but keeps the 'drag handle' active
    options = markerOptions(draggable = TRUE, opacity = 0), 
    label = ~Number,
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE, 
      direction = 'left', # Better for clicking directly on the number
      style = list(
        "color" = "black",
        "font-family" = "serif",
        "font-size" = "11px",
        "font-weight" = "bold")
    )
  )

f

## ---- Loaddata6 --------


coords6 <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/ChibanianEA.csv"))



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
  values = 5,
  shape = 'diamond',
  color = 'black',
  fillColor = 'black',
  opacity = 15,
  baseSize = 10
)

## ---- Loadmap6 --------

f <- leaflet(data = coords6) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldPhysical) %>%
  # 1. Static Diamonds
  addMarkers(
    ~Lng, ~Lat, 
    popup = paste("Site:", coords6$Site, "<br>", "Age:", coords6$Proposed.Absolute.Age),
    icon = symbols
  ) %>%
  # 2. Draggable Ghost Labels
  addMarkers(
    ~Lng, ~Lat,
    # This makes the blue pin invisible but keeps the 'drag handle' active
    options = markerOptions(draggable = TRUE, opacity = 0), 
    label = ~Number,
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE, 
      direction = 'center', # Better for clicking directly on the number
      style = list(
        "color" = "black",
        "font-family" = "serif",
        "font-size" = "11px",
        "font-weight" = "bold")
    )
  )

f
## ---- Loaddata7 --------


coords7 <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/LP_EA.csv"))



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
  values = 5,
  shape = 'diamond',
  color = 'black',
  fillColor = 'black',
  opacity = 15,
  baseSize = 10
)

## ---- Loadmap7 --------

f <- leaflet(data = coords7) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldPhysical) %>%
  # 1. Static Diamonds
  addMarkers(
    ~Lng, ~Lat, 
    popup = paste("Site:", coords7$Site, "<br>", "Age:", coords7$Proposed.Absolute.Age),
    icon = symbols
  ) %>%
  # 2. Draggable Ghost Labels
  addMarkers(
    ~Lng, ~Lat,
    # This makes the blue pin invisible but keeps the 'drag handle' active
    options = markerOptions(draggable = TRUE, opacity = 0), 
    label = ~Number,
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE, 
      direction = 'center', # Better for clicking directly on the number
      style = list(
        "color" = "black",
        "font-family" = "serif",
        "font-size" = "11px",
        "font-weight" = "bold")
    )
  )

f

## ---- Loaddata8 --------

coordsX <- read.csv(print("C:/Users/danny/Documents/git/SiteMaps/LatePleisWEA.csv"))

coords8 <- coordsX %>%select(-Country, -Ref., -Notes)

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
  values = 5,
  shape = 'diamond',
  color = 'black',
  fillColor = 'black',
  opacity = 15,
  baseSize = 10
)

## ---- Loadmap8 --------

f <- leaflet(data = coords8) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldPhysical) %>%
  # 1. Static Diamonds
  addMarkers(
    ~Lng, ~Lat, 
    popup = paste("Site:", coords8$Site, "<br>", "Age:", coords8$Proposed.Absolute.Age),
    icon = symbols
  ) %>%
  # 2. Draggable Ghost Labels
  addMarkers(
    ~Lng, ~Lat,
    # This makes the blue pin invisible but keeps the 'drag handle' active
    options = markerOptions(draggable = TRUE, opacity = 0), 
    label = ~Number,
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE, 
      direction = 'left', # Better for clicking directly on the number
      style = list(
        "color" = "black",
        "font-family" = "serif",
        "font-size" = "11px",
        "font-weight" = "bold")
    )
  )

f

htmltools::save_html(f, file = "C:/Users/danny/Documents/git/SiteMaps/Output/LP_WEA.html")

## ---- Loadtable8 --------

colnames(coords8) <- c("Number", "Site", "Proposed Absolute Age (Ma)", "Dating Method", "Paleontology", "Archaeology", "Hominin Fossils", "Lat", "Long", "Ref")

knitr::kable(coords8, align = "c")

## ---- PrintTable8 --------

standard_border <- fp_border(color = "black", width = 1)

# 1. Create table with specific columns
ft <- flextable(coords8, col_keys = c("Number", "Site", "Proposed Absolute Age (Ma)", "Dating Method", "Paleontology", 
"Archaeology", "Hominin Fossils", "Ref"))

# 2. RENAME HEADERS (Crucial for fit!)
# This keeps the data the same but makes the labels shorter in Word
ft <- set_header_labels(ft, 
  `Proposed.Absolute.Age..Ma.` = "Age (Ma)",
  Dating.Method = "Dating Method",
  Hominin.Fossils = "Hominin Fossils"
)

# 3. Apply Markdown and Borders
ft <- colformat_md(ft, j = c("Dating Method", "Paleontology", "Hominin Fossils", "Ref")) |>
    border_outer(border = standard_border) |>
    border_inner_h(border = standard_border) |>
    border_inner_v(border = standard_border)

# 4. FIXED LAYOUT (Prevents the "Blank Table" error)
# This forces the table to be 100% of the page width and wrap text
ft <- set_table_properties(ft, layout = "fixed", width = 1) |>
      fontsize(size = 9, part = "all") |>
      align(align = "center", part = "header")

# 5. Since the table is now full-width, give specific columns more "room"
# You can set relative widths: 1.5 for text-heavy cols, 0.8 for short ones
ft <- width(ft, j = "Number", width = .3)
ft <- width(ft, j = "Site", width = 1)
ft <- width(ft, j = "Proposed Absolute Age (Ma)", width = 0.6)
ft <- width(ft, j = "Paleontology", width = 2.5) # Give the wide one more space

# 6. Ensure text wraps inside the cells so they don't look cramped
ft <- padding(ft, padding = 4, part = "all")

save_as_docx(ft, path = "C:/Users/danny/Documents/git/SiteMaps/Output/LPWEA_Table.docx")