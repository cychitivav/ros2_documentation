# Make file to generate documentation

SOURCE     = source
OUT        = build
LINKCHECKDIR  = $(OUT)/linkcheck
BUILD      = python3 -m sphinx
OPTS       = -c .
LANGUAGES  = en es fr

help:
	@$(BUILD) -M help "$(SOURCE)" "$(OUT)" $(OPTS)
	@echo "  multiversion to build documentation for all branches"

multiversion: Makefile
	@for lang in $(LANGUAGES); do \
		sphinx-multiversion $(OPTS) -D language=$$lang "$(SOURCE)" "$(OUT)/html/$$lang"; \
		echo "<html><head><meta http-equiv=\"refresh\" content=\"0; url=humble/index.html\" /></head></html>" > build/html/$$lang/index.html; \
		python3 make_sitemapindex.py; \
	done

%: Makefile
	@$(BUILD) -M $@ "$(SOURCE)" "$(OUT)" $(OPTS)

test:
	doc8 --ignore D001 --ignore-path build

linkcheck:
	$(BUILD) -b linkcheck $(OPTS) $(SOURCE) $(LINKCHECKDIR)
	@echo
	@echo "Check finished. Report is in $(LINKCHECKDIR)."

updatepo:
	@for lang in $(subst en ,,$(LANGUAGES)); do \
		sphinx-intl update -p "$(OUT)/gettext" -d "locale" -l $$lang; \
	done

html:
	@for lang in $(LANGUAGES); do \
		$(BUILD) -b html -D language=$$lang $(OPTS) $(SOURCE) $(OUT)/html/$$lang; \
	done


.PHONY: help Makefile multiversion test linkcheck updatepo html

