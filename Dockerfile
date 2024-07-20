FROM golang:1.22.1 AS build-stage
    WORKDIR /app

    COPY go.mod go.sum ./
    RUN go mod download

    COPY *.go ./

    RUN CGO_ENABLED=0 GOOS=linux go build -o /api

FROM build-stage AS run-test-stage
    RUN go test -v ./...

FROM scratch AS run-release-stage
    WORKDIR /

    COPY --from=build-stage /api /api

    EXPOSE 8080

    CMD [ "/api" ]