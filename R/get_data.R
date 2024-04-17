library(tidyverse)
library(here)


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


