# Use the official Golang image as a parent image
FROM golang:1.20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Use a minimal alpine image for the final stage
FROM alpine:3.14

# Set the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["./main"]