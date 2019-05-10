+++
# Date this page was created.
date = 2018-09-02T00:00:00

# Project title.
title = "Dynamic stability"

# Project summary to display on homepage.
summary = "Dynamic quantification of stability in ecosystems."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "dynamic-stability-preview.gif"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["Dynamic Stability", "Time Series", "Complexity", "Stability"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Optional featured image (relative to `static/img/` folder).
[header]
image = "dynamic-stability.png"
caption = "Changes in composition of the dominant eigenvalue in Portal control plots (colored lines) and known timespans of community shift (gray highlights)"

+++

One classical approach for stability involves studying the species interaction matrix, and determining whether the matrix produces asympotitic stability near an equilibrium. In [Ushio et al. 2018](/publication/2018_maizuru-dynamic-stability/), we extended this framework by using [empirical dynamic modeling](/project/empirical-dynamic-modeling/) to quantify how the species interaction matrix changes over time. This then allows for estimation of stability as a changing quantity, or "dynamic stability".

[Ushio et al. 2018](/publication/2018_maizuru-dynamic-stability/) describes and demonstrates the approach for a fish community in Maizuru Bay. Currently, I am investigating whether dynamic stability can be a useful guide for identifying abrupt shifts in ecological communities. Specifically, whether the approach can give insight into change in the rodent community at the Portal experimental site, and validating the method against the known shifts identified in [Christensen et al. 2018](https://esajournals.onlinelibrary.wiley.com/doi/abs/10.1002/ecy.2373).

Code and data for this project are available on [GitHub](https://ha0ye.github.io/portalDS/) and initial results were presented at the 2018 ESA meeting in New Orleans.