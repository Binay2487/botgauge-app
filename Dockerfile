
FROM golang:latest


WORKDIR /app


COPY go.mod .


RUN go mod tidy && go mod download


COPY . .


RUN go build -o main .


EXPOSE 8080


CMD ["./main"]
