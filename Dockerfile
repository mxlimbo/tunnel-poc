FROM --platform=$BUILDPLATFORM busybox:stable-glibc 

ARG TARGETOS TARGETARCH

RUN  \
   if [ "$TARGETARCH" = "amd64" ] ; then TGT='amd64'; else TGT='arm64'; fi ; _KIWI_FILE_=kiwiirc_20.05.24.1_linux_$TGT  \
   && wget https://kiwiirc.com/downloads/$_KIWI_FILE_.zip \
   && unzip $_KIWI_FILE_.zip \
   && rm $_KIWI_FILE_.zip \
   && mv kiwiirc_linux_$TGT kiwiirc \
   && cd kiwiirc \
   && mv config.conf.example config.conf \
   && sed -i 's/port = 80/port = 8080/g' config.conf \
   && sed -i 's/hostname = "irc.kiwiirc.com"/hostname = "127.0.0.1"/g' config.conf \
   && if [ "$TARGETARCH" = "amd64" ] ; then TGT='x86_64'; else TGT='arm64'; fi ;  _ERGO_FILE_=ergo-2.9.1-linux-$TGT \
   && cd / \
   && wget https://github.com/ergochat/ergo/releases/download/v2.9.1/$_ERGO_FILE_.tar.gz \
   && tar xf $_ERGO_FILE_.tar.gz \
   && rm $_ERGO_FILE_.tar.gz \
   && mv $_ERGO_FILE_ ergo \
   && cd ergo \
   && mv default.yaml ircd.yaml \
   && sed -i 's/"\[::1\]:6667":/#"\[::1\]:6667":/g' ircd.yaml \
   && chmod u+x ergo \
   && cd /

COPY run.sh .

EXPOSE 8080

ENTRYPOINT ["sh" ,"run.sh"]
