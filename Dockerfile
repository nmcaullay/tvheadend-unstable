FROM phusion/baseimage:0.9.19

# maintained by Nathan
MAINTAINER nmcaullay <nmcaullay@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables.
ENV HOME /root

#Create the HTS user (9981), and add to user group (9981)
RUN groupadd -g 9981 hts
RUN useradd -u 9981 -g 9981 hts

# Install dependencies, build and install tvheadend
RUN apt-get update -qq && \
    apt-get install -qy \
    build-essential pkg-config libssl-dev git bzip2 wget cmake \
    libavahi-client-dev zlib1g-dev libcurl4-gnutls-dev python \
    liburiparser1 liburiparser-dev gettext \
    libhdhomerun-dev dvb-apps \
    autoconf automake libtool && \
    
# build argtable2
mkdir -p /tmp/argtable && \
wget "https://sourceforge.net/projects/argtable/files/argtable/argtable-2.13/argtable2-13.tar.gz" /tmp/argtable-src.tar.gz && \
cd /tmp/argtable && \
tar xf /tmp/argtable-src.tar.gz -C && \
./configure --prefix=/usr && \
make && \
make check && \
make install && \
 
    cd /tmp && \
    git clone https://github.com/tvheadend/tvheadend.git && \
    cd tvheadend && \
    git reset --hard HEAD && \
    git pull && \
    ./configure --enable-hdhomerun_client --enable-hdhomerun_static --enable-libffmpeg_static --prefix=/usr && \
    make && \
    make install && \
    git clone git://github.com/erikkaashoek/Comskip /tmp/comskip && \
    cd /tmp/comskip && \
    ./autogen.sh && \
    ./configure \
	--bindir=/usr/bin \
	--sysconfdir=/config/comskip && \
    make && \
    make install && \
    rm -r /tmp/comskip && rm -r /tmp/tvheadend && apt-get purge -qq build-essential pkg-config git && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose the TVH ports
EXPOSE 9981 9982

#Make the folders
#RUN mkdir /config
#RUN mkdir /tvrecordings
#RUN mkdir /sport
#RUN mkdir /kidsmovies
#RUN mkdir /parentsmovies
##RUN mkdir /timeshift

#Expose the volumes
VOLUME ["/config"]
VOLUME ["/media"]

#Set the permissions
#RUN chown -R hts:hts /config
#RUN chown -R hts:100 /tvrecordings
#RUN chown -R hts:100 /sport
#RUN chown -R hts:100 /kidsmovies
#RUN chown -R hts:100 /parentsmovies
#RUN chown -R hts:100 /timeshift

#Set the user
USER hts

#Start tvheadend when container starts 
CMD ["/usr/bin/tvheadend","-C","-u","hts","-g","hts","-c","/config"]
#ENTRYPOINT ["/usr/bin/tvheadend","-C","-u","hts","-g","hts","-c","/config"]

