#!/bin/bash

PATH_leno = '/home/seed/Desktop/Projects/R_project:/home/rstudio rocker/tidyverse'
PATH_sz5 = '/home/seed/Desktop/Projects/R_project:/home/rstudio rocker/verse'


#---lenovo
csudo docker run --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -v /home/seed/Desktop/Projects/R_project:/home/rstudio rocker/tidyverse

#---sz5
csudo docker run --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -v /home/seed/Desktop/Projects/R_project:/home/rstudio rocker/verse