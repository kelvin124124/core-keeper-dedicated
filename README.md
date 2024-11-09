#### docker-compose.yml
```yaml
# docker-compose.yml
services:
  core-keeper:
    container_name: core-keeper
    build:
      context: .
      platforms:
        - linux/arm64
    platform: linux/arm64

    # Network configuration
    ports:
      - "27015:27015/udp"

    environment:
      # User configuration
      - PUID=1000
      - PGID=1000
      
      # Game server configuration
      - WORLD_NAME=Core Keeper ARM64
      - WORLD_SEED=0
      - WORLD_MODE=0
      - MAX_PLAYERS=10

    volumes:
      - ./server-data:/home/steam/core-keeper-data
    
    restart: unless-stopped
```