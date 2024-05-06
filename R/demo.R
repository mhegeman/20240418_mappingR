library(tidyverse)
library(sf)



# reading in a csv file with coordinate info ------------------------------

f <- here::here('data', 'noaa_chart_area_check.csv')
#

points <- read_sf(f, options=c("X_POSSIBLE_NAMES=x","Y_POSSIBLE_NAMES=y"))

plot(points["sub_area_code"])

plot(st_geometry(points), axes = TRUE)

# points1 <- points %>%
#   filter(x < 0 & y > 0 )



# reading a shapefile -----------------------------------------------------



noaa_stat_area <- read_sf("data/ny_nj_ri_inshore_areas_NAD83.shp")
plot(noaa_stat_area)
plot(st_geometry(noaa_stat_area), axes = TRUE)




# basic plotting ----------------------------------------------------------
plot(points1["sub_area_code"])
plot(st_geometry(points1), axes = TRUE)

plot(st_geometry(noaa_stat_area), axes = TRUE)
plot(st_geometry(points1["sub_area_code"]))


# use ggplot --------------------------------------------------------------

library(ggplot2)

p <- ggplot() +
  geom_sf(data = noaa_stat_area) +
  geom_sf(data = points)
plot(p)


points_csv <- read_csv(f)

points_wgs84 <- st_as_sf(points_csv %>%
                           filter(x < 0 & y > 0),
                         coords = c('x', 'y'),
                         crs = 4326)


p1 <- ggplot() +
  geom_sf(data = noaa_stat_area) +
  geom_sf(data = points_wgs84)+
  labs(title = "Fishing in NY") +
  theme_minimal()
plot(p1)



# arcgis online -----------------------------------------------------------

library(httr)
library(sf)
library(tmap)

url <- parse_url("https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services")


url$path <- paste(url$path, "State_Reporting_Areas/FeatureServer/0/query", sep = "/")
url$query <- list(where = "STATE = 'NY'",
                  outFields = "*",
                  returnGeometry = "true",
                  f = "geojson")
request <- build_url(url)

stat_areas <- st_read(request)

tmap_mode(mode = "view")
tm_shape(Florida_Railroads)+tm_lines(col="NET_DESC", palette = "Set1", lwd = 5)
