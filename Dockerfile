FROM centos 

MAINTAINER Bean Shih <beanking77@gmail.com>

## Install redis and create redis folder
RUN set -x \
    && yum clean all \
    && yum install -y \
       rubygems \
       gcc \
       make \
       wget \
       ruby \
       ruby-devel \
       rpm-build \
       vim \
       net-tools \
       gettext \
    && yum clean all 

RUN wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/e/ \
    && rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-*.rpm \
    && yum install redis -y

ADD ./redis_script /usr/local/sbin/
ADD ./redis_conf /redis-conf/

## Install redis-trib dependency
RUN gem install redis

## Add startup script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/bin/bash","/start.sh"] 
