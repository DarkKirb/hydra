TEMPLATES = $(wildcard *.tt)
STATIC = \
  $(wildcard static/images/*) \
  $(wildcard static/css/*) \
  static/js/bootbox.min.js \
  static/js/popper.min.js \
  static/js/common.js \
  static/js/jquery/jquery-3.4.1.min.js \
  static/js/jquery/jquery-ui-1.10.4.min.js

EXTRA_DIST = $(TEMPLATES) $(STATIC)

hydradir = $(libexecdir)/hydra/root
nobase_hydra_DATA = $(EXTRA_DIST)

install-data-local: $(ZIPS)
	mkdir -p $(hydradir)/static/js
	cp -prvd $(srcdir)/static/js/* $(hydradir)/static/js
	mkdir -p $(hydradir)/static/bootstrap
	cp -prvd $(srcdir)/static/bootstrap/* $(hydradir)/static/bootstrap
	mkdir -p $(hydradir)/static/fontawesome/{css,webfonts}
	cp -prvd $(srcdir)/static/fontawesome/css/* $(hydradir)/static/fontawesome/css
	cp -prvd $(srcdir)/static/fontawesome/webfonts/* $(hydradir)/static/fontawesome/webfonts
