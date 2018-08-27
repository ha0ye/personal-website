+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "Causal inference from time series"

# Project summary to display on homepage.
summary = "Identifying causal interactions among time series."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "causality-preview.jpg"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["dynamics", "time series", "causality"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Optional featured image (relative to `static/img/` folder).
[header]
image = "causality.jpg"
caption = ""

+++

Strict identification of causal interactions from observational data alone is impossible. However, it is possible to make inference on potential interactions among time series, using methods that go beyond mere correlation. [Empirical Dynamic Modeling]() uses the approach of attractor reconstruction to address this problem: time series are re-envisioned as projections of a dynamical system, and causality is inferred when there is evidence that two time series belong to the same dynamical system.

We presented this idea originally in [Sugihara et al. 2012](/publication/2012_causality/). Later papers looked at the problem of combining data from replicate observations (see [Clark et al. 2015](/publication/2015_spatial-ccm/)) and expanding on the method to quantify time delays in causal effects (see [van Nes et al. 2015](/publication/2015_causality-climate-change/) and [Ye et al. 2015](/publication/2015_ccm-time-delays/)).