# R Studio Version 1.4.1717

# Date: 08/03/2022
# Contact: nrdd.admin@noaa.gov or ishrat.jabin@noaa.gov for questions/concerns

# This R code will filter NRDD Projects from a list of projects by running a 
# word search within the data fields (Project Title, Description, Benefits, etc.)
# This code requires two files to run. 

# READ ME:
# 1. Ensure that all libraries are installed/loaded before running code. 
#    Different versions of R may not be compatible with the R packages.
# 2. Export Project Information Table from QueryBuilder in HTML Table Format.
# 3. Load HTML Table file in Section 2 of code. A pop-up display will ask you to
#    select a file from your directory.
# 4. Load Excel file containing list of search/query terms.



###############################################################################
# Section 1 Libraries --------------------------------------------------------------

library(xml2)
library(rvest)
library(janitor)
library(readxl)
library(writexl)
library(dplyr)

# Section 2 Select HTML Data File, then load table ---------------------------------

htm_tbl <- read_html(file.choose()) #via HTML
Projects <- as.data.frame(html_table(htm_tbl, fill=TRUE)) #via HTML
Projects <- Projects %>% clean_names()

# Section 3 Select .xlsx file containing search terms ------------------------------

# You may find a sample xlsx file in the Github directory.
# This file contains a list of search terms to find topic-relevant projects.

query <- as.list(read_xlsx(file.choose(), sheet = 1)) #via xlsx
chr_list <- query[[1]]

# Method 1: Running lines 49 to 51 will search for projects that contain the EXACT match
# within the query list.
# For example: if you are searching for 'apple' it will search for projects 
# with the word 'apple' not 'apples'

chr_list <- paste("\\b", chr_list, sep="") %>%
            paste0( "\\b") %>%
            paste( collapse ='|')

# Method 2: Running line 57, will search for projects that contain the expression,
# even if it is not an exact match.
# For example: if you are search for 'CAM', it will pull out projects with the word 'camera'.

chr_list <- paste(query[[1]], collapse ='|')

############# Filter Projects --------------------------------------------------
# You can filter by title, description, etc. Uncomment to add the line to the code.
# make sure to add parenthesis back into the correct place.

Filtered_Projects <- Projects %>%
  filter(grepl(chr_list, project_title, ignore.case = TRUE)) # |
  # grepl(chr_list, project_description, ignore.case = TRUE) |
  # grepl(chr_list, project_benefits, ignore.case = TRUE) |
  # grepl(chr_list, project_outcome, ignore.case = TRUE))

############ Export and Save as XlSX file in your desired directory ------------

setwd(choose.dir())
write_xlsx(Filtered_Projects, path = 'Filtered NRDD Projects.xlsx')

