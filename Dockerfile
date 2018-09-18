FROM golang:1.10.1
WORKDIR /app
COPY . /app
RUN CGO_ENABLED=0 GOOS=linux go build -v -o app

# FROM scratch
# COPY --from=0 /go/src/github.com/BrianMMcClain/knative-build-demo .
ENTRYPOINT ["/app/app"]