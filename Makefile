NAME=github-hub
VERSION=2.2.9
EPOCH=1
ITERATION=1
PREFIX=/usr/local/bin
LICENSE=BSD
VENDOR="GitHub"
MAINTAINER="Ryan Parman"
DESCRIPTION="Hub is a command-line wrapper for Git that makes you better at GitHub."
URL=https://hub.github.com
RHEL=$(shell rpm -q --queryformat '%{VERSION}' centos-release)

#-------------------------------------------------------------------------------

all: info clean extract package move

#-------------------------------------------------------------------------------

.PHONY: info
info:
	@ echo "NAME:        $(NAME)"
	@ echo "VERSION:     $(VERSION)"
	@ echo "EPOCH:       $(EPOCH)"
	@ echo "ITERATION:   $(ITERATION)"
	@ echo "PREFIX:      $(PREFIX)"
	@ echo "LICENSE:     $(LICENSE)"
	@ echo "VENDOR:      $(VENDOR)"
	@ echo "MAINTAINER:  $(MAINTAINER)"
	@ echo "DESCRIPTION: $(DESCRIPTION)"
	@ echo "URL:         $(URL)"
	@ echo "RHEL:        $(RHEL)"
	@ echo " "

#-------------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -Rf /tmp/installdir* github*

#-------------------------------------------------------------------------------

.PHONY: extract
extract:
	mkdir -p /tmp/installdir-$(NAME)-$(VERSION);
	wget https://github.com/github/hub/releases/download/v$(VERSION)/hub-linux-amd64-$(VERSION).tgz
	tar -C /tmp/installdir-$(NAME)-$(VERSION) -xzf hub-linux-amd64-$(VERSION).tgz

#-------------------------------------------------------------------------------

.PHONY: package
package:

	# Main package
	fpm \
		-s dir \
		-t rpm \
		-n $(NAME) \
		-v $(VERSION) \
		-C /tmp/installdir-$(NAME)-$(VERSION)/hub-linux-amd64-$(VERSION) \
		-m $(MAINTAINER) \
		--epoch $(EPOCH) \
		--iteration $(ITERATION) \
		--license $(LICENSE) \
		--vendor $(VENDOR) \
		--prefix $(PREFIX) \
		--url $(URL) \
		--description $(DESCRIPTION) \
		--rpm-defattrfile 0755 \
		--rpm-digest md5 \
		--rpm-compression gzip \
		--rpm-os linux \
		--rpm-auto-add-directories \
		--template-scripts \
		bin \
		etc \
		share \
	;

#-------------------------------------------------------------------------------

.PHONY: move
move:
	mv *.rpm /vagrant/repo/
