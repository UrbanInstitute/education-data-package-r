
<!-- README.md is generated from README.Rmd. Please edit that file -->
educationdata
=============

[![Travis-CI Build Status](https://travis-ci.org/UrbanInstitute/education-data-package-r.svg?branch=master)](https://travis-ci.org/UrbanInstitute/education-data-package-r)

Retrieve data from the Urban Institute's [Education Data API](https://ed-data-portal.urban.org/) as a `data.frame` for easy analysis.

**Note:** This package is still currently under **active** development. Please file all bugs, issues, and suggestions as an [Issue in the GitHub repository](https://github.com/UrbanInstitute/education-data-package-r/issues) for the development team.

Installation
------------

To install the package:

-   Install the `devtools` package if you don't already have it, and run:

``` r
# install.packages('devtools') # if necessary
devtools::install_github('UrbanInstitute/education-data-package-r')
```

Quick Start Guide
-----------------

``` r
library(educationdata)

df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 2014,
                         grade = 'grade-12',
                         by = list('race', 'sex'),
                         filters = list('ncessch' = '340606000122'),
                         add_labels = TRUE)

head(df)
#>   year      ncessch grade                              race    sex
#> 1 2014 340606000122    12 American Indian or Alaskan Native Female
#> 2 2014 340606000122    12 American Indian or Alaskan Native   Male
#> 3 2014 340606000122    12                             Asian Female
#> 4 2014 340606000122    12                             Asian   Male
#> 5 2014 340606000122    12                          Hispanic Female
#> 6 2014 340606000122    12                          Hispanic   Male
#>   enrollment
#> 1          0
#> 2          0
#> 3         27
#> 4         36
#> 5         29
#> 6         30
```

The `get_education_data()` function will return a `data.frame` from a call to the Education Data API.

``` r
get_education_data(level, source, topic , ..., by, filters, add_labels)
```

where:

-   level (required) - API data level to query.
-   source (requried) - API data source to query.
-   topic (required) - API data topic to query.
-   ... (required) - Additional parameters required for a specific endpoint.
-   by (optional) - Optional parameters for a specific API call.
-   filters (optional) - Optional query to filter the results from an API call.
-   add\_labels - Add variable labels (when applicable)? Defaults to `FALSE`.

Endpoint Format
---------------

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

Available Endpoints
-------------------

| Endpoint                                                                            | Years Available                   |
|:------------------------------------------------------------------------------------|:----------------------------------|
| college-university/ipeds/admissions-enrollment/{year}/                              | 2001-2016                         |
| college-university/ipeds/admissions-requirements/{year}/                            | 1990-2016                         |
| college-university/ipeds/completers/{year}/                                         | 2011-2015                         |
| college-university/ipeds/completions-cip/{year}/                                    | 1991-2015                         |
| college-university/ipeds/directory/{year}/                                          | 1980, 1984-2016                   |
| college-university/ipeds/enrollment-full-time-equivalent/{year}/{level\_of\_study}/ | 2003-2015                         |
| college-university/ipeds/enrollment-headcount/{year}/{level\_of\_study}/            | 1996-2015                         |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/                 | 1986-2015                         |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/age/             | 1991, 1993, 1995, 1997, 1999-2016 |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/age/sex/         | 1991, 1993, 1995, 1997, 1999-2016 |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/race/            | 1986-2015                         |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/race/sex/        | 1986-2015                         |
| college-university/ipeds/fall-enrollment/{year}/{level\_of\_study}/sex/             | 1986-2015                         |
| college-university/ipeds/fall-retention/{year}/                                     | 2003-2016                         |
| college-university/ipeds/grad-rates-200pct/{year}/                                  | 2007-2015                         |
| college-university/ipeds/grad-rates-pell/{year}/                                    | 2015                              |
| college-university/ipeds/grad-rates/{year}/                                         | 1996-2015                         |
| college-university/ipeds/institutional-characteristics/{year}/                      | 1980, 1984-2016                   |
| college-university/ipeds/outcome-measures/{year}/                                   | 2015                              |
| college-university/ipeds/student-faculty-ratio/{year}/                              | 2009-2016                         |
| school-districts/ccd/finance/{year}/                                                | 1991-2013                         |
| school-districts/saipe/{year}/                                                      | 1995-2016                         |
| schools/ccd/directory/{year}/                                                       | 1986-2014                         |
| schools/ccd/enrollment/{year}/{grade}/                                              | 1987-2014                         |
| schools/ccd/enrollment/{year}/{grade}/race/                                         | 1987-2014                         |
| schools/ccd/enrollment/{year}/{grade}/race/sex/                                     | 1987-2014                         |
| schools/ccd/enrollment/{year}/{grade}/sex/                                          | 1987-2014                         |

Required Variables
------------------

In addition to `year`, the other requried variables for certain endpoints accept the following values:

### Grade

| Function Argument    | Grade            |
|----------------------|------------------|
| `grade = 'grade-pk'` | Pre-K            |
| `grade = 'grade-k'`  | Kindergarten     |
| `grade = 'grade-1'`  | Grade 1          |
| `grade = 'grade-2'`  | Grade 2          |
| `grade = 'grade-3'`  | Grade 3          |
| `grade = 'grade-4'`  | Grade 4          |
| `grade = 'grade-5'`  | Grade 5          |
| `grade = 'grade-6'`  | Grade 6          |
| `grade = 'grade-7'`  | Grade 7          |
| `grade = 'grade-8'`  | Grade 8          |
| `grade = 'grade-9'`  | Grade 9          |
| `grade = 'grade-10'` | Grade 10         |
| `grade = 'grade-11'` | Grade 11         |
| `grade = 'grade-12'` | Grade 12         |
| `grade = 'grade-13'` | Grade 13         |
| `grade = 'grade-14'` | Adult Education  |
| `grade = 'grade-15'` | Ungraded         |
| `grade = 'grade-16'` | K-12             |
| `grade = 'grade-20'` | Grades 7 and 8   |
| `grade = 'grade-21'` | Grade 9 and 10   |
| `grade = 'grade-22'` | Grades 11 and 12 |
| `grade = 'grade-99'` | Total            |

### Level of Study

| Function Argument                       | Level of Study     |
|-----------------------------------------|--------------------|
| `level_of_study = 'undergraduate'`      | Undergraduate      |
| `level_of_study = 'graduate'`           | Graduate           |
| `level_of_study = 'first-professional'` | First Professional |
| `level_of_study = 'post-baccalaureate'` | Post-baccalaureate |
| `level_of_study = '99'`                 | Total              |

Usage
-----

Use the `get_education_data()` function to retrieve a `data.frame` from an API endpoint.

``` r
get_education_data(level, source, topic, ..., by, filters, add_labels)
```

The `get_education_data()` function will parse and validate several arguments against the API.

-   level (required) - API data level to query. Current levels are:
    -   college-university
    -   school-districts
    -   schools
-   source (required) - API data source to query. Current sources are:
    -   ccd
    -   ipeds
    -   saipe
-   topic (required) - API data topic to query.
-   ... (required) - Additional parameters required for a specific API call.
-   by - Optional parameters for a specific API call.
-   filters - Optional query to filter the results from an API call.
-   add\_labels - Add variable labels (when applicable)? Defaults to `FALSE`.

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

The `year` parameter is vectorized and can accept multiple years:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 2004:2008,
                         grade = 'grade-8')
```

Or the endpoint can be called for 'all' `years`:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 'all',
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

Finally, the `add_labels` flag will map variables to a `factor` from their labels in the API.

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         year = 2014,
                         grade = 'grade-8',
                         add_labels = TRUE)
```
