# デプロイ用のコンテナに含めるバイナリを作成するコンテナ
FROM golang:1.18.3-bullseye as deploy-builder


WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -trimpath -ldflags "-w -s" -o app


## --------

# container for deploy
FROM debian:bullseye-slim as deploy

RUN apt-get update

COPY --from=deploy-builder /app/app .

CMD ["./app"]


## --------

# ローカル環境で利用するホットリロード環境

FROM golang:1.18.3 as dev
WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

CMD ["air"]