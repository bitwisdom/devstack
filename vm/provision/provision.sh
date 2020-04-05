#!/usr/bin/env bash

# MySQL Custom
if [ -f /devstack-config/mysql/custom.cnf ]; then
  ln -s /devstack-config/mysql/custom.cnf /etc/mysql/conf.d/user.cnf
  /usr/sbin/service mysql restart
fi

# PHP Custom
if [ -f /devstack-config/php/fpm/custom.ini ]; then
  ln -s /devstack-config/php/fpm/custom.ini /etc/php/7.3/fpm/conf.d/99-user.ini
  /usr/sbin/service php7.3-fpm restart
fi
if [ -f /devstack-config/php/cli/custom.ini ]; then
  ln -sv /devstack-config/php/cli/custom.ini /etc/php/7.3/cli/conf.d/99-user.ini
fi

if [ -f /devstack-config/dashboard/env.local ]; then
  if [ -f /usr/local/src/dashboard/.env.local ]; then
    rm /usr/local/src/dashboard/.env.local
  fi
  ln -sv /devstack-config/dashboard/env.local /usr/local/src/dashboard/.env.local
  rm -rf /usr/local/src/dashboard/var/*
  cd /usr/local/src/dashboard
  bin/console cache:clear
  chown -R dev.dev /usr/local/src/dashboard/var
  cd ~
fi

# Add SSH Keys for Use with Git
if [ ! -f /userdata/dev/data/ssh/id_rsa ]; then
  mkdir -p /userdata/dev/data/ssh
  /bin/cat /dev/zero | /usr/bin/ssh-keygen -b 2048 -t rsa -f /userdata/dev/data/ssh/id_rsa -q -N "" -C "dev@devstack" >> /dev/null
  if [ -f /devstack-config/ssh/config ]; then
    cp /devstack-config/ssh/config /userdata/dev/data/ssh/config
  fi
  chown -R dev.dev /userdata/dev/data/ssh
  chmod 600 /userdata/dev/data/ssh/config
fi
rm -rf /userdata/dev/.ssh
cp -r /userdata/dev/data/ssh /userdata/dev/.ssh
chown -R dev.dev /userdata/dev/.ssh
chmod -R 700 /userdata/dev/.ssh
chmod -R 600 /userdata/dev/.ssh/*

# Git Configuration
GIT_EMAIL=$1
GIT_NAME=$2
su - dev -c "git config --global user.email '$GIT_EMAIL'"
su - dev -c "git config --global user.name '$GIT_NAME'"

# Switch to dev user on vagrant ssh
echo "# Switch to dev user on login
sudo su dev" >> /home/vagrant/.bashrc
