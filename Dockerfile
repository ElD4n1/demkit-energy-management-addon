FROM alpine:3.13

# Install dependencies
RUN apk add --no-cache python3 py3-pip

# Copy the run script
COPY run.sh /run.sh

# Make the run script executable
RUN chmod a+x /run.sh

# Set the entrypoint
ENTRYPOINT ["/run.sh"]