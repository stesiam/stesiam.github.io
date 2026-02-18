library(ggplot2)
library(sf)
library(rnaturalearth)
library(dplyr)
library(viridis)
library(cowplot)

oecd_countries <- c(
  "Australia","Austria","Belgium","Canada","Chile","Colombia",
  "Costa Rica","Czech Republic","Denmark","Estonia","Finland",
  "France","Germany","Greece","Hungary","Iceland","Ireland",
  "Israel","Italy","Japan","Korea","Latvia","Lithuania",
  "Luxembourg","Mexico","Netherlands","New Zealand","Norway",
  "Poland","Portugal","Slovakia","Slovenia","Spain","Sweden",
  "Switzerland","Türkiye","United Kingdom","United States of America"
)
world <- ne_countries(scale = "large", returnclass = "sf")
world_clean <- world %>%
  filter(admin != "Antarctica") %>%
  mutate(OECD = ifelse(admin %in% oecd_countries, "OECD Member", "Non-Member"))
map_oecd <- ggplot(world_clean) +
  geom_sf(aes(fill = OECD), color = "white", size = 0.15) +
  scale_fill_manual(
    values = c("OECD Member" = "#2C7BB6",
               "Non-Member" = "grey90")
  ) +
  coord_sf(crs = "+proj=robin") +
  labs(
    title = "OECD Member Countries",
    subtitle = "Organisation for Economic Co-operation and Development (38 Members)",
    caption = "Source: OECD | Map data: Natural Earth"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank()
  )

map_oecd
ggsave("oecd_map_600dpi.tiff",
       map_oecd,
       width = 10,
       height = 6,
       dpi = 600,
       compression = "lzw")
