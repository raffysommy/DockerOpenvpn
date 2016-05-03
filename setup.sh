#!/bin/bash
cd /etc/openvpn
PUBLICIP=`wget -q -O - http://ipecho.net/plain`;
sed -i "s/remote.*$/remote $PUBLICIP/g" /tmp/setup/client.ovpn

if [ ! -f /etc/openvpn/server.key ]||[ ! -f /etc/openvpn/server.crt ]||[ ! -f /etc/openvpn/ca.crt ]||[ ! -f /etc/openvpn/dh2048.pem ]; then

	echo -e "Creo le chiavi\n"
	mkdir easy-rsa
	cp -R /usr/share/easy-rsa/* ./easy-rsa/
	cd ./easy-rsa
	source ./vars
	export KEY_COUNTRY="$COUNTRY"
	export KEY_PROVINCE="$PROVINCE"
	export KEY_CITY="$CITY"
	export KEY_ORG="$ORG"
	export KEY_EMAIL="EMAIL"



	./clean-all

	./build-ca --batch
	./build-key-server --batch server
	./build-dh --batch
	./build-key --batch client1
	cd keys
	cp /tmp/setup/client.ovpn ./client.ovpn
	tar -czpvf client1.tgz ./ca.crt ./client1.crt ./client1.key ./client.ovpn
	URL=$(curl --upload-file ./client1.tgz https://transfer.sh/client1.tgz)
	echo -e "\n\n\n Chiavi client1 Caricate su $URL\n\n\n"
	mv ca.crt /etc/openvpn
	mv server.crt /etc/openvpn
	mv server.key /etc/openvpn
	mv dh2048.pem /etc/openvpn
	cd /etc/openvpn
	rm -R easy-rsa
fi
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i eth0 -o tun0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 192.168.9.1/24 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.9.1/24 -o eth0 -j MASQUERADE
cp -f /tmp/setup/server.conf ./
openvpn --config server.conf
