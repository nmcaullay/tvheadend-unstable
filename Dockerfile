FROM phusion/baseimage:0.9.19

# maintained by Nathan
MAINTAINER nmcaullay <nmcaullay@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables.
ENV HOME /root

#Create the HTS user (1000), and add to user group (100)
RUN useradd -u 1001 -g 100 hts

# Install dependencies, build and install tvheadend
RUN apt-get update -qq && \
    apt-get install -qy \
    build-essential pkg-config libssl-dev git bzip2 wget cmake \
    libavahi-client-dev zlib1g-dev libcurl4-gnutls-dev python \
    liburiparser1 liburiparser-dev gettext \
    libhdhomerun-dev dvb-apps && \
    cd /tmp && \
    git clone https://github.com/tvheadend/tvheadend.git && \
    cd tvheadend && \
    git reset --hard HEAD && \
    git pull && \
    ./configure --enable-hdhomerun_client --enable-hdhomerun_static --enable-libffmpeg_static --prefix=/usr && \
    make && \
    make install && \
    rm -r /tmp/tvheadend && apt-get purge -qq build-essential pkg-config git && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose the TVH ports
EXPOSE 9981 9982

#Make the folders
RUN mkdir /config
RUN mkdir /tvrecordings
RUN mkdir /sport
RUN mkdir /kidsmovies
RUN mkdir /parentsmovies
RUN mkdir /timeshift

#Set the permissions
RUN chown -R hts:100 /config
RUN chown -R hts:100 /tvrecordings
RUN chown -R hts:100 /sport
RUN chown -R hts:100 /kidsmovies
RUN chown -R hts:100 /parentsmovies
RUN chown -R hts:100 /timeshift

#Start tvheadend when container starts 
CMD ["/usr/bin/tvheadend","-C","-f","-u","hts","-g","users","-c","/config"]
