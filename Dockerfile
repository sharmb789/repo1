FROM redhat/ubi8 as base
RUN subscription-manager register --username=jdesh600 --password=Honey@600 \
&& subscription-manager attach --auto \
&& subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms \
&& dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
&& dnf clean all

RUN echo "Installing Redhat UBI system dependecies" \
&& dnf install -y binutils-2.30-113.el8.x86_64 \
  bzip2-devel-1.0.6-26.el8.x86_64 \
  cairo-1.15.12-6.el8.x86_64 \
  cpp-8.5.0-10.el8.x86_64 \
  dejavu-fonts-common-2.35-7.el8.noarch \
  dejavu-sans-fonts-2.35-7.el8.noarch \
  fontconfig-2.13.1-4.el8.x86_64 \
  fontpackages-filesystem-1.44-22.el8.noarch \
  freetype-2.9.1-4.el8_3.1.x86_64 \
  fribidi-1.0.4-8.el8.x86_64 \
  gcc-8.5.0-10.el8.x86_64 \
  gcc-c++-8.5.0-10.el8.x86_64 \
  gcc-gfortran-8.5.0-10.el8.x86_64 \
  glibc-devel-2.28-189.1.el8.x86_64 \
  glibc-headers-2.28-189.1.el8.x86_64 \
  graphite2-1.3.10-10.el8.x86_64 \
  harfbuzz-1.7.5-3.el8.x86_64 \
  isl-0.16.1-6.el8.x86_64 \
  jbigkit-libs-2.1-14.el8.x86_64 \
  kernel-headers-4.18.0-372.9.1.el8.x86_64 \
  libICE-1.0.9-15.el8.x86_64 \
  libSM-1.2.3-1.el8.x86_64 \
  libX11-1.6.8-5.el8.x86_64 \
  libX11-common-1.6.8-5.el8.noarch \
  libXau-1.0.9-3.el8.x86_64 \
  libXext-1.3.4-1.el8.x86_64 \
  libXft-2.3.3-1.el8.x86_64 \
  libXmu-1.1.3-1.el8.x86_64 \
  libXrender-0.9.10-7.el8.x86_64 \
  libXt-1.1.5-12.el8.x86_64 \
  libcurl-devel-7.61.1-22.el8.x86_64 \
  libdatrie-0.2.9-7.el8.x86_64 \
  libgfortran-8.5.0-10.el8.x86_64 \
  libgomp-8.5.0-10.el8.x86_64 \
  libicu-60.3-2.el8_1.x86_64 \
  libicu-devel-60.3-2.el8_1.x86_64 \
  libjpeg-turbo-1.5.3-12.el8.x86_64 \
  libmpc-1.1.0-9.1.el8.x86_64 \
  libpkgconf-1.4.2-1.el8.x86_64 \
  libpng-1.6.34-5.el8.x86_64 \
  libquadmath-8.5.0-10.el8.x86_64 \
  libquadmath-devel-8.5.0-10.el8.x86_64 \
  libquadmath-devel-8.5.0-10.el8.x86_64 \
  libstdc++-devel-8.5.0-10.el8.x86_64 \
  libthai-0.1.27-2.el8.x86_64 \
  libtiff-4.0.9-21.el8.x86_64 \
  libxcb-1.13.1-1.el8.x86_64 \
  libxcrypt-devel-4.1.1-6.el8.x86_64 \
  make-4.2.1-11.el8.x86_64 \
  openblas-threads-0.3.15-3.el8.x86_64 \
  pango-1.42.4-8.el8.x86_64 \
  pcre2-devel-10.32-2.el8.x86_64 \
  pcre2-utf16-10.32-2.el8.x86_64 \
  pcre2-utf32-10.32-2.el8.x86_64 \
  pixman-0.38.4-2.el8.x86_64 \
  pkgconf-1.4.2-1.el8.x86_64 \
  pkgconf-m4-1.4.2-1.el8.noarch \
  pkgconf-pkg-config-1.4.2-1.el8.x86_64 \
  tcl-8.6.8-2.el8.x86_64 \
  tk-8.6.8-1.el8.x86_64 \
  unzip-6.0-46.el8.x86_64 \
  xz-devel-5.2.4-3.el8.x86_64 \
  zip-3.0-23.el8.x86_64 \
  zlib-devel-1.2.11-18.el8_5.x86_64 \
&& dnf clean all

ARG R_VERSION=4.1.1
RUN echo "Installing R-4.1.1 Base..." && \
    curl -O https://cdn.rstudio.com/r/centos-8/pkgs/R-${R_VERSION}-1-1.x86_64.rpm && \
    dnf install -y R-${R_VERSION}-1-1.x86_64.rpm  dos2unix && \
    dnf clean all && \
    rm -rf R-${R_VERSION}-1-1.x86_64.rpm &&\
    ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

COPY Makevars /opt/R/${R_VERSION}/lib/R/etc/Makevars
COPY Makevars /opt/R/${R_VERSION}/lib64/R/etc/Makevars

COPY Renviron /opt/R/${R_VERSION}/lib/R/etc/Renviron
COPY Renviron /opt/R/${R_VERSION}/lib64/R/etc/Renviron

ARG RPACKAGE_REPO=https://packagemanager.rstudio.com/all/latest

ARG R_VERSION=4.1.1

ENV DISPLAY=10

ENV NOAWT=1

RUN echo 'options(repos = c(RSPM = "https://packagemanager.rstudio.com/"))' >> /opt/R/${R_VERSION}/lib/R/etc/Rprofile.site
RUN dos2unix /opt/R/${R_VERSION}/lib/R/etc/Makevars /opt/R/${R_VERSION}/lib64/R/etc/Makevars /opt/R/${R_VERSION}/lib64/R/etc/Renviron /opt/R/${R_VERSION}/lib/R/etc/Renviron
RUN R CMD javareconf \
       && mkdir /root/.R && echo -e "CXX14=g++ -std=c++1y -O3 -Wno-unused-variable -Wno-unused-function -Wno-builtin-macro-redefined -fPIC\nCXX14FLAGS=-O3 -march=core-avx-i -Wno-unused-variable -Wno-unused-function -Wno-builtin-macro-redefined\nCFLAGS=-O3 -march=core-avx-i -Wno-unused-variable -Wno-unused-function -Wno-builtin-macro-redefined" >> /root/.R/Makevars

# Installing Packages

RUN Rscript -e "install.packages('https://packagemanager.rstudio.com/all/latest/BH_1.66.0-1.tar.gz')"
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
