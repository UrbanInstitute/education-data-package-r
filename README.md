
<!-- README.md is generated from README.Rmd. Please edit that file -->

# educationdata

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/educationdata)](https://cran.r-project.org/package=educationdata)
[![R-CMD-check](https://github.com/UrbanInstitute/education-data-package-r/workflows/R-CMD-check/badge.svg)](https://github.com/UrbanInstitute/education-data-package-r/actions)
<!-- badges: end -->

Retrieve data from the Urban Institute’s [Education Data
API](https://educationdata.urban.org/) as a `data.frame` for easy
analysis.

**NOTE**: By downloading and using this programming package, you agree
to abide by the [Data Policy and Terms of Use of the Education Data
Portal](https://educationdata.urban.org/documentation/#terms).

## Installation

You can install the released version of `educationdata` from
[CRAN](https://cran.r-project.org/web/packages/educationdata/index.html)
with:

``` r
install.packages("educationdata")
```

And the development version from GitHub with:

``` r
# install.packages('devtools') # if necessary
devtools::install_github('UrbanInstitute/education-data-package-r')
```

## Usage

``` r
library(educationdata)

df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         subtopic = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE)

str(df)
#> 'data.frame':    96 obs. of  9 variables:
#>  $ year       : int  2008 2008 2008 2008 2008 2008 2008 2008 2008 2008 ...
#>  $ ncessch    : chr  "340606000122" "340606000122" "340606000122" "340606000122" ...
#>  $ ncessch_num: num  3.41e+11 3.41e+11 3.41e+11 3.41e+11 3.41e+11 ...
#>  $ grade      : Factor w/ 19 levels "Pre-K","Kindergarten",..: 11 11 11 11 11 11 11 11 11 11 ...
#>  $ race       : Factor w/ 14 levels "White","Black",..: 2 3 5 5 2 4 6 11 1 7 ...
#>  $ sex        : Factor w/ 7 levels "Male","Female",..: 1 1 2 1 2 2 2 1 2 1 ...
#>  $ enrollment : int  41 39 0 0 46 32 3 270 166 0 ...
#>  $ fips       : Factor w/ 79 levels "Alabama","Alaska",..: 34 34 34 34 34 34 34 34 34 34 ...
#>  $ leaid      : chr  "3406060" "3406060" "3406060" "3406060" ...
```

The `get_education_data()` function will return a `data.frame` from a
call to the Education Data API.

``` r
get_education_data(level, source, topic, subtopic, filters, add_labels)
```

where:

-   level (required) - API data level to query.
-   source (required) - API data source to query.
-   topic (required) - API data topic to query.
-   subtopic (optional) - Optional `list` of grouping parameters for an
    API call.
-   filters (optional) - Optional `list` query to filter the results
    from an API call.
-   add_labels - Add variable labels (when applicable)? Defaults to
    `FALSE`.
-   csv - Download the full csv file? Defaults to `FALSE`.

## Available Endpoints

| Level              | Source    | Topic                              | Subtopic              | Main Filters         | Years Available                               |
|:-------------------|:----------|:-----------------------------------|:----------------------|:---------------------|:----------------------------------------------|
| college-university | fsa       | 90-10-revenue-percentages          | NA                    | year                 | 2014–2017                                     |
| college-university | fsa       | campus-based-volume                | NA                    | year                 | 2001–2017                                     |
| college-university | fsa       | financial-responsibility           | NA                    | year                 | 2006–2016                                     |
| college-university | fsa       | grants                             | NA                    | year                 | 1999–2018                                     |
| college-university | fsa       | loans                              | NA                    | year                 | 1999–2018                                     |
| college-university | ipeds     | academic-libraries                 | NA                    | year                 | 2013–2019                                     |
| college-university | ipeds     | academic-year-room-board-other     | NA                    | year                 | 1999–2020                                     |
| college-university | ipeds     | academic-year-tuition-prof-program | NA                    | year                 | 1986–2008, 2010–2020                          |
| college-university | ipeds     | academic-year-tuition              | NA                    | year                 | 1986–2020                                     |
| college-university | ipeds     | admissions-enrollment              | NA                    | year                 | 2001–2019                                     |
| college-university | ipeds     | admissions-requirements            | NA                    | year                 | 1990–2019                                     |
| college-university | ipeds     | completers                         | NA                    | year                 | 2011–2019                                     |
| college-university | ipeds     | completions-cip-2                  | NA                    | year                 | 1991–2019                                     |
| college-university | ipeds     | completions-cip-6                  | NA                    | year                 | 1983–2019                                     |
| college-university | ipeds     | directory                          | NA                    | year                 | 1980, 1984–2020                               |
| college-university | ipeds     | enrollment-full-time-equivalent    | NA                    | year, level_of_study | 1997–2018                                     |
| college-university | ipeds     | enrollment-headcount               | NA                    | year, level_of_study | 1996–2018                                     |
| college-university | ipeds     | fall-enrollment                    | age, sex              | year, level_of_study | 1991, 1993, 1995, 1997, 1999–2020             |
| college-university | ipeds     | fall-enrollment                    | race, sex             | year, level_of_study | 1986–2020                                     |
| college-university | ipeds     | fall-enrollment                    | residence             | year                 | 1986, 1988, 1992, 1994, 1996, 1998, 2000–2020 |
| college-university | ipeds     | fall-retention                     | NA                    | year                 | 2003–2020                                     |
| college-university | ipeds     | finance                            | NA                    | year                 | 1979, 1983–2017                               |
| college-university | ipeds     | grad-rates-200pct                  | NA                    | year                 | 2007–2017                                     |
| college-university | ipeds     | grad-rates-pell                    | NA                    | year                 | 2015–2017                                     |
| college-university | ipeds     | grad-rates                         | NA                    | year                 | 1996–2017                                     |
| college-university | ipeds     | institutional-characteristics      | NA                    | year                 | 1980, 1984–2020                               |
| college-university | ipeds     | outcome-measures                   | NA                    | year                 | 2015–2018                                     |
| college-university | ipeds     | program-year-room-board-other      | NA                    | year                 | 1999–2020                                     |
| college-university | ipeds     | program-year-tuition-cip           | NA                    | year                 | 1987–2020                                     |
| college-university | ipeds     | salaries-instructional-staff       | NA                    | year                 | 1980, 1984, 1985, 1987, 1989–1999, 2001–2018  |
| college-university | ipeds     | salaries-noninstructional-staff    | NA                    | year                 | 2012–2018                                     |
| college-university | ipeds     | sfa-all-undergraduates             | NA                    | year                 | 2007–2017                                     |
| college-university | ipeds     | sfa-by-living-arrangement          | NA                    | year                 | 2008–2017                                     |
| college-university | ipeds     | sfa-by-tuition-type                | NA                    | year                 | 1999–2017                                     |
| college-university | ipeds     | sfa-ftft                           | NA                    | year                 | 1999–2017                                     |
| college-university | ipeds     | sfa-grants-and-net-price           | NA                    | year                 | 2008–2017                                     |
| college-university | ipeds     | student-faculty-ratio              | NA                    | year                 | 2009–2020                                     |
| college-university | nacubo    | endowments                         | NA                    | year                 | 2012–2018                                     |
| college-university | nccs      | 990-forms                          | NA                    | year                 | 1993–2016                                     |
| college-university | nhgis     | census-1990                        | NA                    | year                 | 1980, 1984–2017                               |
| college-university | nhgis     | census-2000                        | NA                    | year                 | 1980, 1984–2017                               |
| college-university | nhgis     | census-2010                        | NA                    | year                 | 1980, 1984–2017                               |
| college-university | scorecard | default                            | NA                    | year                 | 1996–2017                                     |
| college-university | scorecard | earnings                           | NA                    | year                 | 2003–2014                                     |
| college-university | scorecard | institutional-characteristics      | NA                    | year                 | 1996–2017                                     |
| college-university | scorecard | repayment                          | NA                    | year                 | 2007–2016                                     |
| college-university | scorecard | student-characteristics            | aid-applicants        | year                 | 1997–2016                                     |
| college-university | scorecard | student-characteristics            | home-neighborhood     | year                 | 1997–2016                                     |
| school-districts   | ccd       | directory                          | NA                    | year                 | 1986–2020                                     |
| school-districts   | ccd       | enrollment                         | NA                    | year, grade          | 1986–2020                                     |
| school-districts   | ccd       | enrollment                         | race                  | year, grade          | 1986–2020                                     |
| school-districts   | ccd       | enrollment                         | race, sex             | year, grade          | 1986–2020                                     |
| school-districts   | ccd       | enrollment                         | sex                   | year, grade          | 1986–2020                                     |
| school-districts   | ccd       | finance                            | NA                    | year                 | 1991, 1994–2018                               |
| school-districts   | edfacts   | assessments                        | NA                    | year, grade_edfacts  | 2009–2018                                     |
| school-districts   | edfacts   | assessments                        | race                  | year, grade_edfacts  | 2009–2018                                     |
| school-districts   | edfacts   | assessments                        | sex                   | year, grade_edfacts  | 2009–2018                                     |
| school-districts   | edfacts   | assessments                        | special-populations   | year, grade_edfacts  | 2009–2018                                     |
| school-districts   | edfacts   | grad-rates                         | NA                    | year                 | 2010–2018                                     |
| school-districts   | saipe     | NA                                 | NA                    | year                 | 1995, 1997, 1999–2018                         |
| schools            | ccd       | directory                          | NA                    | year                 | 1986–2020                                     |
| schools            | ccd       | enrollment                         | NA                    | year, grade          | 1986–2020                                     |
| schools            | ccd       | enrollment                         | race                  | year, grade          | 1986–2020                                     |
| schools            | ccd       | enrollment                         | race, sex             | year, grade          | 1986–2020                                     |
| schools            | ccd       | enrollment                         | sex                   | year, grade          | 1986–2020                                     |
| schools            | crdc      | algebra1                           | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | algebra1                           | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | algebra1                           | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | ap-exams                           | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | ap-exams                           | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | ap-exams                           | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | ap-ib-enrollment                   | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | ap-ib-enrollment                   | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | ap-ib-enrollment                   | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | chronic-absenteeism                | disability, sex       | year                 | 2013, 2015                                    |
| schools            | crdc      | chronic-absenteeism                | lep, sex              | year                 | 2013, 2015                                    |
| schools            | crdc      | chronic-absenteeism                | race, sex             | year                 | 2013, 2015                                    |
| schools            | crdc      | credit-recovery                    | NA                    | year                 | 2015, 2017                                    |
| schools            | crdc      | directory                          | NA                    | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | discipline-instances               | NA                    | year                 | 2015, 2017                                    |
| schools            | crdc      | discipline                         | disability, lep, sex  | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | discipline                         | disability, race, sex | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | discipline                         | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | dual-enrollment                    | disability, sex       | year                 | 2013, 2015, 2017                              |
| schools            | crdc      | dual-enrollment                    | lep, sex              | year                 | 2013, 2015, 2017                              |
| schools            | crdc      | dual-enrollment                    | race, sex             | year                 | 2013, 2015, 2017                              |
| schools            | crdc      | enrollment                         | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | enrollment                         | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | enrollment                         | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | harassment-or-bullying             | allegations           | year                 | 2013, 2015, 2017                              |
| schools            | crdc      | harassment-or-bullying             | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | harassment-or-bullying             | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | harassment-or-bullying             | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | math-and-science                   | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | math-and-science                   | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | math-and-science                   | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | offenses                           | NA                    | year                 | 2015, 2017                                    |
| schools            | crdc      | offerings                          | NA                    | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | restraint-and-seclusion            | disability, lep, sex  | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | restraint-and-seclusion            | disability, race, sex | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | restraint-and-seclusion            | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | restraint-and-seclusion            | instances             | year                 | 2013, 2015, 2017                              |
| schools            | crdc      | retention                          | disability, sex       | year, grade          | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | retention                          | lep, sex              | year, grade          | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | retention                          | race, sex             | year, grade          | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | sat-act-participation              | disability, sex       | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | sat-act-participation              | lep, sex              | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | sat-act-participation              | race, sex             | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | school-finance                     | NA                    | year                 | 2011, 2013, 2015, 2017                        |
| schools            | crdc      | suspensions-days                   | disability, sex       | year                 | 2015, 2017                                    |
| schools            | crdc      | suspensions-days                   | lep, sex              | year                 | 2015, 2017                                    |
| schools            | crdc      | suspensions-days                   | race, sex             | year                 | 2015, 2017                                    |
| schools            | crdc      | teachers-staff                     | NA                    | year                 | 2011, 2013, 2015, 2017                        |
| schools            | edfacts   | assessments                        | NA                    | year, grade_edfacts  | 2009–2018                                     |
| schools            | edfacts   | assessments                        | race                  | year, grade_edfacts  | 2009–2018                                     |
| schools            | edfacts   | assessments                        | sex                   | year, grade_edfacts  | 2009–2018                                     |
| schools            | edfacts   | assessments                        | special-populations   | year, grade_edfacts  | 2009–2018                                     |
| schools            | edfacts   | grad-rates                         | NA                    | year                 | 2010–2018                                     |
| schools            | meps      | NA                                 | NA                    | year                 | 2013–2018                                     |
| schools            | nhgis     | census-1990                        | NA                    | year                 | 1986–2020                                     |
| schools            | nhgis     | census-2000                        | NA                    | year                 | 1986–2020                                     |
| schools            | nhgis     | census-2010                        | NA                    | year                 | 1986–2020                                     |

## Main Filters

Due to the way the API is set-up, the variables listed within ‘main
filters’ are the fastest way to subset an API call.

In addition to `year`, the other main filters for certain endpoints
accept the following values:

### Grade

| Filter Argument      | Grade           |
|----------------------|-----------------|
| `grade = 'grade-pk'` | Pre-K           |
| `grade = 'grade-k'`  | Kindergarten    |
| `grade = 'grade-1'`  | Grade 1         |
| `grade = 'grade-2'`  | Grade 2         |
| `grade = 'grade-3'`  | Grade 3         |
| `grade = 'grade-4'`  | Grade 4         |
| `grade = 'grade-5'`  | Grade 5         |
| `grade = 'grade-6'`  | Grade 6         |
| `grade = 'grade-7'`  | Grade 7         |
| `grade = 'grade-8'`  | Grade 8         |
| `grade = 'grade-9'`  | Grade 9         |
| `grade = 'grade-10'` | Grade 10        |
| `grade = 'grade-11'` | Grade 11        |
| `grade = 'grade-12'` | Grade 12        |
| `grade = 'grade-13'` | Grade 13        |
| `grade = 'grade-14'` | Adult Education |
| `grade = 'grade-15'` | Ungraded        |
| `grade = 'grade-99'` | Total           |

### Level of Study

| Filter Argument                         | Level of Study     |
|-----------------------------------------|--------------------|
| `level_of_study = 'undergraduate'`      | Undergraduate      |
| `level_of_study = 'graduate'`           | Graduate           |
| `level_of_study = 'first-professional'` | First Professional |
| `level_of_study = 'post-baccalaureate'` | Post-baccalaureate |
| `level_of_study = '99'`                 | Total              |

## Examples

Let’s build up some examples, from the following set of endpoints.

| Level   | Source | Topic      | Subtopic        | Main Filters | Years Available        |
|:--------|:-------|:-----------|:----------------|:-------------|:-----------------------|
| schools | ccd    | enrollment | NA              | year, grade  | 1986–2020              |
| schools | ccd    | enrollment | race            | year, grade  | 1986–2020              |
| schools | ccd    | enrollment | race, sex       | year, grade  | 1986–2020              |
| schools | ccd    | enrollment | sex             | year, grade  | 1986–2020              |
| schools | crdc   | enrollment | disability, sex | year         | 2011, 2013, 2015, 2017 |
| schools | crdc   | enrollment | lep, sex        | year         | 2011, 2013, 2015, 2017 |
| schools | crdc   | enrollment | race, sex       | year         | 2011, 2013, 2015, 2017 |
| NA      | NA     | NA         | NULL            | NULL         | NA                     |

The following will return a `data.frame` across all years and grades:

``` r
library(educationdata)
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment')
```

Note that this endpoint is also callable by certain `subtopic`
variables:

-   race
-   sex
-   race, sex

These variables can be added to the `subtopic` argument:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         subtopic = list('race', 'sex'))
```

You may also filter the results of an API call. In this case `year` and
`grade` will provide the most time-efficient subsets, and can be
vectorized:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         subtopic = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12))
```

Additional variables can also be passed to `filters` to subset further:

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         subtopic = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '3406060001227'))
```

The `add_labels` flag will map variables to a `factor` from their labels
in the API.

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         subtopic = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE)
```

Finally, the `csv` flag can be set to download the full `.csv` data
frame. In general, the `csv` functionality is much faster when
retrieving the full data frame (or a large subset) and much slower when
retrieving a small subset of a data frame (especially ones with a lot of
`filters` added). In this example, the full `csv` for 2008 must be
downloaded and then subset to the 96 observations.

``` r
df <- get_education_data(level = 'schools', 
                         source = 'ccd', 
                         topic = 'enrollment', 
                         subtopic = list('race', 'sex'),
                         filters = list(year = 2008,
                                        grade = 9:12,
                                        ncessch = '340606000122'),
                         add_labels = TRUE,
                         csv = TRUE)
```

## Summary Endpoints

You can access the summary endpoint functionality using the
`get_education_data_summary()` function.

``` r
df <- get_education_data_summary(
    level = "schools",
    source = "ccd",
    topic = "enrollment",
    stat = "sum",
    var = "enrollment",
    by = "fips",
    filters = list(fips = 6:8, year = 2004:2005)
)
```

In this example, we take the `schools/ccd/enrollment` endpoint and
retrieve the `sum` of `enrollment` by `fips` code, filtered to `fips`
codes 6, 7, 8 for the `year`s 2004 and 2005.

The syntax largely follows the original syntax of
`get_education_data()`: with three new arguments:

-   `stat` is the summary statistic to be retrieved. Valid statistics
    include: `avg`, `sum`, `count`, `median`, `min`, `max`, `stddev`,
    and `variance`.
-   `var` is the variable to run the summary statistic on.
-   `by` is the grouping variable(s) to use. This can be a single
    string, or a vector of multiple variables, i.e.,
    `by = c("fips", "race")`.

Some endpoints are further broken out by subtopic. These can be
specified using the `subtopic` option.

``` r
df <- get_education_data_summary(
    level = "schools",
    source = "crdc",
    topic = "harassment-or-bullying",
    subtopic = "allegations",
    stat = "sum",
    var = "allegations_harass_sex",
    by = "fips"
)
```

Note that only some endpoints have an applicable `subtopic`, and this
list is slightly different from the syntax of the full data API.
Endpoints with `subtopics` for the summary endpoint functionality
include:

-   schools/crdc/harassment-or-bullying/allegations
-   schools/crdc/harassment-or-bullying/students
-   schools/crdc/restraint-and-seclusion/instances
-   schools/crdc/restraint-and-seclusion/students
-   college-university/ipeds/enrollment-full-time-equivalent/summaries
-   college-university/ipeds/fall-enrollment/age/summaries
-   college-university/ipeds/fall-enrollment/race/summaries
-   college-university/ipeds/fall-enrollment/residence/summaries
-   college-university/scorecard/student-characteristics/aid-applicants/summaries
-   college-university/scorecard/student-characteristics/home-neighborhood/summaries

For more information on the summary endpoint functionality, see the
[full API
documentation](https://educationdata.urban.org/documentation/index.html#summary_endpoints).
