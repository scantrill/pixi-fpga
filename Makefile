prefix     = /usr/local
sharedir   = $(prefix)/share
projectdir = pixi-tools
fpgasubdir = $(projectdir)/fpga
fpgadir    = $(sharedir)/$(fpgasubdir)

ifeq ($(V),)
    CMD   = @
    ECHO  = @echo
else
    CMD   =
    ECHO  = @\#
endif

.PHONY: phony install uninstall

all:
	@true

install: $(APPS)
	$(ECHO) installing FPGA images
	$(CMD)cd fpga && for target in `find * -name \*.bin`; do \
		dir=$(DESTDIR)$(fpgadir)/`dirname $$target`; \
		mkdir -p $$dir; \
		install -m 0644 -v $$target $$dir || exit 1 ; \
	done

uninstall:
	$(ECHO) uninstalling FPGA images
	$(CMD)cd fpga && for target in `find * -name \*.bin`; do \
		rm -f -v $(DESTDIR)$(fpgadir)/$$target ; \
	done
	$(CMD)cd $(DESTDIR)$(sharedir) && find $(projectdir) -depth -type d -print0 | \
		xargs -0 rmdir --ignore-fail-on-non-empty --verbose

.PHONY: deb deb-clean
deb:
	. ./project-info && git archive -o ../$${PROJECT_NAME}_$${PROJECT_VERSION}.orig.tar.gz HEAD
	debuild

deb-clean:
	debuild clean
