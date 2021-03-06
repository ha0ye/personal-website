+++
# Date this page was created.
date = 2018-09-06T00:00:00

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
image = "edm.gif"
caption = "Projection of the Lorenz Attractor to form a time series"

+++

Empirical dynamic modeling (EDM) is an approach for understanding the inherent dynamics (i.e. rules, processes, mechanisms) that underlie time series observations.

For example, in the graphic above, the time series is formed from the observation of variable $z$ of the Lorenz Attractor. More generally, time series can be more complex projections from the underlying dynamic system. EDM describes a way to recover information about the system from the time series.

The approach relies on the theory of attractor reconstruction (also referred to as "state-space reconstruction" or "time-delay embedding") to transform time series into approximations of the original dynamic system that the time series are observations of. This has applications for [forecasting](/project/forecasting/), [causal inference](/project/causality/), and more.

For the R package for empirical dynamic modeling, check out [rEDM](https://github.com/ha0ye/rEDM).

For a short video introduction, check out the following youtube playlist (~6 minutes total):
<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="//www.youtube.com/embed/videoseries\?list=PL-SSmlAMhY3bnogGTe2tf7hpWpl508pZZ" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border:0;" allowfullscreen title="YouTube Video"></iframe>
</div>