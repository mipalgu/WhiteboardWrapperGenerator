SWIFT=swift

ALL_TARGETS=host

.include "../../mk/prefs.mk"

swift-build:
	$Eenv ${BUILD_ENV} ${SWIFT} build -c ${SWIFT_BUILD_CONFIG} ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

host:	swift-build

install: host
	cp .build/${SWIFT_BUILD_CONFIG}/WhiteboardWrapperGenerator /usr/local/bin

clean:
	rm -rf .build

.include "../../mk/jenkins.mk"

