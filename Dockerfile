FROM redhat/ubi8
RUN subscription-manager register --username=jdesh600 --password=Honey@600 \
&& subscription-manager attach --auto \
&& subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms \
&& dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
&& dnf clean all

RUN dnf install -y wget

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

RUN wget https://github.com/metrumresearchgroup/pkgr/releases/download/v3.1.0/pkgr_3.1.0_linux_amd64.tar.gz -O /tmp/pkgr.tar.gz \
&& tar -xzf /tmp/pkgr.tar.gz pkgr \
&& mv pkgr /usr/local/bin/pkgr \
&& chmod +x /usr/local/bin/pkgr \
&& rm -rf /tmp/pkgr.tar.gz

Version: 1
# top level packages
Packages:
  - rmarkdown
  - bitops
  - caTools
  - knitr
  - tidyverse
  - shiny
  - logrrr

# any repositories, order matters
Repos:
  - MPN: "https://mpn.metworx.com/snapshots/stable/2020-09-20"
  - CRAN: "https://cran.rstudio.com"

# path to install packages to
Library: "/usr/local/bin/"

# package specific customizations
Customizations:
  Packages:
    - tidyverse:
        Suggests: true
