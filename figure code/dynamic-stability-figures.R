library(tidyverse)
library(lubridate)
library(rEDM)
library(parallel)

# devtools::install_github("weecology/portalr")
# devtools::install_github("weecology/LDATS")

source("~/projects/portal-DS/R/dynamic_stability_functions.R")
source("~/projects/portal-DS/R/plotting_functions.R")

results <- readRDS("~/projects/portal-DS/output/portal_ds_results_50.RDS")

p <- results$eigenvectors %>%
    plot_eigenvectors() %>% 
    add_regime_shift_highlight() + 
    labs(x = "", y = "eigenvector composition\n(normalized magnitude)", color = "Species") + 
    theme(panel.background = element_rect(fill = "#BBBBCC", color = NA), 
          legend.key = element_rect(fill = "#BBBBCC")) + 
    scale_x_date(limits = as.Date(c("1997-01-01", "2015-05-01")), 
                 expand = c(0.01, 0))
ggsave(here::here("static/img/dynamic-stability.png"), p, 
       width = 12.8, height = 4, dpi = 100)

library(gganimate)

lambda <- na.omit(map_dbl(results$eigenvalues, function(v) {max(abs(v))}))
a <- log(lambda)[52:148]
b <- spline(a)$y

x <- seq(from = -1, to = 1, length.out = 400)
df <- expand.grid(x = x, t = seq(b)) %>%
    mutate(y = x^2 * b[t])

p <- ggplot(df, aes(x = x, y = y)) + 
    geom_line(size = 2) + 
    geom_point(data = data.frame(x = 0, y = 0.003), color = "red", size = 15) +
    scale_y_continuous(limits = c(-0.05, 0.02)) + 
    labs(x = "", y = "") + 
    theme_nothing() + 
    theme(panel.grid.major = element_line(color = "#AAAAAA", size = 1))
animate(p + transition_time(t), nframes = length(b), fps = 4, 
        renderer = gifski_renderer(width = 400, height = 400))
anim_save(here::here("static/img/dynamic-stability-preview.gif"))
