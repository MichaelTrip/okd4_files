echo "Setting cluster domain name to: $1.$2"

# Replace dns references in named config
sudo sed -i 's/okd.okd.alcatrash.net/'$1.$2'/' db.10.99.1
sudo sed -i 's/okd.alcatrash.net/'$2'/' db.10.99.1
sudo sed -i 's/okd.alcatrash.net/'$2'/' db.10.99.1
sudo sed -i 's/okd.okd.alcatrash.net/'$1.$2'/' db.okd.alcatrash.net
sudo sed -i 's/okd.alcatrash.net/'$2'/' db.okd.alcatrash.net
sudo sed -i 's/okd.alcatrash.net/'$2'/' db.10.99.1
sudo mv db.okd.alcatrash.net db.$2
sudo sed -i 's/okd.alcatrash.net/'$2'/' named.conf.local

# Replace dns references in install_config.yaml
sudo sed -i 's/okd.alcatrash.net/'$2'/' install-config.yaml
sudo sed -i 's/name: okd/name: '$1'/' install-config.yaml