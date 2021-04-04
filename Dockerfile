###############
# THE BUILDER #
###############
# Thanks: https://github.com/mailslurper/mailslurper/blob/master/Dockerfile

FROM golang:alpine as builder

RUN apk --no-cache add \
    gcc \
    git \
    libc-dev \
    zip
RUN go get github.com/mjibson/esc
RUN wget -c https://github.com/mailslurper/mailslurper/archive/refs/heads/master.zip \
         -O /tmp/mailslurper.zip \
    && unzip /tmp/mailslurper.zip -d /tmp \
    && mkdir -p /go/src/github.com/mailslurper/ \
    && mv /tmp/mailslurper-master /go/src/github.com/mailslurper/mailslurper \
    && rm -rf /tmp/mailslurper.zip /tmp/mailslurper

WORKDIR /go/src/github.com/mailslurper/mailslurper/cmd/mailslurper

RUN go get
RUN go generate
RUN go build


###########
# THE APP #
###########

LABEL maintainer="davidadi216@gmail.com"

FROM alpine:latest

WORKDIR /mailslurper

COPY --from=builder /go/src/github.com/mailslurper/mailslurper/cmd/mailslurper/mailslurper mailslurper
COPY config.json /mailslurper/config.json

EXPOSE 8080 8085 2500

CMD ["./mailslurper"]
