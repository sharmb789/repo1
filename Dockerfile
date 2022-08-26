FROM redhat/ubi8

RUN subscription-manager register --username=jagadesh.sundarraj@pfizer.com --password=Honey@600 \
&& dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
&& dnf clean all
