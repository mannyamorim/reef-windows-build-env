FROM debian:bookworm

# Install packages needed for MXE
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	autoconf \
	automake \
	autopoint \
	bash \
	bison \
	bzip2 \
	flex \
	g++ \
	g++-multilib \
	gettext \
	git \
	gperf \
	intltool \
	libc6-dev-i386 \
	libgdk-pixbuf2.0-dev \
	libltdl-dev \
	libssl-dev \
	libtool-bin \
	libxml-parser-perl \
	lzip \
	make \
	openssl \
	p7zip-full \
	patch \
	perl \
	python3 \
	ruby \
	sed \
	unzip \
	wget \
	xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Create a folder for MXE and clone the repo
RUN mkdir /opt/mxe && git clone https://github.com/mxe/mxe.git /opt/mxe
WORKDIR /opt/mxe

# Build the cross compiler and packages
RUN make MXE_TARGETS=x86_64-w64-mingw32.shared.posix MXE_PLUGIN_DIRS=/opt/mxe/plugins/gcc14 cc qt6 libgit2 && /opt/mxe/.ccache/bin/ccache --clear && rm /opt/mxe/pkg/*

# Setup the path for the cross compiler
ENV PATH=/opt/mxe/usr/bin:$PATH

# Create a folder for work
RUN mkdir /build
WORKDIR /build
