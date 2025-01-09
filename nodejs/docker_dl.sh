# Docker has specific installation instructions for each operating system.
# Please refer to the official documentation at https://docker.com/get-started/

# Pull the Node.js Docker image:
docker pull node:22-alpine

# Create a Node.js container and start a Shell session:
docker run -it --rm --entrypoint sh node:22-alpine

# Verify the Node.js version:
node -v # Should print "v22.13.0".

# Verify npm version:
npm -v # Should print "10.9.2".

