# Makefile for building a website using sphinx.
# This Makefile has been heavily modified from the original that
# sphinx-quickstart automatically creates

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
BUILDDIR      = _build
SOURCEDIR     = .

# Other variables for site management, css updating, etc.
STATICDIR   = _static
STATIC_CSS  = themes/satra/static
SITE        = $(BUILDDIR)/html
WWW         = cirl:www
WWW2        = fdo_perez@fperez.org:fperez.org

# Internal variables.
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(SPHINXOPTS) $(SOURCEDIR)

.PHONY: help clean html site linkcheck doctest upload

default: site

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html      to make standalone HTML files"
	@echo "  linkcheck to check all external links for integrity"
	@echo "  doctest   to run all doctests embedded in the documentation (if enabled)"
	@echo "     upload to push the local site build to its public location"

clean:
	-rm -rf $(BUILDDIR)/*
	-rm -f *~

html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."


linkcheck: site
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

# fperez - new targets I've added after sphinx-quickstart

# Update target to push to live site
upload: site
	chmod -R uog+r $(SITE)
	rsync -avrzH --copy-links --delete -e ssh  $(SITE)/ $(WWW)

upload2: site
	chmod -R uog+r $(SITE)
	rsync -avrzH --copy-links --delete -e ssh  $(SITE)/ $(WWW2)

# Update only css files
css:
	rsync -av --exclude=~ $(STATIC_CSS)/ $(SITE)/$(STATICDIR)

site: html
	./copy_trees.py

github: html
	rsync -auv _build/html/. /software/nipy-repo/satra.github.com/.
