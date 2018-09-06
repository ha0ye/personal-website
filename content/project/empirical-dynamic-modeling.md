+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "Empirical Dynamic Modeling"

# Project summary to display on homepage.
summary = "Inferring system dynamics from time series"

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "edm-preview.gif"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["Time Series", "Complexity", "Stability", "Nonlinear Dynamics", "Forecasting", "Causality"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Optional featured image (relative to `static/img/` folder).
[header]
image = "empirical-dynamic-modeling.jpg"
caption = ""

+++

Empirical dynamic modeling (EDM) is an approach for understanding the inherent dynamics (i.e. rules, processes, mechanisms) that underlie time series observations.

The approach relies on the theory of attractor reconstruction (also referred to as "state-space reconstruction" or "time-delay embedding") to transform time series into approximations of the original dynamic system that the time series are observations of. This has applications for [forecasting](/project/forecasting/), [causal inference](/project/causality/), and more.

You can check out our R package for empirical dynamic modeling, [rEDM](https://github.com/ha0ye/rEDM), as well any number of papers describing different uses for EDM or applications for specific case studies.