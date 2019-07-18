FROM openanalytics/r-base

MAINTAINER Tobias Verbeke "tobias.verbeke@openanalytics.eu"

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    xtail \
    libssl1.0.0

# packages needed for basic shiny functionality.
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'quantmod', 'tidyverse', 'gsheet', 'ggplot2', 'shinydashboard', 'highcharter', 'shinyWidgets', 'latexpdf', 'log4r', 'shinyBS', 'Rmpfr'), repos='http://cran.rstudio.com/')"

# install shinyproxy package with demo shiny application
COPY shinyproxy_0.0.1.tar.gz /root/
RUN R CMD INSTALL /root/shinyproxy_0.0.1.tar.gz
RUN rm /root/shinyproxy_0.0.1.tar.gz
# copy the app to the image

RUN mkdir /root/euler
COPY euler /root/euler

RUN mkdir /root/turiappv0_1
COPY turiappv0_1 /root/turiappv0_1

# set host and port
COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

#CMD ["R", "-e", "shinyproxy::run_01_hello()"]
#CMD ["R", "-e shiny::runApp('/root/euler')"]
CMD ["R", "-e shiny::runApp('/root/turiappv0_1')"]
