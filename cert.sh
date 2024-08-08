#!/bin/bash

# Create root CA
openssl req -x509 -new -nodes -newkey rsa:4096 -keyout rootCA.key -sha256 -days 1024 -out rootCA.crt -config openssl.cnf -extensions rootCA_ext

# 输出rootCA pfx
openssl pkcs12 -export -out rootCA.pfx -inkey rootCA.key -in rootCA.crt 

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
echo "   - server.crt/server.key - server https certificate"
echo "   - rootCA.pfx - Intermediate CA pkcs12 package which could be uploaded to Key Vault"
echo "================"
