setwd("~/projects/personal-website/figure code/")

p <- two_ev_plot %>% add_regime_shift_highlight() + 
    guides(color = guide_legend("eigenvalue rank"))
ggsave(here::here("static/img/dynamic-stability.png"), p, 
       width = 12.8, height = 4, dpi = 100)

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
b <- spline(a)$y[1:10]

x <- seq(from = -1, to = 1, length.out = 400)
df <- expand.grid(x = x, t = seq(b)) %>%
    mutate(y = x^2 * b[t])

p <- ggplot(df, aes(x = x, y = y)) + 
    geom_line(size = 1) + 
    geom_point(data = data.frame(x = 0, y = 0.003), color = "red", size = 5) +
    scale_y_continuous(limits = c(-0.05, 0.02)) + 
    labs(x = "", y = "") + 
    theme_nothing() + 
    transition_time(t) + 
    ease_aes("sine-in-out")
animate(p, nframes = length(b), fps = 2)
anim_save(here::here("static/img/dynamic-stability-preview.gif"))
