# Make file to generate documentation

SOURCE     = source
OUT        = build
LINKCHECKDIR  = $(OUT)/linkcheck
BUILD      = python3 -m sphinx
OPTS       = -c .
LANGUAGE   = en# es,fr,de,...

help:
	@$(BUILD) -M help "$(SOURCE)" "$(OUT)" $(OPTS)
	@echo "  multiversion to build documentation for all branches"

multiversion: Makefile
	sphinx-multiversion $(OPTS) "$(SOURCE)" build/html
	@echo "<html><head><meta http-equiv=\"refresh\" content=\"0; url=humble/index.html\" /></head></html>" > build/html/index.html
	python3 make_sitemapindex.py

%: Makefile
	@$(BUILD) -M $@ "$(SOURCE)" "$(OUT)" $(OPTS)

test:
	doc8 --ignore D001 --ignore-path build

linkcheck:
	$(BUILD) -b linkcheck $(OPTS) $(SOURCE) $(LINKCHECKDIR)
	@echo
	@echo "Check finished. Report is in $(LINKCHECKDIR)."

.PHONY: help Makefile multiversion test linkcheck updatepo html

ifeq ($(LANGUAGE),en)
updatepo:
	@echo It is not necessary to update PO for the language $(LANGUAGE)
else
updatepo:
	@$(BUILD) -M gettext "$(SOURCE)" "$(OUT)" $(OPTS)
	@sphinx-intl update -p "$(OUT)/gettext" -d "locale" -l '$(LANGUAGE)'
endif

html:
	@$(BUILD) -b html "$(SOURCE)" "$(OUT)/html/$(LANGUAGE)" $(OPTS) -D language=$(LANGUAGE)
