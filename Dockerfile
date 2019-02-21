FROM golang:1.11.5-alpine3.9

ADD . /knative-build-demo

WORKDIR /knative-build-demo
RUN go build 

ENTRYPOINT ./knative-build-demo

EXPOSE 8080