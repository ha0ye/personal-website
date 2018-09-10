library(tidyverse)
library(gganimate) # devtools::install_github("thomasp85/gganimate")

## generate model data ----

# params
t_max <- 200
h <- 0.01
num_points <- t_max / h
sigma = 10
beta = 8/3
rho = 28

# motion equations
dx <- function(x1, x2, x3)
{
    sigma*(x2 - x1)
}
dy <- function(x1, x2, x3)
{
    x1*(rho - x3) - x2
}
dz <- function(x1, x2, x3)
{
    x1*x2 - beta*x3
}	

# initialize data 
x <- vector("numeric", length = num_points)
y <- vector("numeric", length = num_points)
z <- vector("numeric", length = num_points)
x[1] = 20
y[1] = 20
z[1] = 20

# generate data using Runge-Kutta
for (i in 1:(num_points - 1))
{
    xx = x[i];
    yy = y[i];
    zz = z[i];
    kx1 = dx(xx, yy, zz);
    ky1 = dy(xx, yy, zz);
    kz1 = dz(xx, yy, zz);
    kx2 = dx(xx + h/2*kx1, yy + h/2*ky1, zz + h/2*kz1);
    ky2 = dy(xx + h/2*kx1, yy + h/2*ky1, zz + h/2*kz1);
    kz2 = dz(xx + h/2*kx1, yy + h/2*ky1, zz + h/2*kz1);
    kx3 = dx(xx + h/2*kx2, yy + h/2*ky2, zz + h/2*kz2);
    ky3 = dy(xx + h/2*kx2, yy + h/2*ky2, zz + h/2*kz2);
    kz3 = dz(xx + h/2*kx2, yy + h/2*ky2, zz + h/2*kz2);
    kx4 = dx(xx + h*kx3, yy + h*ky3, zz + h*kz3);
    ky4 = dy(xx + h*kx3, yy + h*ky3, zz + h*kz3);
    kz4 = dz(xx + h*kx3, yy + h*ky3, zz + h*kz3);
    
    x[i + 1] = xx + h / 6.0 * (kx1 + 2*kx2 + 2*kx3 + kx4);
    y[i + 1] = yy + h / 6.0 * (ky1 + 2*ky2 + 2*ky3 + ky4);
    z[i + 1] = zz + h / 6.0 * (kz1 + 2*kz2 + 2*kz3 + kz4);
}

# rescale data to [0, 1]
x <- (x - min(x)) / (max(x) - min(x))
y <- (y - min(y)) / (max(y) - min(y))
z <- (z - min(z)) / (max(z) - min(z))

## preview animation ----
if (FALSE) 
{
    num_frames <- 100
    t_vec <- 400:1600
    frame_idx <- round(0.00001 + seq(from = 0, to = num_frames, length.out = length(t_vec)))
    
    # time series
    to_plot <- data.frame(x = x[t_vec] * 0.3 + 0.65, 
                          y = y[t_vec], 
                          z = z[t_vec] * 0.3 + 0.05,
                          t = t_vec, 
                          frame = frame_idx)
    
    # question mark
    text_idx <- (frame_idx %% 16) < 8
    text_data <- data.frame(x = ifelse(text_idx, median(t_vec), NA), 
                            y = 0.5, 
                            t = t_vec, 
                            frame = frame_idx)
    
    # arrows
    arrows <- data.frame(x = median(t_vec) + c(0, 0, 0, 0, 0, 0), 
                         xend = median(t_vec) + c(0, -20, 20, 0, -20, 20), 
                         y = c(0.55, 0.67, 0.67, 0.45, 0.33, 0.33),
                         yend = c(0.67, 0.62, 0.62, 0.33, 0.38, 0.38), 
                         seg_idx = 1:6)
    segment_data <- map_dfr(seq(t_vec), function(idx) {
        frame <- frame_idx[idx]
        temp <- data.frame(arrows, frame = frame, t = t_vec[idx])
        if ((frame %% 16) >= 8)
        {
            temp$x <- NA
        }
        return(temp)
    })
    
    xlims <- range(to_plot$t)
    ylims <- c(0, 1)
    
    p <- ggplot(to_plot, 
                aes(x = t, y = x)) + 
        scale_y_continuous(limits = ylims, expand = c(0.01, 0)) + 
        scale_x_continuous(limits = xlims, expand = c(0.01, 0)) +
        
        # arrow and question mark
        geom_text(aes(x = x, y = y), data = text_data, label = "?", 
                  size = 10, hjust = 0.5, vjust = 0.5) +
        geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                     data = filter(segment_data, seg_idx == 1), size = 2) + 
        geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                     data = filter(segment_data, seg_idx == 2), size = 2) + 
        geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                     data = filter(segment_data, seg_idx == 3), size = 2) + 
        geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                     data = filter(segment_data, seg_idx == 4), size = 2) + 
        geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                     data = filter(segment_data, seg_idx == 5), size = 2) + 
        geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                     data = filter(segment_data, seg_idx == 6), size = 2) + 
        
        # time series for x and z
        geom_line(size = 1, color = "red") + 
        geom_line(aes(x = t, y = z), size = 1, color = "blue") + 
        theme_void()
    
    animate(p + transition_reveal(1, t), 
            nframes = num_frames, 
            width = 400, height = 400)
    
    anim_save(here::here("static/img/causality-preview.gif"))
}


