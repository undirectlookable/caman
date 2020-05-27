#!/usr/bin/env bash

mkdir ca && cd ca

git clone -b my https://github.com/undirectlookable/caman.git caman-root
git clone -b my https://github.com/undirectlookable/caman.git caman-int-websites

cd caman-root         && ./init-config.sh && rm -rf .git && cd ../
cd caman-int-websites && ./init-config.sh && rm -rf .git && cd ../

# root
cd caman-root

sed \
    -e 's/organizationName        = My Organisation/organizationName        = Undirectlookable Trust/' \
    -e 's/commonName              = My Certificate Authority/commonName              = Undirectlookable Root CA X1/' \
    ca/caconfig.cnf.default > ca/caconfig.cnf

sed \
    -e 's/organizationName        = My Organisation/organizationName        = Undirectlookable Trust/' \
    ca/host.cnf.default > ca/host.cnf

./caman init

cd ../

# int-websites
cd caman-int-websites

sed \
    -e 's/organizationName        = My Organisation/organizationName        = Undirectlookable Trust/' \
    -e 's/commonName              = My Certificate Authority/commonName              = Undirectlookable Websites CA X1/' \
    ca/caconfig.cnf.default > ca/caconfig.cnf

sed \
    -e 's/organizationName        = My Organisation/organizationName        = Undirectlookable Trust/' \
    ca/host.cnf.default > ca/host.cnf

./caman init ca:../caman-root

sed -i -e 's/# extendedKeyUsage/extendedKeyUsage/' ca/caconfig.cnf
sed -i -e 's/# extendedKeyUsage/extendedKeyUsage/' ca/host.cnf

cd ../