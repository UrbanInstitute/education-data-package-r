# educationdata 0.0.3 (2019-07-29)

* Added mapping for `grade_edfacts` endpoints.

* Added option to test staging server to `get_education_data()` call.

# educationdata 0.0.2 (2019-04-15)

* Added improved error messaging when API returns a 504 status code

# educationdata 0.0.1 (2018-07-10)

* This release brings the `educationdata` package out of active development. 
Bug fixes and new features will be handled as noted or requested.

* Add better exception handling when API returns an HTTP error.

# educationdata 0.0.0.9003 (2018-06-27)

* Note that this package is still currently under **active** development. 
Please file all bugs, issues, and suggestions as an Issue in the GitHub 
repository for the development team. 

* Add csv option to allow users to download larger extracts from csv.

# educationdata 0.0.0.9002 (2018-05-29)

* Note that this package is still currently under **active** development. 
Please file all bugs, issues, and suggestions as an Issue in the GitHub 
repository for the development team. 

* Filter validation added to API calls. `get_education_data` calls with an 
invalid `filter` variable will return an error. Note that this validation only 
checks against the variable to filter, and note the value itself.

# educationdata 0.0.0.9001 (2018-05-23)

* Note that this package is still currently under **active** development. 
Please file all bugs, issues, and suggestions as an Issue in the GitHub 
repository for the development team. 

* 'Required variables' for an API endpoint now default to 'all' and have been 
moved out of the `...` argument and into `filters` for ease of use. A `filter` 
which uses a 'required variable' will properly parse the list of API URLs to 
fetch for efficiency.

*   A function call such as:
  
    ```r
    get_education_data(level = 'schools',
                       source = 'ccd', 
                       topic = 'enrollment')
    ```
  
    will now simply return a full `data.frame` across all years and grades.


*   A function call which used to look like:
  

    ```r
    get_education_data(level = 'schools', 
                       source = 'ccd', 
                       topic = 'enrollment',
                       year = 2004,
                       grade = 'grade-8')
    ```

    can now be called using:
  
    ```r
    get_education_data(level = 'schools', 
                       source = 'ccd', 
                       topic = 'enrollment',
                       filters = list(year = 2004, grade = 8))
    ```

* Validation and some simple completion logic added to function calls that 
can be filtered by `grade`. i.e., users can now supply just `grade = 1` 
instead of the full `grade = 'grade-1'` that is ultimately passed to the API.

* Validation and some simple completion logic added to function calls that 
can be filtered by `level_of_study`. i.e., users can now supply just 
`level_of_study = 'post-bac'` instead of the full 
`level_of_study = 'post-baccalaureate'` that is ultimately passed to the API.

# educationdata 0.0.0.9000 (2018-05-07)

* This is the initial alpha release of the `educationdata` package. Note that 
this package is still currently under **active** development. Please file all 
bugs, issues, and suggestions as an Issue in the GitHub repository for the 
development team. 
