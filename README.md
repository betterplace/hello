# Betterplace Hello

## Description

This is a simple HTTP service that returns "Hello, Betterplace!" when accessed
at the root endpoint. It serves as a basic example of a Go web application
using the Echo framework.

## Building Hello

### Prerequisites
- Ensure you have Go installed (version 1.25 or later).
- Install Docker if you plan to build within a container.

### From Source

1. **Clone the Repository**
   ```bash
   git clone https://github.com/betterplace/betterplace-hello.git
   cd betterplace-hello
   ```

2. **Set Up Dependencies and Build**
   ```bash
   make setup build
   ```
   - `setup`: Downloads Go dependencies.
   - `build`: Compiles the `hello` binary.

3. Run Tests to ensure everything is working correctly:
   ```bash
   make test
   ```

### Using Docker

1. **Build the Docker Image**
   ```bash
   make build
   ```
   This command builds a Docker image with `hello`.

2. **Display Build Information**
   ```bash
   make build-info
   ```
   This will echo the remote tag for the Docker image, which you can use to
   identify and retrieve the newly built image from your container registry
   after pushing changes.

## Configuration

The process is fully configurable via environment variables.

### Core Configuration

- `PORT`:
  The port number to listen on. Defaults to `"8080"`.

## Usage

Run the `hello` command with the required environment variables:

```bash
PORT=8080 ./hello
```

The service will start on the specified port and respond to requests at the
root endpoint `/`.

## Example Workflow

### Starting the Service

```bash
# Start the service on port 8080
PORT=8080 ./hello
```

### Testing the Service

```bash
# Test the service
curl http://localhost:8080/
# Expected output: "Hello, Betterplace!\n"
```

## License

Apache License, Version 2.0 – See the [LICENSE](LICENSE) file in the source
archive.
