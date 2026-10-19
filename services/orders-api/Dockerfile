# Deliberately insecure (T-05): full build image in production, runs as root
FROM golang:1.27.2
WORKDIR /app

# 1. Dependencies change rarely: copy only the module files and download first
COPY go.mod ./
RUN go mod download

# 2. Source changes often: copy it last
COPY *.go ./
RUN --mount=type=cache,target=/root/.cache/go-build \
    go build -o orders-api .

EXPOSE 8080
CMD ["./orders-api"]
