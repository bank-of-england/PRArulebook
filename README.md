
# PRArulebook

<!-- badges: start -->

[![Project Status: Active Ã¢â‚¬â€œ The project has reached a stable,
usable state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/PRArulebook)](https://cran.r-project.org/package=PRArulebook)
[![Codecov test
coverage](https://codecov.io/gh/erzk/PRArulebook/branch/master/graph/badge.svg)](https://codecov.io/gh/erzk/PRArulebook?branch=master)
<!-- badges: end -->

`PRArulebook` is a package to scrape the PRA (Prudential Regulation
Authority) [Rulebook](http://www.prarulebook.co.uk/) (the website
containing the rules made and enforced by the PRA under powers conferred
by the Financial Services and Markets Act 2000 (FSMA)).

The input to this package is the PRA Rulebook website. Outputs from this
package are the rules published on the PRA Rulebook website in a format
more amenable to text and network analysis.

`PRArulebook` was developed while preparing:

**Amadxarif, Z., Brookes, J., Garbarino, N., Patel, R., Walczak, E.
(2019) *[The Language of Rules: Textual Complexity in Banking
Reforms.](https://www.bankofengland.co.uk/working-paper/2019/the-language-of-rules-textual-complexity-in-banking-reforms)*
Staff Working Paper No. 834. Bank of England.**

Any use of this package with the PRA Rulebook must comply with the PRA
Rulebook’s [Terms of Use](http://www.prarulebook.co.uk/terms-of-use).
These include, but are not limited to, restrictions on using content
from the PRA Rulebook for commercial purposes without obtaining a
licence from the PRA.

## Installation

You can install the development version of `PRArulebook` from GitHub
with:

``` r
install.packages("devtools")
devtools::install_github("erzk/PRArulebook")
```

## Data

`PRArulebook` scrapes two types of data: **structure** and **content**.

  - **Structure** - hierarchy of the PRA Rulebook. Includes URLs and
    names.

  - **Content**
    
      - Text - can be used for text analysis
      - Network - can be used for network analysis.

The next section shows how to extract these types of data.

## Examples

Load the package

``` r
library(PRArulebook)
```

### Structure

The simplest way to extract a rulebook structure is to use
`get_structure` function

``` r
# get the structure of the rulebook down to the part-level
parts <-
  get_structure("16-11-2007",
                layer = "part")
# or chapter-level
# warnings (410) are displayed for inactive sites
chapters <-
  get_structure("18-06-2019",
                layer = "chapter")
```

This will start scraping the PRA rulebook. Warnings
([410](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) code)
will be displayed when a page is no longer active. Pulling data will
take longer if you decide to pull more granular data. The rulebook has
several layers and each of them can be passed to the `layer` argument of
`get_structure` (in descending order):

  - `sector`
  - `part`
  - `chapter`

The output will be a data frame with information about the structure
(i.e. URLs and names).

Scraping individual rules is much slower so another function should be
used

``` r
# extract all rules from the first three chapters
rules <- scrape_rule_structure(chapters[1:3,], "18-06-2019")
```

### Content

Once the structure URLs are scraped, they can be used to extract
content.

#### Text

To get content of the rulebook (text or links) use `get_content`
function with a URL of a given chapter.

``` r
# scrape text from a single chapter
chapter_text <- get_content(chapters$chapter_url[1])
# or single rule
rule_text <- get_content(rules$rule_url[2], "text", "yes")
```

This function can be applied on the entire rulebook in the following
way:

``` r
library(purrr)

chapters_text <-
  map_df(chapters$chapter_url[1:5],
                get_content)
# exception handling might be needed
```

The output can be then joined to the information about the rulebook
structure and aggregated at a higher level.

#### Network

To scrape the links and create data set for network analysis
`get_content` function can be used but with a `type` argument set to
`"links"`. Like in the previous example, this call can also be
parallelised.

``` r
chapter_link <- get_content(chapters$chapter_url[1], "links")

# sequential
parts_links <-
  purrr::map_df(parts$part_url[1:5],
                get_content,
                "links")
```

The code above will return a data frame with *from/to url*, *text* used
in a link, and a *type* of a link.

Scraped data containing information about the links can be used for
network analysis (warning: further cleaning might be required).

### Disclaimer

This package is an outcome of a research project. All errors are mine.
All views expressed are personal views, not those of any employer.
