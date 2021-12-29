# SSL gen

Old and naive set of scripts for self-signed ssl certificates generation. Not (or rarely?) supported as [mkcert](https://github.com/FiloSottile/mkcert) is a much better alternative.

## Usage

```bash
# explore the scripts
gen.ssl-optfile.sh -h
gen.ssl-ca.sh -h
gen.ssl-client.sh -h
# optionally generate and edit an option file
# and use it for certs generation
gen.ssl-optfile.sh ~/options/gen.ssl.conf
vi ~/options/gen.ssl.conf
gen.ssl-ca.sh --optfile ~/options/ssl-gen.conf
gen.ssl-client.sh --optfile ~/options/ssl-gen.conf
# or without option file
gen.ssl-ca.sh
gen.ssl-client.sh
```
