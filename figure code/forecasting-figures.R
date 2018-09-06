library(tidyverse)
library(rEDM)
library(png)
library(gganimate) # devtools::install_github("thomasp85/gganimate")

# some packages that are installed, but which we'll reference directly
# library(portalr) # devtools::install_github("weecology/portalr")
# library(forecast)
# library(here)

raw_dat <- portalr::abundance(shape = "flat", # return data in long-form
                              time = "all",   # return time in all formats
                              clean = FALSE)  # include data that hasn't been QC'd

dat <- raw_dat %>%
    filter(species == "DM") %>%
    select(-species, -period) %>%
    complete(newmoonnumber = full_seq(newmoonnumber, 1), fill = list(NA)) %>%
    mutate_at(vars(-newmoonnumber), forecast::na.interp) %>%
    mutate(censusdate = as.Date(as.numeric(censusdate), origin = "1970-01-01"), 
           abundance = as.numeric(abundance))

dm_count <- data.frame(time = dat$newmoonnumber, 
                       abundance = dat$abundance)
simplex_out <- simplex(dm_count, E = 1:24, silent = TRUE)
best_E <- simplex_out$E[which.min(simplex_out$rmse)]

smap_out <- s_map(dm_count, E = best_E, silent = TRUE)
best_theta <- smap_out$theta[which.min(smap_out$rmse)]

pred_idx <- seq(floor(NROW(dm_count) / 2) + 1, NROW(dm_count))
forecasts <- map_dfr(pred_idx, function(n) {
    simplex_out <- simplex(dm_count, lib = c(1, n-1), 
                           E = 1:12, silent = TRUE)
    best_E <- simplex_out$E[which.min(simplex_out$rmse)]
    
    smap_out <- s_map(dm_count, lib = c(1, n-1), 
                      E = best_E, silent = TRUE)
    best_theta <- smap_out$theta[which.min(smap_out$rmse)]
    
    out <- s_map(dm_count, lib = c(1, n-1), pred = c(n-best_E, n), 
                 E = best_E, theta = best_theta, silent = TRUE, stats_only = FALSE)
    return(tail(out$model_output[[1]], 2)[1, ])
}) %>%
    rename(newmoonnumber = time) %>% 
    mutate(sd = sqrt(pred_var), 
           type = "prediction") %>%
    rename(abundance = pred)

# create df for timing
timing_df <- select(dat, newmoonnumber, censusdate)
timing_df$frame <- seq(to = floor(NROW(timing_df) / 2) + 1, length.out = NROW(timing_df))
timing_df$frame <- ifelse(timing_df$frame < 1, 1, timing_df$frame)

# combine observations and predictions
to_plot <- bind_rows(dat %>%
                         select(newmoonnumber, abundance) %>%
                         mutate(type = "observation", 
                                sd = 0), 
                     forecasts) %>%
    mutate(type = as.factor(type)) %>% 
    left_join(timing_df, by = "newmoonnumber")

p <- ggplot(to_plot, 
            aes(x = censusdate, y = abundance, 
                group = type, color = type, linetype = type)) + 
    scale_x_date(limits = range(to_plot$censusdate), expand = c(0.01, 0)) + 
    geom_line(size = 1) + 
    geom_point(data = filter(to_plot, type == "observation"), size = 3) + 
    geom_ribbon(aes(ymin = abundance - 2*sd, ymax = abundance + 2*sd), 
                data = filter(to_plot, type == "prediction"), 
                fill = "#BBBBFF", alpha = 0.5, color = NA) + 
    scale_color_manual(values = c("black", "blue")) + 
    theme_bw(base_size = 20, base_line_size = 1) + 
    labs(x = "", y = "DM Abundance") + 
    guides(color = guide_legend(override.aes = list(fill = c(NA, "#BBBBFF"))))

animate(p + transition_reveal(type, frame), 
        nframes = max(to_plot$frame), width = 1280, height = 400)

anim_save(here::here("static/img/forecasting.gif"))
