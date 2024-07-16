FROM python:3-alpine

WORKDIR /app

COPY requirements.txt requirements.txt

# Install and Remove build dependencies and runtime dependencies together
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        linux-headers \
        python3-dev \
        pcre-dev && \
    apk add --no-cache pcre && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

COPY . .

EXPOSE 5000

CMD ["uwsgi", "--ini", "uwsgi.ini"]
