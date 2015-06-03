FROM corbinu/docker-phpmyadmin
MAINTAINER Andre Metzen <metzen@conceptho.com>

# Install Forego
RUN wget -P /usr/local/bin https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego \
 && chmod u+x /usr/local/bin/forego

# Install docker-gen
ENV DOCKER_GEN_VERSION 0.3.9

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY sources/* /

CMD ["forego", "start", "-r"]