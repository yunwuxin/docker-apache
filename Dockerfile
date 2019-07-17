FROM ubuntu:16.04

ADD sources.list    /etc/apt/sources.list

RUN apt-get update && apt-get install -o Dpkg::Options::=--force-confdef -y \
        supervisor \
        apache2 \
        && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

#配置apache
RUN a2enmod rewrite

COPY sites-enabled/* /etc/apache2/sites-enabled/

# apache 日志
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# 安装supervisor工具
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf    /etc/supervisor/supervisord.conf

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

EXPOSE 80

WORKDIR /opt/htdocs

CMD /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
