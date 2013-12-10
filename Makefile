#-----------------------------------------------------------
# Re-make lecture materials.
#-----------------------------------------------------------

# Directories.
OUT = _site
LINK_OUT = /tmp/bc-links
BOOK = _book

# Source Markdown pages.
MARKDOWN_SRC = \
	LICENSE.md \
	NEW_MATERIAL.md \
	bib.md \
	gloss.md \
	rules.md \
	$(wildcard bash/novice/*.md) \
	$(wildcard git/novice/*.md) \
	$(wildcard python/novice/*.md) \
	$(wildcard sql/novice/*.md)

NOTEBOOK_SRC = \
	$(wildcard bash/novice/*.ipynb) \
	$(wildcard git/novice/*.ipynb) \
	$(wildcard python/novice/*.ipynb) \
	$(wildcard sql/novice/*.ipynb)

NOTEBOOK_MD = \
	$(patsubst %.ipynb,%.md,$(NOTEBOOK_SRC))

HTML_DST = \
	$(patsubst %.md,$(OUT)/%.html,$(MARKDOWN_SRC)) \
	$(patsubst %.md,$(OUT)/%.html,$(NOTEBOOK_MD))

BOOK_SRC = \
	$(OUT)/bash/novice/index.html $(wildcard $(OUT)/bash/novice/*-*.html) \
	$(OUT)/git/novice/index.html $(wildcard $(OUT)/git/novice/*-*.html) \
	$(OUT)/python/novice/index.html $(wildcard $(OUT)/python/novice/*-*.html) \
	$(OUT)/sql/novice/index.html $(wildcard $(OUT)/sql/novice/*-*.html) \
	$(OUT)/bib.html \
	$(OUT)/gloss.html \
	$(OUT)/rules.html \
	$(OUT)/LICENSE.html

.SECONDARY : $(NOTEBOOK_MD)

#-----------------------------------------------------------

# Default action: show available commands (marked with double '#').
all : commands

## check    : build site.
check : $(OUT)/index.html

# Build HTML versions of Markdown source files using Jekyll.
$(OUT)/index.html : $(MARKDOWN_SRC) $(NOTEBOOK_MD)
	jekyll -t build -d $(OUT)
	mv $(OUT)/NEW_MATERIAL.html $(OUT)/index.html

# Build Markdown versions of IPython Notebooks.
%.md : %.ipynb
	ipython nbconvert --template=./swc.tpl --to=markdown --output="$(subst .md,,$@)" "$<"

book : book.html

book.html : $(BOOK_SRC)
	python bin/make-book.py $^ > $@

#-----------------------------------------------------------

## commands : show all commands
commands :
	@grep -E '^##' Makefile | sed -e 's/## //g'

## fixme    : find places where fixes are needed.
fixme :
	@grep -n FIXME $$(find -f bash git python sql -type f -print | grep -v .ipynb_checkpoints)

## gloss    : check glossary
gloss :
	@bin/gloss.py ./gloss.md $(MARKDOWN_DST) $(NOTEBOOK_DST)

## images   : create a temporary page to display images
images :
	@bin/make-image-page.py $(MARKDOWN_SRC) $(NOTEBOOK_SRC) > image-page.html
	@echo "Open ./image-page.html to view images"

## links    : check links
# Depends on linklint, an HTML link-checking module from
# http://www.linklint.org/, which has been put in bin/linklint.
# Look in output directory's 'error.txt' file for results.
links :
	@bin/linklint -doc $(LINK_OUT) -textonly -root $(OUT) /@

## clean    : clean up
clean :
	@rm -rf $(OUT) $(NOTEBOOK_MD) $$(find . -name '*~' -print) $$(find . -name '*.pyc' -print)

## show     : show variables
show :
	@echo "MARKDOWN_SRC" $(MARKDOWN_SRC)
	@echo "NOTEBOOK_SRC" $(NOTEBOOK_SRC)
	@echo "NOTEBOOK_MD" $(NOTEBOOK_MD)
	@echo "HTML_DST" $(HTML_DST)
