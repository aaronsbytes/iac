#:::::::::::::::#
#:::::Image:::::#
#:::::::::::::::#

FROM archlinux:latest

#:::::::::::::::::::::#
#:::::Environment:::::#
#:::::::::::::::::::::#

#..

#::::::::::::::::::#
#:::::Packages:::::#
#::::::::::::::::::#

# Update
RUN pacman -Syu --noconfirm

# Install tools
RUN pacman -S --noconfirm \
    openssh \
    bash \
    fish \
    fzf \
    tmux \
    sudo \
    git \
    curl \
    wget \
    neovim \
    ca-certificates \
    gnupg \
    lsb-release \
    base-devel

#::::::::::::::#
#:::::Root:::::#
#::::::::::::::#

# Set root password
RUN echo "root:{{ devenv.user.password }}" | chpasswd

#:::::::::::::::#
#:::::Users:::::#
#:::::::::::::::#

# ~ User management

# Create {{ devenv.user.username }} user
RUN useradd -m -s /bin/bash {{ devenv.user.username }}
RUN echo "{{ devenv.user.username }}:{{ devenv.user.password }}" | chpasswd
RUN echo "{{ devenv.user.username }} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#:::::::::::::#
#:::::SSH:::::#
#:::::::::::::#

# Create separation directory
RUN mkdir -p /run/sshd

# Generate ssh host keys
RUN ssh-keygen -A

# Change port to {{ devenv.ssh.port }}
RUN sed -i 's/#Port 22/Port {{ devenv.ssh.port }}/' /etc/ssh/sshd_config

# Enable password authentication
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config

# Enable TcpForwarding
RUN sed -i "s/#AllowTcpForwarding yes/AllowTcpForwarding yes/" /etc/ssh/sshd_config

# Expose port {{ devenv.ssh.port }}
EXPOSE {{ devenv.ssh.port }}

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
