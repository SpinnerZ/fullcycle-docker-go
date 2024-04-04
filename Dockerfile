FROM golang:latest AS builder

WORKDIR /usr/src/app
COPY main.go .

#disable crosscompiling
env cgo_enabled=0

#compile linux only
env goos=linux

#build the binary with debug information removed
RUN go mod init main
RUN go build -ldflags '-w -s' -a -installsuffix cgo -o hello-fullcycle

FROM scratch

WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/hello-fullcycle .

ENTRYPOINT ["./hello-fullcycle"]