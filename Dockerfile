
#!/bin/bash
#Author:T-nings
#Date:20190718
#Revision:1.0
#docker.jenkins.Dockerfile
#Email:
#Description: Welcome to use automatic intelligent management "docker.jenkins.Dockerfile" configuration file,All rights reserved, please obtain Nings's license before use, unlicensed, illegal reproduction, use and so on are strictly prohibited.

FROM ansible/centos7-ansible
MAINTAINER nings 1150550809@qq.com
ENV LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"
RUN rm -rf /etc/yum.repos.d/*
ADD Centos-7.repo /etc/yum.repos.d
....
