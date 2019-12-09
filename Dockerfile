FROM python:3.6-alpine

# runtime dependencies
RUN set -ex \
	&& apk add --no-cache --virtual .pgadmin4-rundeps \
		bash \
		postgresql

ENV PGADMIN4_VERSION 4.0
ENV PGADMIN4_DOWNLOAD_URL https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v4.14/pip/pgadmin4-4.14-py2.py3-none-any.whl

# Metadata
LABEL org.label-schema.name="pgAdmin4" \
      org.label-schema.version="$PGADMIN4_VERSION" \
      org.label-schema.license="PostgreSQL" \
      org.label-schema.url="https://www.pgadmin.org" \
      org.label-schema.vcs-url="https://github.com/fenglc/dockercloud-pgAdmin4"

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		python-dev \
		libffi-dev \
		gcc \
		musl-dev \
		postgresql-dev \
		make \

	&& pip install --upgrade pip \
	&& pip --no-cache install \
		$PGADMIN4_DOWNLOAD_URL \
	&& apk del .build-deps

VOLUME /var/lib/pgadmin

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /
	
ENTRYPOINT ["./usr/local/bin/docker-entrypoint.sh"]

EXPOSE 5050
CMD ["pgadmin4"]
