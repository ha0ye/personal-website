library(tidyverse)
library(hexSticker)
sysfonts::font_add("montserrat", 
                   regular = "Montserrat 500italic.ttf")

## generate model data ----

# params
t_max <- 100
h <- 0.002
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

t <- seq(from = 2000, to = 4500)
to_plot <- data.frame(x = x[t], 
                      y = z[t])

p <- ggplot(to_plot, 
       aes(x = x, y = y)) + 
    geom_path(color = "#0880FF", size = 0.25, alpha = 0.9) + 
    theme_void()

sticker(p, s_x = 1, s_y = 0.72, s_width = 1.1, s_height = 0.9, 
        package = "rEDM", p_family = "montserrat", p_color = "#FFEE44",
        spotlight = TRUE, l_x = 1, l_y = 1, l_alpha = 0.2, 
        l_width = 4, l_height = 4, 
        h_fill = "#222222", h_color = "#AA3322", h_size = 3, 
        filename = "static/img/redm-preview.png")
