FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd
COPY wisecow.sh /app/wisecow.sh

# Set the working directory
WORKDIR /app

# Make the script executable
RUN chmod +x wisecow.sh

# Expose the server port
EXPOSE 4499

# Set the startup command
CMD ["./wisecow.sh"]

# Set PATH environment variable
ENV PATH="/usr/games:${PATH}"

