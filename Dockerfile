FROM docker.io/alpine:latest
RUN echo $GIT_R_VERSION > /tmp/test.txt
