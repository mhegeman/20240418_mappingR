library(cmfs)
lapply(package_list(), library, character.only = TRUE)
db <- 'CMFS_prod'


library(tidyverse)
library(here)
library(sf)




# reading shapefiles ------------------------------------------------------

library(sf)

noaa_stat_area <- st_read("data/ny_nj_ri_inshore_areas_NAD83.shp")
plot(noaa_stat_area)


con <- DBI::dbConnect(odbc::odbc(), db, timeout = 10)

chart_area_qry <- glue::glue("SELECT TOP(100) DATA_LOG_ID, LATD, LATM, LOND, LONM, SUB_AREA_CODE FROM VIEW_VTRS WHERE SUB_AREA_CODE < 300")
chart_area <- DBI::dbGetQuery(con, chart_area_qry) %>%
  janitor::clean_names() %>%
  mutate(y = as.numeric(paste0(latd, ".", latm)),
         x = as.numeric(paste0('-', lond, ".", lonm))) %>%
  select(data_log_id, sub_area_code, x, y)

DBI::dbDisconnect(con)

write_csv(chart_area, "data/noaa_chart_area_check.csv")


# create eclipse csv ------------------------------------------------------


get_eclipse_data <- function() {

  eclipse_annular_2023 <- read_csv('data/eclipse_annular_2023.csv') %>%
    mutate(eclipse_year = 2023,
           eclipse_date = ymd('2023-10-14'),
           eclipse_type = 'annular')
  eclipse_total_2024 <- read_csv('data/eclipse_total_2024.csv') %>%
    mutate(eclipse_year = 2024,
           eclipse_date = ymd('2024-04-08'),
           eclipse_type = 'total')
  eclipse_partial_2023 <- read_csv('data/eclipse_partial_2023.csv') %>%
    mutate(eclipse_year = 2023,
           eclipse_date = ymd('2023-10-14'),
           eclipse_type = 'partial')
  eclipse_partial_2024 <- read_csv('data/eclipse_partial_2024.csv') %>%
    mutate(eclipse_year = 2024,
           eclipse_date = ymd('2024-04-08'),
           eclipse_type = 'partial')

  eclipse_data <- bind_rows(eclipse_annular_2023, eclipse_total_2024, eclipse_partial_2023, eclipse_partial_2024)

}

eclipse_data <- get_eclipse_data()

write_csv(eclipse_data, here('data', 'solar_eclipse_data.csv'))

scatter <- ggplot(eclipse_data, aes(x = lon, y = lat, group = state)) +
  geom_point()
plot(scatter)



