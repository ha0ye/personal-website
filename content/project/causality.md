+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "Causal inference"

# Project summary to display on homepage.
summary = "Identifying causal interactions among time series."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "causality-preview.gif"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["Dynamics", "Time Series", "Causality"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Optional featured image (relative to `static/img/` folder).
[header]
image = "causality.gif"
caption = ""

+++

Under most definitions of "causality", strict identification of causal interactions from observational data alone is impossible. However, it is possible to infer potential interactions among time series. Specifically, in dynamical systems, where time series are observations of the higher-dimensional behavior, methods from [empirical Dynamic Modeling](/project/empirical-dynamic-modeling/) can be adapted to test whether two time series share information.

The essential idea is illustrated above. A causal interaction between $x$ and $z$ is inferred if there is shared dynamical information in the two time series. This is tested for by examining whether the attractor reconstructions of $x$ and $z$ are different representations of the same dynamics.

We described this idea initially in [Sugihara et al. 2012](/publication/2012_causality/). Later papers looked at the problem of combining data from replicate observations (see [Clark et al. 2015](/publication/2015_spatial-ccm/)) and expanding on the method to quantify time delays in causal effects (see [van Nes et al. 2015](/publication/2015_causality-climate-change/) and [Ye et al. 2015](/publication/2015_ccm-time-delays/)).

For a short video introduction, check out the following youtube video (part 3 of the longer playlist on EDM):
{{< youtube iSttQwb-_5Y >}}
