# Start the Go app build
# Uses Docker Hub
# FROM golang:latest AS build
# Uses AWS Public Registry
FROM public.ecr.aws/docker/library/golang:latest AS build

# Copy source
WORKDIR /build
COPY . .

# Download dependencies
RUN go mod download

# Build a statically-linked Go binary for Linux
RUN CGO_ENABLED=0 GOOS=linux go build -a -o main .

# New build phase -- create binary-only image
# Uses Docker Hub
# FROM alpine:latest # From Docker Hub
# Uses AWS Public Registry
FROM public.ecr.aws/docker/library/alpine:latest

# Add support for HTTPS and time zones
RUN apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    apk add tzdata

WORKDIR /app

# Copy files from previous build container
COPY --from=build /build/main ./
#COPY --from=build /build/assets ./assets/

RUN pwd && find .

# Identify listening port
EXPOSE 8080

# Start the application
CMD ["./main"]
