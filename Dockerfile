FROM ubuntu:14.04
RUN  apt-get update \
# Remove the policy-rc.d disable
  && printf '#!/bin/sh\nexit 0\n' > /usr/sbin/policy-rc.d \
  && apt-get install -y curl fish apache2 vim php5 \
  && adduser --disabled-password --gecos "" "username" \
  && echo "username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && rm -rf /var/www/html \
  && ln -s /home/username/Web /var/www/html \
  && curl -sSL https://raw.githubusercontent.com/leeolayvar/kdcli/master/installers/meta | fish

ADD Web /home/username/Web
RUN chown -R username: /home/username/Web

RUN  mkdir -p /home/username/.config/fish \
# HACK - Fake logname.
# As far as i can tell, Docker is causing trouble regarding the logname.
# I imagine it has to do with logname figuring out the current user based
# on the in-use tty(pts?), but Docker toys with that stuff a bit when
# you're interacting with a container directly. This "solution" simply
# avoids the problem for direct uses of logname.
  && echo 'alias logname="echo username"' >> /home/username/.bashrc \
  && echo 'function logname; echo username; end' >> /home/username/.config/fish/config.fish


WORKDIR /home/username
