+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "portalR"

# Project summary to display on homepage.
summary = "R package for downloading and summarizing the Portal data"

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "portalr-preview.jpg"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["software", "data", "R"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false

# Optional featured image (relative to `static/img/` folder).
[header]
image = "portalr.jpg"
caption = ""

+++

The [Portal Project](https://portalproject.wordpress.com/) is a long-running experimental site in the Chihuahua desert that monitors rodent abundances, plant cover, and (sometimes) ants. Although the data is available on [GitHub](https://github.com/weecology/portalData) and there is a [simplified form](https://github.com/weecology/portal-teachingdb) of the data for teaching, compiling the raw data for analyses is non-trivial: there are multiple plots with different treatments; sampling usually occurs on the new moon, but can change due to weather or other circumstances; some rodent species show up infrequently, and sometimes non-rodents are caught in traps. These all conspire to make producing a simple plot of rodent abundances complicated.

[portalR](https://github.com/weecology/portalr) is an R package that seeks to address these issues. It is built in-house in the [Weecology lab](https://www.weecology.org/) and simplifies the process of downloading, updating, and summarizing the data for usage. In addition, it includes several vignettes that illustrate how to use the package to perform common tasks.