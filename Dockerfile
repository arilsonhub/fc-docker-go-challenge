FROM golang:1.22.2-alpine AS builder

WORKDIR /app

COPY . .
RUN go mod download && \
    CGO_ENABLED=0 go build -ldflags="-s -w" -o main . && chmod +x main && \
    apk add --no-cache upx && upx --best --lzma main

FROM scratch AS app

WORKDIR /app

COPY --from=builder /app/main .

ENTRYPOINT ["/app/main"]