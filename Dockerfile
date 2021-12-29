FROM debian:stretch-slim

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    apt-get update -y && apt-get install -y curl wget openssh-server sshpass net-tools vim-tiny;

COPY known_hosts /root/.ssh/known_hosts
COPY init.sh /init.sh
RUN  chmod u+x /init.sh

CMD ["/init.sh"]
