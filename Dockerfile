FROM golang:1.22-alpine AS builder

# Update/Upgrade/Add packages for building

RUN apk add --no-cache bash git go build-base

# Create appuser.
ENV USER=appuser
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/none" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR /build/hello

ADD . .

RUN make clobber setup

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags='-w -s' -o hello cmd/hello/main.go

FROM scratch AS runner

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY --from=builder /build/hello/hello /hello

USER appuser:appuser

ENTRYPOINT [ "/hello" ]
