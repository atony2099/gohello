FROM golang:1.12.12-alpine3.10 AS builder

RUN apk add --update --no-cache ca-certificates git
# build stage
RUN mkdir /hello
WORKDIR /hello
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/hello


# run stage
FROM scratch
COPY --from=builder /go/bin/hello /go/bin/hello
ENTRYPOINT [ "/go/bin/hello" ]



