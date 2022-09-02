FROM ubi8

ARG RPACKAGE_REPO=https://packagemanager.rstudio.com/

ARG R_VERSION=4.1.1

ENV DISPLAY=10

ENV NOAWT=1

RUN echo 'options(repos = c(RSPM = "https://packagemanager.rstudio.com/"))' >> /opt/R/${R_VERSION}/lib/R/etc/Rprofile.site
RUN dos2unix /opt/R/${R_VERSION}/lib/R/etc/Makevars /opt/R/${R_VERSION}/lib64/R/etc/Makevars /opt/R/${R_VERSION}/lib64/R/etc/Renviron /opt/R/${R_VERSION}/lib/R/etc/Renviron
RUN R CMD javareconf \
       && mkdir /root/.R && echo -e "CXX14=g++ -std=c++1y -O3 -Wno-unused-variable -Wno-unused-function -Wno-builtin-macro-redefined -fPIC\nCXX14FLAGS=-O3 -march=core-avx-i -Wno-unused-variable -Wno-unused-function -Wno-builtin-macro-redefined\nCFLAGS=-O3 -march=core-avx-i -Wno-unused-variable -Wno-unused-function -Wno-builtin-macro-redefined" >> /root/.R/Makevars

# Installing Packages

RUN Rscript -e "install.packages('https://packagemanager.rstudio.com/BH_1.66.0-1.tar.gz')"
RUN Rscript -e "install.packages('shinyMixR', repos = '${RPACKAGE_REPO}' , dependencies = TRUE)"
COPY Packages.csv /sources/Packages.csv

RUN Rscript -e "install.packages(scan('file:///sources/Packages.csv', what='character'), repos = '${RPACKAGE_REPO}' , dependencies = TRUE)"

#Installing Rmpi and doMPI
RUN Rscript -e "install.packages('Rmpi', configure.args=c('--with-Rmpi-libpath=/usr/lib64/openmpi/lib','--with-Rmpi-type=OPENMPI','--with-Rmpi-include=/usr/include/openmpi-x86_64'),repos = '${RPACKAGE_REPO}')"
RUN Rscript -e "install.packages('doMPI',repos = '${RPACKAGE_REPO}')"

# Remove Compiler C FLAGS to install Rgraphviz,,gRbase,gRain
RUN mv /root/.R/Makevars /root/.R/Makevars_bkp \
&& Rscript -e "install.packages('Rgraphviz', repos = '${RPACKAGE_REPO}' , dependencies = TRUE)" \
&& Rscript -e "install.packages('gRbase', repos = '${RPACKAGE_REPO}' , dependencies = TRUE)" \
&& Rscript -e "install.packages('gRain', repos = '${RPACKAGE_REPO}' , dependencies = TRUE)" \
&& mv /root/.R/Makevars_bkp /root/.R/Makevars

# create symlink for R4 required in testing framework
RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R-4.1.1

# setting up the environment variable so that all users can access this makevars file
ENV R_MAKEVARS_SITE=/opt/R/${R_VERSION}/lib/R/etc/Makevars

# Remove Package files
RUN rm -rf /sources
