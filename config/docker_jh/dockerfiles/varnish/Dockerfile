FROM varnish:6.2

RUN apt-get update \
 && apt-get install -y --force-yes git make automake autotools-dev libedit-dev libjemalloc-dev libncurses-dev libpcre3-dev libtool pkg-config python-docutils python-sphinx graphviz varnish-dev libcurl4-openssl-dev

# Install Vmode cookie
RUN set -eux \
 && cd /usr/local/src \
 && git clone https://github.com/varnish/varnish-modules.git \
 && cd varnish-modules \
 && git checkout 6.2 \
 && ./bootstrap \
 && ./configure \
 && make \
 && make install

# Install Vmode curl
RUN set -eux \
 && cd /usr/local/src \
 && git clone https://github.com/varnish/libvmod-curl.git \
 && cd libvmod-curl \
 && git checkout 6.2 \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install

# Install json (frozen)
RUN set -eux \
 && cd /usr/local/src \
 && git clone --recurse-submodules https://gitlab.com/uplex/varnish/libvmod-frozen.git \
 && cd libvmod-frozen \
 && git checkout 6.2 \
 && ./bootstrap \
 && make \
 && make install