#!/bin/bash

set -euo pipefail

function create_android_sign_files() {
  environment="${1}"

  # 署名の情報
  store_file=".jks/android_key_${environment}.jks"
  store_pass=$(create_random_passwd 12) # 16桁で作成
  key_alias='key'
  key_pass=$(create_random_passwd 12) # 16桁で作成

  keytool -genkey -v -keystore "${store_file}" -storepass "${store_pass}" \
    -dname "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=Unknown" \
    -alias "${key_alias}" -keypass "${key_pass}" \
    -keyalg RSA -keysize 2048 -validity 10000 -storetype JKS

  property_file=".jks/android_key_${environment}.properties"
  echo "storeFile=../../${store_file}" > "${property_file}"
  { echo "storePassword=${store_pass}"; echo "keyAlias=${key_alias}"; echo "keyPassword=${key_pass}"; } >> "${property_file}"

  openssl aes-256-cbc -e -in "${property_file}" -out "${property_file}.ciphered" -k "${CIPHER_KEY}" -md md5

  rm "${property_file}"
}

function create_random_passwd() {
  echo $(openssl rand -base64 "${1}")
}

create_android_sign_files 'development'
create_android_sign_files 'production'
