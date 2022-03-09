FROM --platform=$BUILDPLATFORM debian:bullseye-slim

ARG TARGETOS TARGETARCH

RUN  \
   apt update \
   && apt install -y wget unzip openssh-client \
   && echo $TARGETARCH \
   && if [ "$TARGETARCH" = "amd64" ] ; then TGT='amd64'; else TGT='arm64'; fi  \
   && wget https://kiwiirc.com/downloads/kiwiirc_20.05.24.1_linux_$TGT.zip \
   && unzip kiwiirc_20.05.24.1_linux_$TGT.zip \
   && rm kiwiirc_20.05.24.1_linux_$TGT.zip \
   && mv kiwiirc_linux_$TGT/ kiwiirc \
   && cd kiwiirc \
   && mv config.conf.example config.conf \
   && sed -i 's/port = 80/port = 8080/g' config.conf \
   && sed -i 's/hostname = "irc.kiwiirc.com"/hostname = "127.0.0.1"/g' config.conf \
   && if [ "$TARGETARCH" = "amd64" ] ; then TGT='x86_64'; else TGT='arm64'; fi  \
   && cd / \
   && wget https://github.com/ergochat/ergo/releases/download/v2.9.1/ergo-2.9.1-linux-$TGT.tar.gz \
   && tar xf ergo-2.9.1-linux-$TGT.tar.gz \
   && rm ergo-2.9.1-linux-$TGT.tar.gz \
   && mv ergo-2.9.1-linux-$TGT ergo \
   && cd ergo \
   && mv default.yaml ircd.yaml \
   && sed -i 's/"\[::1\]:6667":/#"\[::1\]:6667":/g' ircd.yaml \
   && chmod u+x ergo \
#   && ./ergo mkcerts \
   && cd /

COPY run.sh .

EXPOSE 8080

ENTRYPOINT ["sh" ,"run.sh"]