## wide animation ----

x <- (x - min(x)) / (max(x) - min(x)) * 0.8 + 0.1
y <- (y - min(y)) / (max(y) - min(y)) * 0.8 + 0.1
z <- (z - min(z)) / (max(z) - min(z)) * 0.8 + 0.1

num_frames <- 100
t_vec <- 400:1600
frame_idx <- round(0.00001 + seq(from = 0, to = num_frames, length.out = length(t_vec)))
t_vec <- 50:1600
frame_idx <- c(rep(1, length(t_vec) - length(frame_idx)), 
               frame_idx)

xlims <- c(0, 3.2)
ylims <- c(0, 1)

# time series
x_ts_plot <- data.frame(x = seq(0, 1, length.out = length(t_vec)), 
                        y = x[t_vec], 
                        t = t_vec, 
                        frame = frame_idx)

z_ts_plot <- data.frame(x = seq(0, 1, length.out = length(t_vec)), 
                        y = z[t_vec], 
                        t = t_vec, 
                        frame = frame_idx)

# scale x time series plot
x_ts_box <- c(0.05, 1.3, 0.55, 0.95)
x_ts_plot$x <- x_ts_plot$x * (x_ts_box[2] - x_ts_box[1]) + x_ts_box[1]
x_ts_plot$y <- x_ts_plot$y * (x_ts_box[4] - x_ts_box[3]) + x_ts_box[3]

# scale z time series plot
z_ts_box <- c(1.9, 3.15, 0.55, 0.95)
z_ts_plot$x <- z_ts_plot$x * (z_ts_box[2] - z_ts_box[1]) + z_ts_box[1]
z_ts_plot$y <- z_ts_plot$y * (z_ts_box[4] - z_ts_box[3]) + z_ts_box[3]

# arrows
horiz_arrows <- data.frame(x = c(1.4, 1.4, 1.4, 1.8, 1.8, 1.8), 
                     xend = c(1.55, 1.45, 1.45, 1.65, 1.75, 1.75), 
                     y = c(0.75, 0.75, 0.75, 0.75, 0.75, 0.75),
                     yend = c(0.75, 0.725, 0.775, 0.75, 0.725, 0.775))
diagonal_arrows <- data.frame(x = c(0.7, 0.7, 0.7, 0.8, 0.8), 
                              xend = c(0.8, 0.7, 0.7 + 0.6 / 13, 0.8, 0.8 - 0.6 / 13), 
                              y = c(0.52, 0.52, 0.52, 0.37, 0.37), 
                              yend = c(0.37, 0.47, 0.52 - 0.25 / 13, 0.42, 0.37 + 0.25 / 13))
arrows <- bind_rows(horiz_arrows, 
                    horiz_arrows %>% mutate(y = y - 0.5, yend = yend - 0.5), 
                    diagonal_arrows, 
                    diagonal_arrows %>% mutate(x = 3.2 - x, xend = 3.2 - xend))
                    

# attractors
tau <- 8
project_2d <- function(dat, theta_x = 0, theta_y = 0, theta_z = 0, 
                       z_pos = 2, z_camera = 5)
{
    cx <- cos(theta_x)
    sx <- sin(theta_x)
    cy <- cos(theta_y)
    sy <- sin(theta_y)
    cz <- cos(theta_z)
    sz <- sin(theta_z)
    dat <- data.frame(x = cy * (sz * dat$y + cz * dat$x) - sy * dat$z, 
                      y = sx * (cy * dat$z + sy * (sz * dat$y + cz * dat$x)) + cx * (cz * dat$y - sz * dat$x), 
                      z = cx * (cy * dat$z + sy * (sz * dat$y + cz * dat$x)) - sx * (cz * dat$y - sz * dat$x))
    dat$z <- dat$z + z_pos
    return(data.frame(x = z_camera / dat$z * dat$x, 
                      y = z_camera / dat$z * dat$y, 
                      t = t_vec, 
                      frame = frame_idx))
}

scale_attractor <- function(att)
{
    max_scale <- max(max(att$x) - min(att$x), 
                     max(att$y) - min(att$y))
    att$x <- (att$x - min(att$x)) / max_scale
    att$y <- (att$y - min(att$y)) / max_scale
    att$x <- att$x + 0.5 - (max(att$x) - min(att$x))/2
    att$y <- att$y + 0.5 - (max(att$y) - min(att$y))/2
    return(att)
}

