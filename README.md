
<!-- README.md is generated from README.Rmd. Please edit that file -->
educationdata
=============

Retrieve data from the Urban Institute's [Education Data API](https://ed-data-portal.urban.org/) as a `data.frame` for easy analysis.

Installation
------------

To install the alpha version of the package:

-   Clone the repository from GitHub.

`git clone https://github.com/UI-Research/education-data-package-r.git`

-   If you have RStudio installed, open `educationdata.Rproj` and build from source in the console. If you are using the R GUI, set your working directory to the project folder.

-   If you have the `devtools` package installed, run:

``` r
# install.packages(devtools) # if necessary
devtools::install()
```

-   Or if you don't have/want the `devtools` package, run:

``` r
install.packages(".", repos = NULL, type="source")
```

Available Endpoints
-------------------

API endpoints follow a format of

-   `level/source/topic/{required}/{variables}/grouping/variables`

where:

-   `level` is the data level to query (i.e., schools, school-districts, college-university)
-   `source` is the data source for a specific level (i.e., ccd, ipeds, saipe)
-   `topic` is the data topic to query
-   `{required}/{variables}` are arguments that must be set for a specific topic
-   `grouping/variables` are arguments that will provide data 'by' certain categories

For example, the endpoint

-   `college-university/ipeds/fall-enrollment/{year}/{level_of_study}/`

will provide:

-   college-university level data
-   from IPEDS
-   on fall-enrollment numbers
-   for a specified year and level of study.

While the endpoint

-   `college-university/ipeds/fall-enrollment/{year}/{level_of_study}/race`

will provide the same data, grouped by race.

| Endpoint                                                                            | Years Available                       |
|:------------------------------------------------------------------------------------|:--------------------------------------|
| college-university/ipeds/admissions-enrollment/{year}/                              | 2001-2016                             |
| college-university/ipeds/admissions-requirements/{year}/                            | 1990-2016                             |
| college-university/ipeds/completers/{year}/                                         | 2011-2015                             |
| college-university/ipeds/completions-cip/{year}/                                    | 1991-2015                             |
| college-university/ipeds/directory/{year}/                                          | 1980, 1984-2016                       |
| college-university/ipeds/enrollment-full-time-equivalent/{year}/{level\_of\_study}/ | 2003-2015                             |
| college-university/ipeds/enrollment-headcount/{year}/{level\_of\_study}/            | 1996-2015                             |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/                 | 1986-2015                             |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/age/             | 1991, 1993, 1995, 1997, and 1999-2016 |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/age/sex/         | 1991, 1993, 1995, 1997, and 1999-2016 |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/race/            | 1986-2015                             |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/race/sex/        | 1986-2015                             |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/sex/             | 1986-2015                             |
| college-university/ipeds/fall-retention/{year}/                                     | 2003-2016                             |
| college-university/ipeds/grad-rates-200pct/{year}/                                  | 2007-2015                             |
| college-university/ipeds/grad-rates-pell/{year}/                                    | 2015                                  |
| college-university/ipeds/grad-rates/{year}/                                         | 1996-2015                             |
| college-university/ipeds/institutional-characteristics/{year}/                      | 1980, 1984-2016                       |
| college-university/ipeds/outcome-measures/{year}/                                   | 2015                                  |
| college-university/ipeds/student-faculty-ratio/{year}/                              | 2009-2016                             |
| school-districts/ccd/finance/{year}/                                                | 1991-2013                             |
| school-districts/saipe/{year}/                                                      | 1995-2016                             |
| schools/ccd/directory/{year}/                                                       | 1986-2014                             |
| schools/ccd/enrollment/{year}/{grade}/                                              | 1987-2014                             |
| schools/ccd/enrollment/{year}/{grade}/race/                                         | 1987-2014                             |
| schools/ccd/enrollment/{year}/{grade}/race/sex/                                     | 1987-2014                             |
| schools/ccd/enrollment/{year}/{grade}/sex/                                          | 1987-2014                             |

Usage
-----

Use the `get_education_data()` function to retrieve a `data.frame` from an API endpoint.

``` r
get_education_data(level, source, topic, ..., by, filters)
```

The `get_education_data()` function will parse and validate several arguments against the API.

-   level - API data level to query. Current levels are:
    -   college-university
    -   school-districts
    -   schools
-   source - API data source to query. Current sources are:
    -   ccd
    -   ipeds
    -   saipe
-   topic - API data topic to query
-   ... - Additional parameters required for a specific API call
-   by - Additional optional parameters for a specific API call
-   filters - Optional query to filter the results from an API call

Examples
--------

Let's build up some examples, starting with a simple API endpoint:

-   `schools/ccd/enrollment/{year}/{grade}/`

In this case, the `level` is `schools`, the `source` is `ccd`, and the `topic` is `enrollment`. Note that variables in curly brackets (i.e., `year` and `grade`) are required for this endpoint.

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 2004,
                         grade = 'grade-8')
```

Note that this endpoint is also callable `by` certain variables:

-   `schools/ccd/enrollment/{year}/{grade}/race/`
-   `schools/ccd/enrollment/{year}/{grade}/sex/`
-   `schools/ccd/enrollment/{year}/{grade}/race/sex/`

These optional variables can be added to the `by` argument:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 2004,
                         grade = 'grade-8',
                         by = list('race', 'sex'))
```

You may also filter the results of an API call:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 2004,
                         grade = 'grade-8',
                         by = list('race', 'sex'),
                         filters = list('ncessch' = '010000200277'))
```
