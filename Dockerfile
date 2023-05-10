FROM openanalytics/r-base

MAINTAINER Jihun Kim "toujours209@gmail.com"

RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libgsl-dev \
    libssh2-1-dev \
    libssl1.1 \
    libxml2-dev \
    build-essential \
    r-base-dev \
    pkg-config \
    cmake \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"

Run R -e "install.packages(c('seqinr', 'shinydashboard', 'tidyverse', 'plotly', 'shinyWidgets', 'shinyjs', 'googleVis', 'xtable'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('DT', 'htmltools', 'phangorn', 'bios2mds', 'zip', 'ape', 'zCompositions', 'compositions', 'stringr'), repos='https://cloud.r-project.org/')"
RUN R -e "install.packages(c('rpart', 'rpart.plot', 'caret', 'ggplot2', 'randomForest', 'data.table', 'xgboost', 'SHAPforxgboost', 'fontawesome', 'grid', 'ggplotify'), repos='https://cloud.r-project.org/')"
Run R -e "install.packages(c('BiocManager', 'devtools', 'remotes'), repos='https://cloud.r-project.org/')"

RUN R -e "BiocManager::install('phyloseq')"

RUN R -e "devtools::install_github('joey711/biomformat')"
RUN R -e "devtools::install_github('zmjones/edarf', subdir = 'pkg')"
RUN R -e "remotes::install_github('nik01010/dashboardthemes', force = TRUE)"
RUN R -e "remotes::install_github('jcrodriguez1989/chatgpt')"
 
RUN mkdir /root/app
COPY app /root/app
COPY Rprofile.site /usr/lib/R/etc/

COPY app/Data/sub.1.con.biom.Rdata /root/app
COPY app/Data/sub.1.con.biom.otu.tab.txt /root/app
COPY app/Data/sub.1.con.biom.sam.dat.txt /root/app
COPY app/Data/sub.1.con.biom.tax.tab.txt /root/app

COPY app/www/MiTree_Home_Img2.png /root/app

COPY app/MiDataProc.Data.Input.R /root/app
COPY app/MiDataProc.Data.Upload.R /root/app
COPY app/MiDataProc.ML.DT.R /root/app
COPY app/MiDataProc.ML.Models.R /root/app
COPY app/MiDataProc.ML.RF.R /root/app
COPY app/MiDataProc.ML.XGB.R /root/app
COPY app/MiDataProc.Theme.R /root/app

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/app')"]