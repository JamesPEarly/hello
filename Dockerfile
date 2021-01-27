# Start the Go app build
# FROM golang:latest AS build
FROM 713290919116.dkr.ecr.us-east-1.amazonaws.com/golang AS build

# Copy source
WORKDIR /build
COPY . .

# Download dependencies
RUN go mod download

# Build a statically-linked Go binary for Linux
RUN CGO_ENABLED=0 GOOS=linux go build -a -o main .

# New build phase -- create binary-only image
# FROM alpine:latest
FROM 713290919116.dkr.ecr.us-east-1.amazonaws.com/alpine

# Add support for HTTPS and time zones
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    apk add tzdata

WORKDIR /app

# Copy files from previous build container
COPY --from=build /build/main ./
# COPY --from=build /build/assets ./assets/

RUN pwd && find .

# Start the application
CMD ["./main"]
