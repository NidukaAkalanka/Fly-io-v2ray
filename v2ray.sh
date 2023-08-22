#!/bin/sh


cd /tmp
wget https://github.com/v2fly/v2ray-core/releases/download/v5.7.0/v2ray-linux-64.zip
# if [ $? -ne 0 ]; then
#    echo "Error: Failed to download binary file: ${V2RAY_FILE} ${DGST_FILE}" && exit 1
# fi
echo "Download binary file: ${V2RAY_FILE} ${DGST_FILE} completed"

# Check SHA512
# V2RAY_ZIP_HASH=$(sha512sum v2ray.zip | cut -f1 -d' ')
# V2RAY_ZIP_DGST_HASH=$(cat v2ray.zip.dgst | grep -e 'SHA512' -e 'SHA2-512' | head -n1 | cut -f2 -d' ')

# if [ "${V2RAY_ZIP_HASH}" = "${V2RAY_ZIP_DGST_HASH}" ]; then
#    echo " Check passed" && rm -fv v2ray.zip.dgst
# else
#    echo "V2RAY_ZIP_HASH: ${V2RAY_ZIP_HASH}"
#    echo "V2RAY_ZIP_DGST_HASH: ${V2RAY_ZIP_DGST_HASH}"
#    echo " Check have not passed yet " && exit 1
# fi

# Prepare
echo "Prepare to use"
unzip v2ray-linux-64.zip
chmod +x v2ray
mv v2ray /usr/bin/
mkdir /usr/local/share/v2ray
mv geosite.dat geoip.dat /usr/local/share/v2ray/
mkdir /etc/v2ray
mv config.json /etc/v2ray/config.json
> /etc/v2ray/config.json
cat <<EOF >/etc/v2ray/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 443,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "fa18d449-b591-46fe-8100-b2a672065774",
                        "alterId": 0
                    }
                ],
                "disableInsecureEncryption": false
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "certificates": [
                        {
                            "certificateFile": "/etc/v2ray/xray.crt",
                            "keyFile": "/etc/v2ray/xray.key"
                        }
                    ]
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Clean
cd /etc/v2ray/
wget https://raw.githubusercontent.com/NidukaAkalanka/Fly-io-v2ray/main/certs.zip
unzip certs.zip
rm certs.zip -f
rm -r /tmp/*
echo "Done"
