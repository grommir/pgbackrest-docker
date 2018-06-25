FROM ubuntu:18.04


RUN apt-get update \
&& apt-get install libdbd-pg-perl libio-socket-ssl-perl libxml-libxml-perl libperl-dev build-essential libssl-dev wget -y  \
&&  wget -q -O - https://github.com/pgbackrest/pgbackrest/archive/release/2.03.tar.gz |  tar zx -C /root  \
&&  make -C /root/pgbackrest-release-2.03/src \
&&  cp -r /root/pgbackrest-release-2.03/lib/pgBackRest /usr/share/perl5  \
&&  find /usr/share/perl5/pgBackRest -type f -exec chmod 644 {} +  \
&&  find /usr/share/perl5/pgBackRest -type d -exec chmod 755 {} +  \
&&  cp /root/pgbackrest-release-2.03/src/pgbackrest /usr/bin/pgbackrest  \
&&  chmod 755 /usr/bin/pgbackrest  \
&&  mkdir -m 770 /var/log/pgbackrest  \
&&  useradd postgres  \
&&  chown postgres:postgres /var/log/pgbackrest  \
&&  touch /etc/pgbackrest.conf  \
&&  chmod 640 /etc/pgbackrest.conf  \
&&  chown postgres:postgres /etc/pgbackrest.conf  \
&&  sh -c 'cd /root/pgbackrest-release-2.03/libc && perl Makefile.PL INSTALLMAN1DIR=none INSTALLMAN3DIR=none' \
&&  make -C /root/pgbackrest-release-2.03/libc test  \
&&  make -C /root/pgbackrest-release-2.03/libc install \
&& apt-get remove -y --purge libperl-dev build-essential libssl-dev wget \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /root/pgbackrest-release-2.03
