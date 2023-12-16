FROM ubuntu:latest

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Install necessary dependencies
RUN apt update -y
RUN apt upgrade -y
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update
RUN apt install python3.11 -y
RUN apt install python3-pip -y --force-yes
RUN apt install swish-e -y
RUN apt install sudo

RUN apt install default-jre -y
RUN apt install default-jdk -y

RUN mkdir /opt/search-engine
WORKDIR /opt/search-engine
COPY . /opt/search-engine

RUN pip3 install -r requirements.txt

RUN sudo bash setup.sh -i C

RUN tar -xvzf solr.tar.gz
RUN rm solr.tar.gz

RUN useradd -ms /bin/bash se
USER se

RUN bash setup.sh -i nutch

USER root

EXPOSE 5000
EXPOSE 8983

CMD ["python3", "app.py"]