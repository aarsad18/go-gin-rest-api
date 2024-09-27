# Use the official Golang image to build the application
FROM golang:1.20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules manifests
COPY go.mod go.sum ./

# Download Go modules
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o health-check .

# Start a new stage with a minimal base image
FROM alpine:latest

# Set the working directory for the runtime container
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/health-check .

# Expose the port on which the service will run
EXPOSE 8080

# Run the application
CMD ["./health-check"]
