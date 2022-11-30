FROM rocker/verse:latest
MAINTAINER Luuk van der Meer <luukvandermeer@live.nl>

# -----------------------------------
# INSTALL GEOSPATIAL SYSTEM LIBARIES
# -----------------------------------

RUN apt -y update && apt -y upgrade && apt -y autoremove

# Install geospatial system libraries
# Use the Ubuntugis PPA to get more up-to-date versions
RUN apt -y install software-properties-common
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && apt -y update
RUN apt -y install gdal-bin libgdal-dev libgeos-dev proj-bin libproj-dev libudunits2-dev

# ------------------------------
# INSTALL ADDITIONAL R PACKAGES
# ------------------------------

# Install geospatial packages that directly link to geospatial system libaries
# It seems they have to be installed from source to work correctly
RUN R -e "devtools::install_github('r-spatial/sf')"
RUN R -e "devtools::install_github('r-spatial/lwgeom')"

# Install other packages from CRAN
RUN install2.r --error \
  tidyverse \
  mapview \
  sfheaders \
  units \
  here