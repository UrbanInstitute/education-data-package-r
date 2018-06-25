
<!-- README.md is generated from README.Rmd. Please edit that file -->
educationdata
=============

[![Travis-CI Build Status](https://travis-ci.org/UrbanInstitute/education-data-package-r.svg?branch=master)](https://travis-ci.org/UrbanInstitute/education-data-package-r)

Retrieve data from the Urban Institute's [Education Data API](https://ed-data-portal.urban.org/) as a `data.frame` for easy analysis.

**Note:** This package is still currently under **active** development. Please file all bugs, issues, and suggestions as an [Issue in the GitHub repository](https://github.com/UrbanInstitute/education-data-package-r/issues) for the development team.

Installation
------------

To install `educationdata`:

-   Install the `devtools` package if you don't already have it, and run:

``` r
# install.packages('devtools') # if necessary
devtools::install_github('UrbanInstitute/education-data-package-r')
```

Usage
-----

``` r
library(educationdata)

df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE)

head(df)
#>   year      ncessch grade                              race    sex
#> 1 2008 340606000122     9 American Indian or Alaskan Native Female
#> 2 2008 340606000122     9 American Indian or Alaskan Native   Male
#> 3 2008 340606000122     9                             Asian Female
#> 4 2008 340606000122     9                             Asian   Male
#> 5 2008 340606000122     9                          Hispanic Female
#> 6 2008 340606000122     9                          Hispanic   Male
#>   enrollment
#> 1          0
#> 2          0
#> 3         32
#> 4         39
#> 5         38
#> 6         39
```

The `get_education_data()` function will return a `data.frame` from a call to the Education Data API.

``` r
get_education_data(level, source, topic, by, filters, add_labels)
```

where:

-   level (required) - API data level to query.
-   source (requried) - API data source to query.
-   topic (required) - API data topic to query.
-   by (optional) - Optional `list` of grouping parameters for an API call.
-   filters (optional) - Optional `list` query to filter the results from an API call.
-   add\_labels - Add variable labels (when applicable)? Defaults to `FALSE`.
-   csv - Download the full csv file? Defaults to `FALSE`.

Available Endpoints
-------------------

| Level              | Source | Topic                           | By        | Main Filters           | Years Available                   |
|:-------------------|:-------|:--------------------------------|:----------|:-----------------------|:----------------------------------|
| college-university | ipeds  | admissions-enrollment           | NA        | year                   | 2001–2016                         |
| college-university | ipeds  | admissions-requirements         | NA        | year                   | 1990–2016                         |
| college-university | ipeds  | completers                      | NA        | year                   | 2011–2015                         |
| college-university | ipeds  | completions-cip                 | NA        | year                   | 1991–2015                         |
| college-university | ipeds  | directory                       | NA        | year                   | 1980, 1984–2016                   |
| college-university | ipeds  | enrollment-full-time-equivalent | NA        | year, level\_of\_study | 2003–2015                         |
| college-university | ipeds  | fall-enrollment                 | age, sex  | year, level\_of\_study | 1991, 1993, 1995, 1997, 1999–2016 |
| college-university | ipeds  | fall-enrollment                 | race, sex | year, level\_of\_study | 1986–2015                         |
| college-university | ipeds  | fall-retention                  | NA        | year                   | 2003–2016                         |
| college-university | ipeds  | grad-rates-200pct               | NA        | year                   | 2007–2015                         |
| college-university | ipeds  | grad-rates-pell                 | NA        | year                   | 2015                              |
| college-university | ipeds  | grad-rates                      | NA        | year                   | 1996–2015                         |
| college-university | ipeds  | institutional-characteristics   | NA        | year                   | 1980, 1984–2016                   |
| college-university | ipeds  | outcome-measures                | NA        | year                   | 2015                              |
| college-university | ipeds  | student-faculty-ratio           | NA        | year                   | 2009–2016                         |
| school-districts   | ccd    | finance                         | NA        | year                   | 1991–2013                         |
| school-districts   | saipe  | NA                              | NA        | year                   | 1995, 1997, 1999–2016             |
| schools            | ccd    | directory                       | NA        | year                   | 1986–2014                         |
| schools            | ccd    | enrollment                      | NA        | year, grade            | 1987–2014                         |
| schools            | ccd    | enrollment                      | race      | year, grade            | 1987–2014                         |
| schools            | ccd    | enrollment                      | race, sex | year, grade            | 1987–2014                         |
| schools            | ccd    | enrollment                      | sex       | year, grade            | 1987–2014                         |

Main Filters
------------

Due to the way the API is set-up, the variables listed within 'main filters' are the fastest way to subset an API call.

In addition to `year`, the other main filters for certain endpoints accept the following values:

### Grade

| Filter Argument      | Grade            |
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

| Filter Argument                         | Level of Study     |
|-----------------------------------------|--------------------|
| `level_of_study = 'undergraduate'`      | Undergraduate      |
| `level_of_study = 'graduate'`           | Graduate           |
| `level_of_study = 'first-professional'` | First Professional |
| `level_of_study = 'post-baccalaureate'` | Post-baccalaureate |
| `level_of_study = '99'`                 | Total              |

Examples
--------

Let's build up some examples, from the following set of endpoints.

| Level   | Source | Topic      | By        | Main Filters | Years Available |
|:--------|:-------|:-----------|:----------|:-------------|:----------------|
| schools | ccd    | enrollment | NA        | year, grade  | 1987–2014       |
| schools | ccd    | enrollment | race      | year, grade  | 1987–2014       |
| schools | ccd    | enrollment | race, sex | year, grade  | 1987–2014       |
| schools | ccd    | enrollment | sex       | year, grade  | 1987–2014       |

The following will return a `data.frame` across all years and grades:

``` r
library(educationdata)
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment')
```

Note that this endpoint is also callable `by` certain variables:

-   race
-   sex
-   race, sex

These variables can be added to the `by` argument:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'))
```

You may also filter the results of an API call. In this case `year` and `grade` will provide the most time-efficient subsets, and can be vectorized:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12))
```

Additional variables can also be passed to `filters` to subset further:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '3406060001227'))
```

The `add_labels` flag will map variables to a `factor` from their labels in the API.

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE)
```

Finally, the `csv` flag can be set to download the full `.csv` data frame. In general, the `csv` functionality is much faster when retrieving the full data frame (or a large subset) and much slower when retrieving a small subset of a data frame (especially ones with a lot of `filters` added). In this example, the full `csv` for 2008 must be downloaded and then subset to the 96 observations.

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         by = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE,
                         csv = TRUE)
```
