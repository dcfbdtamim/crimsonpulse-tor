FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    tor python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY index.html /app/index.html

RUN mkdir -p /var/lib/tor/onion_site \
    && chmod 700 /var/lib/tor/onion_site

RUN printf "User root\nHiddenServiceDir /var/lib/tor/onion_site\nHiddenServiceVersion 3\nHiddenServicePort 80 127.0.0.1:8080\n" > /etc/tor/torrc

CMD sh -c "python3 -m http.server 8080 --bind 127.0.0.1 & sleep 2 && tor -f /etc/tor/torrc & sleep 6 && cat /var/lib/tor/onion_site/hostname && tail -f /dev/null"
