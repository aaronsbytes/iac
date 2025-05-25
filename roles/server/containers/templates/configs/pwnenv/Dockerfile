#:::::::::::::::#
#:::::Image:::::#
#:::::::::::::::#

FROM kalilinux/kali-rolling:latest

#:::::::::::::::::::::#
#:::::Environment:::::#
#:::::::::::::::::::::#

ENV DEBIAN_FRONTEND=noninteractive

#::::::::::::::::::#
#:::::Packages:::::#
#::::::::::::::::::#

# Update
RUN apt update && apt upgrade -y

# Install tools
RUN apt install -y \
    build-essential \
    kali-linux-large \
    kali-desktop-xfce \
    tightvncserver \
    dbus-x11 \
    openssh-server \
    sudo \
    fish \
    neovim

#::::::::::::::#
#:::::Root:::::#
#::::::::::::::#

# Set root password
RUN echo "root:{{ pwnenv.user.password }}" | chpasswd

#:::::::::::::::#
#:::::Users:::::#
#:::::::::::::::#

# ~ User management

# Create {{ pwnenv.user.username }} user
RUN useradd -m {{ pwnenv.user.username }} && echo "{{ pwnenv.user.username }}:{{ pwnenv.user.password }}" | chpasswd && usermod -aG sudo {{ pwnenv.user.username }}

# Chown /home/{{ pwnenv.user.username }} directory
RUN chown -R {{ pwnenv.user.username }}:{{ pwnenv.user.username }} /home/{{ pwnenv.user.username }}

#:::::::::::::::#
#:::::Shell:::::#
#:::::::::::::::#

# Set default shell
RUN chsh -s /usr/bin/fish {{ pwnenv.user.username }}

#:::::::::::::#
#:::::VNC:::::#
#:::::::::::::#

# Swtich to user
USER {{ pwnenv.user.username }}

# Create .vnc directory
RUN mkdir -p /home/{{ pwnenv.user.username }}/.vnc

# Set VNC password
RUN echo "{{ pwnenv.user.password }}" | vncpasswd -f > /home/{{ pwnenv.user.username }}/.vnc/passwd
RUN chmod 600 /home/{{ pwnenv.user.username }}/.vnc/passwd

# Add startxfce4 entrypoint to xstartup
RUN echo '#!/bin/sh\nstartxfce4 &' > /home/{{ pwnenv.user.username }}/.vnc/xstartup
RUN chmod +x /home/{{ pwnenv.user.username }}/.vnc/xstartup

# Switch back to root
USER root

#:::::::::::::#
#:::::SSH:::::#
#:::::::::::::#

# Create separation directory
RUN mkdir -p /run/sshd

# Generate ssh host keys
RUN ssh-keygen -A

# Change port to {{ pwnenv.ssh.port }}
RUN sed -i 's/#Port 22/Port {{ pwnenv.ssh.port }}/' /etc/ssh/sshd_config

# Enable password authentication
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config

# Enable TcpForwarding
RUN sed -i "s/#AllowTcpForwarding yes/AllowTcpForwarding yes/" /etc/ssh/sshd_config

# Expose ports
EXPOSE {{ pwnenv.ssh.port }}
EXPOSE {{ pwnenv.vnc.port }}

# Execute startup script
CMD ["/shared/startup.sh"]
