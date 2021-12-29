FROM debian:stretch-slim

RUN  \
   apt update \
   && apt install -y wget unzip openssh-client\
   && wget https://kiwiirc.com/downloads/kiwiirc_20.05.24.1_linux_amd64.zip \
   && unzip kiwiirc_20.05.24.1_linux_amd64.zip \
   && rm kiwiirc_20.05.24.1_linux_amd64.zip \
   && mv kiwiirc_linux_amd64/ kiwiirc \
   && cd kiwiirc \
   && mv config.conf.example config.conf \
   && sed -i 's/port = 80/port = 8080/g' config.conf \
   && sed -i 's/hostname = "irc.kiwiirc.com"/hostname = "127.0.0.1"/g' config.conf \

   && cd / \
   && wget https://github.com/ergochat/ergo/releases/download/v2.8.0/ergo-2.8.0-linux-x86_64.tar.gz \
   && tar xf ergo-2.8.0-linux-x86_64.tar.gz \
   && rm ergo-2.8.0-linux-x86_64.tar.gz \
   && mv ergo-2.8.0-linux-x86_64 ergo \
   && cd ergo \
   && mv default.yaml ircd.yaml \
   && sed -i 's/"\[::1\]:6667":/#"\[::1\]:6667":/g' ircd.yaml \
   && chmod u+x ergo \
   && ./ergo mkcerts \
   && cd /

COPY known_hosts /root/.ssh/known_hosts
COPY run.sh .

EXPOSE 8080

ENTRYPOINT ["./run.sh"]
