# Start the Go app build
FROM golang:latest AS build

# Copy source
WORKDIR /go/src/github.com/jamespearly/hello
COPY . .

# If packages are installed in ./vendor (using dep), we do not need a `go get`
RUN go get -d -v ./...

# Build a statically-linked Go binary for Linux
RUN CGO_ENABLED=0 GOOS=linux go build -a -o main .

# New build phase -- create binary-only image
FROM alpine:latest

# Add support for HTTPS and time zones
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    apk add tzdata

WORKDIR /root/

# Copy files from previous build container
COPY --from=build /go/src/github.com/jamespearly/hello/main ./
# COPY --from=build /go/src/github.com/jamespearly/hello/assets ./assets/

RUN pwd && find .

# Start the application
CMD ["./main"]
