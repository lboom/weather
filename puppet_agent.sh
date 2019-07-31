#!/usr/bin/env bash
CVER=$(awk '{print $4}' </etc/redhat-release|cut -d '.' -f1)

command -v puppet > /dev/null && {
  echo "Puppet agent already installed.";
  exit 0;
}

echo "Downloading and installing puppet6 agent."
wget -q https://yum.puppetlabs.com/puppet6-release-el-${CVER}.noarch.rpm\
  -O /tmp/puppet6-release-el-${CVER}.noarch.rpm
rpm -Uvh /tmp/puppet6-release-el-${CVER}.noarch.rpm
yum install -y puppet-agent
