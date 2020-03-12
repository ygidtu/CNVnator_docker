FROM ubuntu:18.04

MAINTAINER ygidtu <ygidtu@gmail.com>

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

COPY sources.list /etc/apt/sources.list
COPY *.zip /usr/src/
COPY *.tar* /usr/src/

RUN apt-get update && apt-get -y upgrade && apt-get install -y build-essential git wget \
	zlib1g-dev libncurses5-dev libbz2-dev liblzma-dev libcurl3-dev \
	libx11-xcb-dev libxft-dev unzip libreadline-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/src

#ROOT
RUN tar xfz root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz && \
	rm root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz
ENV ROOTSYS /usr/src/root
ENV LD_LIBRARY_PATH /usr/src/root/lib


#Samtools
RUN tar jxf samtools-1.9.tar.bz2 && \
	rm samtools-1.9.tar.bz2 && \
	cd samtools-1.9 && \
	./configure --prefix $(pwd) && \
	make && \
	ln -s /usr/src/samtools-1.9/samtools /usr/bin/samtools

#cnvnator
RUN unzip CNVnator_v0.4.1.zip && \
	cd CNVnator_v0.4.1/src && \
	ln -s /usr/src/samtools-1.9 samtools && \
	ls -l && make


ENTRYPOINT [ "/usr/src/CNVnator_v0.4.1/src/cnvnator" ]

