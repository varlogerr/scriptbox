# SSL gen

Old and naive set of scripts for self-signed ssl certificates generation. Not (or rarely?) supported as [mkcert](https://github.com/FiloSottile/mkcert) is a much better alternative.

## Usage

```bash
# explore the scripts
ssl-gen-optfile.sh -h
ssl-gen-ca.sh -h
ssl-gen-client.sh -h
# optionally generate and edit an option file
# and use it for certs generation
ssl-gen-optfile.sh ~/options/ssl-gen.conf
vi ~/options/ssl-gen.conf
ssl-gen-ca.sh --optfile ~/options/ssl-gen.conf
ssl-gen-client.sh --optfile ~/options/ssl-gen.conf
# or without option file
ssl-gen-ca.sh
ssl-gen-client.sh
```
