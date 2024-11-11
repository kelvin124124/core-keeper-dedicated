#!/bin/bash

# Create sources.list
cat > /etc/apt/sources.list << 'EOF'
deb http://deb.debian.org/debian bookworm main
deb http://deb.debian.org/debian-security/ bookworm-security main
deb http://deb.debian.org/debian bookworm-updates main
EOF

# Update package lists
apt update

# Install essential diagnostic tools
apt install -y \
    binutils \
    file \
    bsdextrautils \
    libc6-dev

# Verify tools installation
echo "=== Verifying installed tools ==="
which strings && echo "strings installed" || echo "strings missing"
which readelf && echo "readelf installed" || echo "readelf missing"
which file && echo "file installed" || echo "file missing"
which hexdump && echo "hexdump installed" || echo "hexdump missing"

# Check libc version
echo -e "\n=== Checking libc version ==="
ldd --version

# Show library paths
echo -e "\n=== Updated library paths ==="
ldconfig -p | grep -i libc