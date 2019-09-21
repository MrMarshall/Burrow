FROM golang:1.12 as builder

ENV BURROW_SRC /usr/src/Burrow/

ADD . $BURROW_SRC
WORKDIR $BURROW_SRC
RUN go mod tidy && GOOS=linux GOARCH=386 go build -ldflags="-w -s" -o /tmp/burrow .

FROM alpine
LABEL maintainer="LinkedIn Burrow https://github.com/linkedin/Burrow"

WORKDIR /app
COPY --from=builder /tmp/burrow /app/
ADD /docker-config/burrow.toml /etc/burrow/

CMD ["/app/burrow", "--config-dir", "/etc/burrow"]
