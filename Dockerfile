FROM ubuntu-latest

RUN subscription-manager register --username=jagadesh.sundarraj@pfizer.com --password=Honey@600 \
&& subscription-manager attach --auto \
&& dnf clean all
