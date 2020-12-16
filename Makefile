SCRIPTS=$(wildcard scripts/*.js)
all: docs/oooxhtml.js

docs/oooxhtml.js: $(SCRIPTS)
	cat $(SCRIPTS) > docs/oooxhtml.js
