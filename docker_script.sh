#!/bin/bash

PATH_leno = '/home/seed/Desktop/Projects/R_project:/home/rstudio rocker/tidyverse'
PATH_sz5 = '/home/seed/Desktop/Projects/R_project:/home/rstudio rocker/verse'


#---lenovo
docker run --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -v /home/seed/Desktop/Projects/R_project:/home/rstudio rocker/tidyverse

#---sz5
docker run -it --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -e USERID=1000  -v /home/seed/Desktop/projects/R_project:/home/rstudio rocker/verse

# docker run -it --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -e USERID=$(id -u $USER)  -v /home/seed/Desktop/projects/R_project:/home/rstudio rocker/verse
# sudo docker run -it --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -e USERID=$(id -u $USER) -u "$(id -u $USER):$(id -g $USER)" -v /home/seed/Desktop/projects/R_project:/home/rstudio rocker/verse
# sudo docker run -it --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu  -u 1000:1000 -v /home/seed/Desktop/projects/R_project:/home/rstudio rocker/verse
# sudo docker run -it --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu   -v /home/seed/Desktop/projects/R_project:/home/rstudio rocker/verse

# sudo docker run -it --rm -d -p 8787:8787  -e PASSWORD=oyakokatsu -v /home/seed/Desktop/projects/R_project:/home/rstudio rocker/verse
