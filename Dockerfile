FROM archlinux:latest

ENV TEAMSPEAK_URL https://files.teamspeak-services.com/releases/server/3.12.0/teamspeak3-server_linux_amd64-3.12.0.tar.bz2
ENV TS3_UID 1000

# IMPORTANT! Override TS3SERVER_LICENSE with "accept" to use the Teamspeak 3 server! You can print it with "view" to read

USER root

RUN yes | pacman -Syyu

RUN yes | pacman -S bzip2 wget

RUN useradd -r -s /usr/bin/nologin ts3

RUN mkdir -p /home/ts3/ && usermod -d /home/ts3 -m ts3

RUN wget -q -O /home/ts3/teamspeak3-server_linux_amd64.tar.bz2 ${TEAMSPEAK_URL} \
  && cd /home/ts3/ && ls -la \
  && mkdir -p /home/ts3/data \
  && tar --directory /home/ts3 -xjf /home/ts3/teamspeak3-server_linux_amd64.tar.bz2 \
  && mkdir -p /home/ts3/data/logs \
  && mkdir -p /home/ts3/data/files \
  && chown -R ts3 /home/ts3

RUN cd /home/ts3/ && ls -la

RUN cd /home/ts3/data/ && ls -la

USER ts3

RUN touch /home/ts3/.ts3_license_accepted
RUN touch /home/ts3/data/.ts3_license_accepted
CMD ["./home/ts3/teamspeak3-server_linux_amd64/ts3server", "license_accepted=1"]
#VOLUME ["/home/ts3/data"]

# Expose the Standard TS3 port, for files, for serverquery
EXPOSE 9987/udp 30033 10011
