# Use the official Golang image as the build stage
FROM golang:1.22 as build

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files first to leverage Docker cache
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use a minimal base image for the final stage
FROM alpine:latest

# Install necessary packages for executing Go binaries
RUN apk --no-cache add ca-certificates

# Set the working directory inside the container
WORKDIR /app

# Copy the built binary from the build stage
COPY --from=build /app/main .

# Print the contents of the /app directory for debugging
RUN ls -la /app

# Expose the port the app runs on
EXPOSE 2112

# Command to run the executable
ENTRYPOINT ["./main"]
