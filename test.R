library(ggplot2)
library(ggpol) # ggplot2 extension for drawing parliament charts

library(tidyverse)

custom = parliament %>% filter(Term == 3) %>% select(Party) %>% table() %>% t() %>% as.data.frame() %>%  `colnames<-`(c("","Party", "Seats"))
#FF0000
colors<-c("#FF0000","#55a8ce","#90EE90")

custom$legend <- paste0(custom$Party," (", custom$Seats,")")

#draw a parliament diagram 
p<-ggplot(custom) + 
  geom_parliament(aes(seats =Seats, fill =  Party), color = "white") + 
  scale_fill_manual(values = colors , labels = custom$legend) +
  coord_fixed() + 
  theme_void()+
  labs(title  = "Greek Parliament (1981-1985)",
       caption = "Source: stesiam | stesiam.github.io, 2022")+
  theme(title = element_text(size = 18),
        plot.title = element_text(hjust = 0.5,size = 14,face = 'bold'),
        plot.subtitle = element_text(hjust = 0.5),
        plot.caption = element_text(vjust = -3,hjust = 0.9, size = 8),    
        legend.position = 'bottom',
        legend.direction = "horizontal",
        legend.spacing.y = unit(0.1,"cm"),
        legend.spacing.x = unit(0.1,"cm"),
        legend.key.size = unit(0.8, 'lines'),
        legend.text = element_text(margin = margin(r = 1, unit = 'cm')),
        legend.text.align = 0)+
        guides(fill=guide_legend(nrow=3,byrow=TRUE,reverse = TRUE,title=NULL))

p

