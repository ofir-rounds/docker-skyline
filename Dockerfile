FROM debian:7.6
MAINTAINER Dieter Plaetinck <dieter@vimeo.com>

# /var/dump for redis data
RUN mkdir -p /var/log/skyline /var/run/skyline /var/log/redis /var/dump/

RUN apt-get update
# python-dev is for numpy
RUN apt-get install -y python-setuptools python-scipy git python-dev
RUN easy_install pip

#Redis
RUN apt-get install -y wget gcc build-essential
RUN wget http://download.redis.io/releases/redis-2.6.16.tar.gz
RUN tar --extract --gzip --directory /opt --file redis-2.6.16.tar.gz
RUN cd /opt/redis-2.6.16 && make

ENV PATH $PATH:/opt/redis-2.6.16/src

RUN pip install --upgrade numpy 
RUN pip install pandas patsy msgpack-python
RUN pip install statsmodels  # must install pandas first :/

RUN git clone https://github.com/etsy/skyline.git /opt/skyline

RUN pip install -r /opt/skyline/requirements.txt

ADD skyline-start.sh /usr/bin/skyline-start.sh
RUN chmod +x /usr/bin/skyline-start.sh

ADD skyline-settings.py /opt/skyline/src/settings.py

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH $PATH:/opt/skyline/bin
CMD ["skyline-start.sh"]