# make x attractor
x_att_data <- data.frame(x = x[t_vec] * 2 - 1, 
                         y = x[t_vec - tau] * 2 - 1, 
                         z = x[t_vec - 2*tau] * 2 - 1)
x_att_plot <- project_2d(x_att_data, 0.6, -0.7, 0.25) %>%
    scale_attractor()

# position x attractor
x_att_box <- c(0.4, 1.3, 0, 0.5)
x_att_plot$x <- x_att_plot$x * (x_att_box[2] - x_att_box[1]) + x_att_box[1]
x_att_plot$y <- x_att_plot$y * (x_att_box[4] - x_att_box[3]) + x_att_box[3]

# make z attractor
z_att_data <- data.frame(x = z[t_vec] * 2 - 1, 
                         y = z[t_vec - tau] * 2 - 1, 
                         z = z[t_vec - 2*tau] * 2 - 1)
z_att_plot <- project_2d(z_att_data, 0.4, -0.8, 0.3, 
                         z_pos = 1.5, z_camera = 4) %>%
    scale_attractor()

# position z attractor
z_att_box <- c(1.9, 2.8, 0.1, 0.45)
z_att_plot$x <- z_att_plot$x * (z_att_box[2] - z_att_box[1]) + z_att_box[1]
z_att_plot$y <- z_att_plot$y * (z_att_box[4] - z_att_box[3]) + z_att_box[3]

p <- ggplot(x_ts_plot, 
            aes(x = x, y = y)) + 
    scale_y_continuous(limits = ylims, expand = c(0.01, 0)) + 
    scale_x_continuous(limits = xlims, expand = c(0.01, 0)) +
    
    # x time series axes
    geom_segment(aes(x = x_ts_box[1], xend = x_ts_box[2], yend = y), 
                 data = data.frame(y = seq(0, 1, 0.2) * (x_ts_box[4] - x_ts_box[3]) + x_ts_box[3]), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(y = x_ts_box[3], yend = x_ts_box[4], xend = x), 
                 data = data.frame(x = seq(0, 1.8, 0.2) / 1.8 * (x_ts_box[2] - x_ts_box[1]) + x_ts_box[1]), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(x = x_ts_box[1], xend = x_ts_box[2], 
                     y = x_ts_box[3], yend = x_ts_box[3]), size = 1) + 
    geom_segment(aes(x = x_ts_box[1], xend = x_ts_box[1], 
                     y = x_ts_box[3], yend = x_ts_box[4]), size = 1) + 
    annotate("text", x = 0.675, y = 0.975, label = "Time Series of X", 
             hjust = 0.5, vjust = 0.5, size = 7) + 
    
    # z time series axes
    geom_segment(aes(x = z_ts_box[1], xend = z_ts_box[2], yend = y), 
                 data = data.frame(y = grid_pos * (z_ts_box[4] - z_ts_box[3]) + z_ts_box[3]), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(y = z_ts_box[3], yend = z_ts_box[4], xend = x), 
                 data = data.frame(x = seq(0, 1.8, 0.2) / 1.8 * (z_ts_box[2] - z_ts_box[1]) + z_ts_box[1]), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(x = z_ts_box[1], xend = z_ts_box[2], 
                     y = z_ts_box[3], yend = z_ts_box[3]), size = 1) + 
    geom_segment(aes(x = z_ts_box[1], xend = z_ts_box[1], 
                     y = z_ts_box[3], yend = z_ts_box[4]), size = 1) + 
    annotate("text", x = 3.2 - 0.675, y = 0.975, label = "Time Series of Z", 
             hjust = 0.5, vjust = 0.5, size = 7) + 
    
    # time series for x and z
    geom_path(size = 1, color = "red") + 
    geom_path(size = 1, color = "blue", data = z_ts_plot) + 
    
    # arrow between time series
    annotate("text", x = 1.6, y = c(0.25, 0.75), 
             label = "?", size = 10, hjust = 0.5, vjust = 0.5) + 
    geom_segment(aes(x = x, xend = xend, y = y, yend = yend), 
                data = arrows, size = 2) + 
    
    # attractors for x and z
    geom_path(size = 1, color = "#CC0000", data = x_att_plot) + 
    annotate("text", x = 0.9, y = 0.05, label = "Attractor Reconstruction of X", 
             hjust = 0.5, vjust = 0.5, size = 7) + 
    
    geom_path(size = 1, color = "#0000CC", data = z_att_plot) + 
    annotate("text", x = 3.2 - 0.8, y = 0.05, label = "Attractor Reconstruction of Z", 
             hjust = 0.5, vjust = 0.5, size = 7) + 
    
    
    coord_fixed() + 
    theme_void()

animate(p + transition_reveal(1, frame),
        nframes = num_frames,
        width = 1280, height = 400)

anim_save(here::here("static/img/causality.gif"))

