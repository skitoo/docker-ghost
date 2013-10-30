
FROM ubuntu:latest
MAINTAINER Alexis Couronne
 
# update system
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive

# install tools
RUN apt-get install -y python-software-properties wget unzip pwgen supervisor openssh-server sudo

# install nodejs
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs

# install ghost
RUN mkdir /ghost
RUN wget -O /ghost/ghost.zip https://github.com/TryGhost/Ghost/releases/download/0.3.3/Ghost-0.3.3.zip
RUN cd /ghost && unzip ghost.zip
RUN rm /ghost/ghost.zip
RUN cd /ghost && npm install --production
ADD config.js /ghost/config.js
#ADD themes /ghost/themes

ADD start.sh /start.sh
ADD supervisor/ghost.conf /etc/supervisor/conf.d/ghost.conf
ADD supervisor/sshd.conf /etc/supervisor/conf.d/sshd.conf
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /var/run/sshd
RUN chmod 0755 /var/run/sshd

EXPOSE 2368
EXPOSE 22

CMD ["/bin/bash", "/start.sh"]
