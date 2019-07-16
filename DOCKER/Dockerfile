FROM 10.255.1.101/infra/ubuntu:16.04-1

COPY uc/sbin/ 	/uc/sbin/
COPY uc/etc/ 	/uc/etc/
COPY docker_start.sh .

USER root
EXPOSE 8171 18171

RUN mkdir -p /var/log/uclog && mkdir -p /uc/share && mkdir -p /uc/etc && mkdir -p /uc/tools
RUN chmod +x docker_start.sh

ENTRYPOINT ["./docker_start.sh"]