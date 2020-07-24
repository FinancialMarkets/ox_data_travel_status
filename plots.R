library(ggplot2)
library(readr)
library(viridis)
library(scales)
library(plotly)
library(htmlwidgets)
options(browser = "/usr/bin/firefox")

african_data <- read_csv("../../african_data.csv")
african_data$Date <- as.Date(as.character(african_data$Date), format = "%Y-%m-%d")

names(african_data)[14] <- "Intl Travel Controls"
african_data$y <- african_data$CountryName

travel_data <- african_data[, names(african_data) %in% c("Date", "CountryName", "Intl Travel Controls")]

travel_data <- travel_data[complete.cases(travel_data), ]

travel_data$CountryName <- factor(travel_data$CountryName,levels=rev(unique(travel_data$CountryName)))

travel_data <- travel_data[travel_data$Date > "2020-02-14", ]

travel_data <- travel_data[travel_data$CountryName != "France",]

p <- ggplot(travel_data, aes(x = Date, y = CountryName, fill = `Intl Travel Controls`)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    geom_tile() +
    scale_fill_gradientn(
#        colours = c("gray81", "lightblue1", "#0066CC"),
        colours = c("gray81", "lightblue1", "#0066CC", "navyblue"), #j orig
        limits = c(0, 4),  ## there are 4 categories
        oob = squish) +
    labs(x = "", y = "") +
    scale_x_date(date_breaks = "2 weeks", date_labels = "%b-%d")


travel <- ggplotly(p)

saveWidget(travel, "travel.html")

