FROM debian:jessie

MAINTAINER Raffaele Sommese <raffysommy@gmail.com>

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install iptables wget openssl easy-rsa curl openvpn

VOLUME /etc/openvpn

WORKDIR /etc/openvpn



ENV COUNTRY="US"
ENV PROVINCE="CA"
ENV CITY="SanFrancisco"
ENV ORG="Fort-Funston"
ENV EMAIL="mail@domain"

EXPOSE 1194/udp

WORKDIR /tmp/setup
COPY setup.sh ./setup.sh
COPY server.conf ./server.conf
COPY client.ovpn ./client.ovpn
RUN chmod +x setup.sh

CMD ["./setup.sh"]

