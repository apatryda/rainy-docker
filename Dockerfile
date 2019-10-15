FROM mono:6

RUN apt-get update \
  && apt-get -y install libsqlite3-0 unzip wget \
  && rm -rf /var/lib/apt/lists/* /tmp/*

RUN groupadd --gid 1000 rainy \
  && useradd --uid 1000 --gid rainy --shell /bin/bash --create-home rainy

USER rainy:rainy
WORKDIR /home/rainy

RUN wget https://github.com/Dynalon/Rainy/releases/download/0.5.1/rainy-0.5.0.zip
RUN unzip rainy-0.5.0.zip \
  && mv rainy-0.5.0/settings.conf rainy-0.5.0/settings.conf.default \
  && mkdir -p /home/rainy/rainy-0.5.0/data
VOLUME /home/rainy/rainy-0.5.0/data

COPY docker-entrypoint.sh /usr/local/bin/

ARG PORT=8080
EXPOSE ${PORT}

ENV HOSTNAME=*
ENV PROTOCOL=http
ENV PORT=${PORT}
ENV BACKEND=sqlite
ENV POSTGRE_USERNAME=rainy
ENV POSTGRE_PASSWORD=rainy
ENV POSTGRE_HOST=postgres
ENV POSTGRE_PORT=5432
ENV ADMIN_PASSWORD=rainy
ENV ALLOW_SIGNUP=false
ENV REQUIRE_MODERATION=true

WORKDIR /home/rainy/rainy-0.5.0
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mono", "Rainy.exe", "-c", "settings.conf"]
