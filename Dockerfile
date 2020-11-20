FROM alpine:3.12

COPY ./taskd.sh /usr/bin

RUN apk add --no-cache --virtual build-dependencies \
	gnutls-dev \
	libuuid \
	cmake \
	git \
	build-base \
	util-linux-dev; \
	git clone https://github.com/GothenburgBitFactory/taskserver.git && cd taskserver; \
	git submodule init; git submodule update; \
	mkdir build && cd build; \
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ..; \
	make; \
	make install; \
	cd .. && cp -r pki /usr/share/doc/taskd/; \
	cd ../.. && rm -rf taskserver; \
	apk del --purge build-dependencies; \
	apk add --no-cache gnutls libuuid util-linux bash libgcc libstdc++; \
	mkdir /var/taskd && chmod +x /usr/bin/taskd.sh

ENV TASKDATA /var/taskd

VOLUME ["/var/taskd"]
EXPOSE 53589
CMD ["/usr/bin/taskd.sh"]
