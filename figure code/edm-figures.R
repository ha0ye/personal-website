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

## preview animation ----

num_frames <- 100
t_vec <- seq(from = 550, to = 1100, length.out = num_frames)
theta_vec <- seq(from = 0, to = 4 * pi, length.out = num_frames)

to_plot <- map_dfr(seq(num_frames), function(i) {
    t <- seq(from = 1, to = t_vec[i])
    theta <- theta_vec[i]
    data.frame(x = x[t] * cos(theta) + y[t] * sin(theta), 
               y = z[t], 
               frame = i)
})
points <- to_plot %>% group_by(frame) %>% filter(row_number() == n()) %>% ungroup()

xlims <- range(to_plot$x) * 1.25
ylims <- range(to_plot$y)

p <- ggplot(to_plot, 
       aes(x = x, y = y, group = frame)) + 
    geom_point(data = points, size = 3) + 
    scale_y_continuous(limits = ylims, expand = c(0.01, 0)) + 
    scale_x_continuous(limits = xlims, expand = c(0.01, 0)) +
    geom_path() + 
    theme_void()

animate(p + transition_time(frame), 
        nframes = num_frames, 
        width = 400, height = 400)

anim_save(here::here("static/img/edm-preview.gif"))

## wide animation ----

# rescale data to [0, 1]
x <- (x - min(x)) / (max(x) - min(x)) * 0.8 + 0.1
y <- (y - min(y)) / (max(y) - min(y)) * 0.8 + 0.1
z <- (z - min(z)) / (max(z) - min(z)) * 0.8 + 0.1

num_frames <- 100
t_vec <- seq(from = 550, to = 1100, length.out = num_frames)
max_t <- max(t_vec)

att_plot <- data.frame(x = x[1:1100], 
                       y = z[1:1100], 
                       frame = 1)
row_idx <- seq(from = floor(NROW(att_plot) / 2) + 1, to = NROW(att_plot))
frame_idx <- att_plot$frame
frame_idx[row_idx] <- round(0.000001 + seq(from = 1, to = num_frames, 
                                           length.out = length(row_idx)))
att_plot$frame <- frame_idx

margin <- 4/15
width <- 3

ts_plot <- data.frame(x = 1 + margin + seq(from = 0.1, to = width - 0.1, length.out = max_t), 
                      y = z[1:1100], 
                      frame = 1)
ts_plot$frame <- frame_idx

xlims <- c(0, 1 + margin + width)
ylims <- c(-1/6, 1 + 1/6)
grid_pos <- c(0.2, 0.4, 0.6, 0.8)

p <- ggplot(att_plot, 
            aes(x = x, y = y)) + 
    scale_y_continuous(limits = ylims, expand = c(0.01, 0)) + 
    scale_x_continuous(limits = xlims, expand = c(0.01, 0)) +
    
    # axes for attractor
    geom_segment(aes(x = 0, xend = 1, yend = y), data = data.frame(y = grid_pos), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(y = 0, yend = 1, xend = x), data = data.frame(x = grid_pos), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(x = 1, xend = 1, y = 0, yend = 1), 
                 color = "blue", size = 1.5) + 
    geom_segment(aes(x = 0, xend = 1, y = 0, yend = 0), 
                 color = "blue", size = 1.5) + 
    annotate("text", x = 0.5, y = -0.05, label = "X", 
             color = "blue", vjust = 1, size = 8) + 
    annotate("text", x = 1, y = 1.05, label = "Z", 
             color = "blue", vjust = 0, size = 8) + 
    
    # time series axes
    geom_segment(aes(x = 1 + margin, xend = 1 + margin + 3, yend = y), 
                 data = data.frame(y = grid_pos), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(y = 0, yend = 1, xend = x), 
                 data = data.frame(x = 1 + margin + seq(from = 0, to = 3, by = 0.2)), 
                 color = "grey70", size = 0.5) + 
    geom_segment(aes(x = 1 + margin, xend = 1 + margin, y = 0, yend = 1), 
                 color = "red", size = 1.5) + 
    geom_segment(aes(x = 1 + margin, xend = 1 + margin + width, y = 0, yend = 0), 
                 color = "red", size = 1.5) + 
    annotate("text", x = width/2 + 1 + margin, y = -0.05, label = "Time", 
             color = "red", vjust = 1, size = 8) + 
    annotate("text", x = 1 + margin, y = 1.05, label = "Z", 
             color = "red", vjust = 0, size = 8) +
    
    # attractor plot
    geom_path(size = 1) + 
    geom_point(size = 4, color = "blue") + 
    
    # projection to attractor axis
    geom_segment(aes(xend = 1, yend = y), 
                 color = "blue", linetype = 2, size = 0.5) + 
    
    # connection between plots
    geom_segment(aes(x = 1, xend = 1 + margin, yend = y), 
                 color = "black", linetype = 2, size = 0.5) + 
    
    # time series plot
    geom_line(data = ts_plot, size = 1) + 
    geom_point(data = ts_plot, size = 4, color = "red") + 
    
    # projection to time series axis
    geom_segment(aes(x = 1 + margin, xend = x, yend = y), data = ts_plot, 
                 linetype = 2, color = "red", size = 0.5) + 
    
    theme_void()

animate(p + transition_reveal(1, frame), 
        nframes = num_frames, width = 1280, height = 400)

anim_save(here::here("static/img/edm.gif"))
