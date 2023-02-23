FROM ubuntu:16.04

ARG VERSION

ENV BINWALK_GIT https://github.com/ReFirmLabs/binwalk
ENV SASQUATCH_GIT https://github.com/devttys0/sasquatch
ENV JEFFERSON_GIT https://github.com/sviehb/jefferson
ENV UBI_READER_GIT https://github.com/jrspruitt/ubi_reader
ENV YAFFSHIV_GIT https://github.com/devttys0/yaffshiv

# install minimal dependencies
RUN apt-get update -y
RUN apt-get install -y curl wget git python3 python3-pip build-essential unzip

# binwalk deps - for graphs and visualizations
RUN apt-get install -y libqt4-opengl python3-opengl python3-pyqt4 python3-pyqt4.qtopengl python3-numpy python3-scipy python3-pyqtgraph

# binwalk deps - for automatically extract archives/file systems/etc.
RUN apt-get install -y mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsprogs cramfsswap squashfs-tools sleuthkit default-jdk lzop srecord

# binwalk deps - sasquatch
RUN apt-get install -y zlib1g-dev liblzma-dev liblzo2-dev
RUN git clone $SASQUATCH_GIT /opt/sasquatch
RUN (cd /opt/sasquatch && ./build.sh)

# image clean-ups
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# make user!
RUN useradd -ms /bin/bash binwalk
USER binwalk

RUN python3 -m pip install python-lzo --user

# binwalk deps - jffs2/jefferson
RUN git clone $JEFFERSON_GIT /home/binwalk/jefferson
RUN (cd /home/binwalk/jefferson && python3 -m pip install -r requirements.txt --user && python3 setup.py install --user)

# install ubi_reader
RUN git clone $UBI_READER_GIT /home/binwalk/ubi_reader
RUN (cd /home/binwalk/ubi_reader && python3 setup.py install --user)

# install yaffshiv
RUN git clone $YAFFSHIV_GIT /home/binwalk/yaffshiv
RUN (cd /home/binwalk/yaffshiv && python3 setup.py install --user)

# install binwalk
RUN git clone $BINWALK_GIT /home/binwalk/binwalk
RUN (cd /home/binwalk/binwalk && git checkout tags/v$VERSION && python3 setup.py install --user)

ENV PATH /home/binwalk/.local/bin:$PATH
WORKDIR /cwd
ENTRYPOINT ["binwalk"]
