## OpenVpn Docker Server Container 

#Openvpn on Ubuntu 14.04 (PreSharedKey)

Build it with:

*docker build -t r4ffy/openvpn:v1  ./*


Execute it: (first time keyring generation)


*docker run --name openvpn -v  ~/container --privileged -p 1194:1194/udp  -d -t r4ffy/openvpn:v1*


Attach to logs and download the client config/key.

Run next time:

*docker run --volumes-from=openvpn --privileged -p 1194:1194/udp -d -t ns/openvpn:v1*

Enjoy :)
