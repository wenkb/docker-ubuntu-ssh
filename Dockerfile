FROM ubuntu:18.04

LABEL description="ubuntu with ssh" \
      author="wenkb" \
      create_date="2018-10-12" \
      build_cmd="docker build --rm -t wenkb/docker-ubuntu-ssh:v1.0 ."

# envrionment config
ENV ROOT_PW=password

# change root password
RUN echo "root:$ROOT_PW" | chpasswd

# install ssh
RUN apt-get update \
 && apt-get install -y openssh-server \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 # config ssh
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# create ssh dir
RUN mkdir /var/run/sshd \
 && mkdir /root/.ssh 

# create upload and download dir
RUN mkdir -p /home/upload \
 && mkdir -p /home/download

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

