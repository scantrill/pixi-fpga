prefix     = /usr/local
sharedir   = $(prefix)/share
fpgasubdir = pixi-tools/fpga
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
	$(CMD)mkdir -p $(DESTDIR)$(fpgadir)
	$(CMD)cd fpga && for target in *.bin; do \
		install -m 0644 -v $$target $(DESTDIR)$(fpgadir)/ || exit 1 ; \
	done

uninstall:
	$(ECHO) uninstalling FPGA images
	$(CMD)cd fpga && for target in *.bin; do \
		rm -f -v $(DESTDIR)$(fpgadir)/$$target ; \
	done
	$(CMD)cd $(DESTDIR)$(sharedir) && rmdir --parents --ignore-fail-on-non-empty --verbose $(fpgasubdir)

.PHONY: deb deb-clean
deb:
	debuild -us -uc

deb-clean:
	debuild clean
