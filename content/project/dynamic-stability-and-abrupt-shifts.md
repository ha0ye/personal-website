+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "Dynamic Stability and Abrupt Shifts"

# Project summary to display on homepage.
summary = "Testing dynamic stability as an indicator for abrupt community shifts."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "abrupt-shift-preview.jpg"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["dynamics", "time series", "complexity", "stability"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Optional featured image (relative to `static/img/` folder).
[header]
image = "abrupt-shift.jpg"
caption = "Changes in composition of the dominant eigenvalue in Portal control plots (colored lines) and known timespans of community shift (gray highlights)"

+++

Describing change in complex systems is difficult: because there are many components that can interact and affect each other, there is often not a clear definition for when abrupt shifts have occurred. In some systems, there are instances where there is a clear shift where groups of variables change from being low in value to high or vice-versa, but other shifts can occur in terms of composition or dynamical behaviors. Moreover, thresholds that work for a single variable (e.g. more than 2 SD of change) may be different in a multivariate context.

This project tests whether a measure, *dynamic stability*, (see [Ushio et al. 2018](https://haoye.us/publication/2018_maizuru-dynamic-stability/)) can be a useful guide for document abrupt shifts in ecological communities.

As a first test case, we are testing whether the primary measure for *dynamic stability*, the magnitude of the dominant eigenvalue, and related measures can describe community change in the Portal experimental system. Here, validation will be against the shifts identified in [Christensen et al. 2018](https://esajournals.onlinelibrary.wiley.com/doi/abs/10.1002/ecy.2373).

Code and data for this project are available in the [GitHub repo](https://github.com/ha0ye/portal-DS) and initial results were presented at the 2018 ESA meeting in New Orleans.
