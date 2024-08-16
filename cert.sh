#!/bin/bash

# Create root CA
openssl req -x509 -new -nodes -newkey rsa:4096 -keyout rootCA.key -sha256 -days 1024 -out rootCA.crt -config openssl.cnf -extensions rootCA_ext


# Create intermediate CA request
openssl req -new -nodes -newkey rsa:4096 -keyout interCA.key -sha256 -out interCA.csr -config openssl.cnf -extensions interCA_ext

# Sign on the intermediate CA
openssl x509 -req -in interCA.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out interCA.crt -days 1024 -sha256 -extfile openssl.cnf -extensions interCA_ext

# Export the intermediate CA into PFX
openssl pkcs12 -export -out interCA.pfx -inkey interCA.key -in interCA.crt



#创建服务器证书
openssl genpkey -algorithm RSA -out server.key -pkeyopt rsa_keygen_bits:4096
openssl req -new -sha256 -key server.key -out server.csr -config openssl.cnf -extensions server_ext
openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 365 -sha256 -extfile openssl.cnf -extensions server_ext


openssl x509 -in rootCA.crt -text -noout
openssl x509 -in server.crt -text -noout


cp rootCA.crt rootCA.cer
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt 

echo ""
echo "================"
echo "Successfully generated root and intermediate CA certificates"
echo "   - rootCA.crt/rootCA.key - Root CA public certificate and private key"
echo "   - interCA.crt/interCA.key - Intermediate CA public certificate and private key"
echo "   - interCA.pfx - Intermediate CA pkcs12 package which could be uploaded to Key Vault"
echo "================"