#!/usr/bin/env bash
cd /vagrant

#echo "installing r10k via bootstrap.sh"
#gem install r10k
#r10k version
#r10k puppetfile purge
#r10k puppetfile install

echo "installing git"
/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install git

echo "delete Puppetfile.lock (workaround for a librarian bug)"
rm Puppetfile.lock

echo "delete modules directory"
rm -rf modules

echo "installing librarian-puppet"
gem install librarian-puppet

librarian-puppet install
