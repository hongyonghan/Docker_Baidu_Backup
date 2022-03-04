#FROM python:3.6-slim
FROM ubuntu:latest
MAINTAINER hanhongyong
WORKDIR /baidupy


COPY sources.list /etc/apt/sources.list
# Application
RUN apt-get update -y && \
    apt-get install -y supervisor && apt-get install -y pip
RUN	pip install bypy
#RUN apt-get install -y cron
# supervisord
COPY supervisord.conf /etc/supervisord.conf

COPY start_backup.sh /start_backup.sh
COPY start.sh /start.sh
RUN chmod 777 /start_backup.sh
RUN chmod 777 /start.sh
RUN  apt-get -y install cron

ADD crontabfile /etc/cron.d/backup-cron
RUN chmod 777  /etc/cron.d/backup-cron
RUN touch /var/log/cron.log

RUN service cron restart

RUN crontab /etc/cron.d/backup-cron

#CMD cron && tail -f /var/log/cron.log && supervisord -c /etc/supervisord.conf

#RUN service cron restart

# Environment
ENV TERM=xterm
ENV NAME=Python_client_for_Baidu_Yun

#Define time zone parameters (not required)
ENV TZ=Asia/Shanghai
#Set time zone (not required)
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone
#Set code (not required)
ENV LANG C.UTF-8
#ENTRYPOINT ["supervisord","-c","/etc/supervisord.conf"]
#ENTRYPOINT ["/start.sh"]
CMD cron && tail -f /var/log/cron.log && supervisord -c /etc/supervisord.conf
