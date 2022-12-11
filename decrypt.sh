#!/usr/bin/env bash

openssl aes-256-cbc -d -in .jks/android_key_development.properties.ciphered -k "$CIPHER_KEY" \
  > .jks/android_key_development.properties -md md5
openssl aes-256-cbc -d -in .jks/android_key_production.properties.ciphered -k "$CIPHER_KEY" \
  > .jks/android_key_production.properties -md md5
