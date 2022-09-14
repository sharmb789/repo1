FROM redhat/ubi8
RUN subscription-manager register --username=jdesh600 --password=Honey@600 \
&& subscription-manager attach --auto \
&& subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms \
&& dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
&& dnf clean all

RUN dnf install -y wget

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
