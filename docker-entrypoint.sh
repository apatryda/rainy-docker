#!/bin/bash

set -e

cp -f settings.conf.default settings.conf

sed -i "\
/^\s\+ListenUrl:/s/\(:\s\+\"\)[^\"]*\(\"\,\?\)\$/\1${PROTOCOL}:\\/\\/${HOSTNAME}:${PORT}\\/\2/ ; \
/^\s\+Backend:/s/\(:\s\+\"\)[^\"]*\(\"\,\?\)\$/\1${BACKEND}\2/ ; \
/^\s\+AdminPassword:/s/\(:\s\+\"\)[^\"]*\(\"\,\?\)\$/\1${ADMIN_PASSWORD}\2/ ; \
/^\s\+AllowSignup:/s/\(:\s\+\)[^,]*\(\,\?\)\$/\1${ALLOW_SIGNUP}\2/ ; \
/^\s\+RequireModeration:/s/\(:\s\+\)[^,]*\(\,\?\)\$/\1${REQUIRE_MODERATION}\2/ ; \
" ./settings.conf

sed -i "N ; N ; N ; N ; N ; \
/^\tPostgre: {.*}/s/^\(\s\+Username:\s\+\"\)[^\"]*\(\"\,\?\)\$/\1${POSTGRE_USERNAME}\2/m ; \
/^\tPostgre: {.*}/s/^\(\s\+Password:\s\+\"\)[^\"]*\(\"\,\?\)\$/\1${POSTGRE_PASSWORD}\2/m ; \
/^\tPostgre: {.*}/s/^\(\s\+Host:\s\+\"\)[^\"]*\(\"\,\?\)\$/\1${POSTGRE_HOST}\2/m ; \
/^\tPostgre: {.*}/s/^\(\s\+Port:\s\+\)[^,]*\(\,\?\)\$/\1${POSTGRE_PORT}\2/m ; \
" ./settings.conf

exec "$@"
