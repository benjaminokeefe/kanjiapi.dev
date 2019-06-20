OUT_DIR := out
SITE_SRC_DIR := site
SITE_DIR := $(OUT_DIR)/site
API_DIR := $(OUT_DIR)/v1
KANJI_DIR := $(API_DIR)/kanji
WORDS_DIR := $(API_DIR)/words
READING_DIR := $(API_DIR)/reading
BROWSERIFY := node_modules/browserify/bin/cmd.js
TACHYONS := node_modules/tachyons/css/tachyons.min.css

.PHONY: directories all clean

all: $(OUT_DIR)/kanji.stamp $(SITE_DIR)/index.html $(SITE_DIR)/404.html $(SITE_DIR)/v1

directories: $(OUT_DIR) $(SITE_DIR) $(API_DIR) $(KANJI_DIR) $(WORDS_DIR) $(READING_DIR)

$(OUT_DIR):
	mkdir -p $@

$(SITE_DIR):
	mkdir -p $@

$(API_DIR):
	mkdir -p $@

$(KANJI_DIR):
	mkdir -p $@

$(WORDS_DIR):
	mkdir -p $@

$(READING_DIR):
	mkdir -p $@

$(SITE_DIR)/v1: $(SITE_DIR)
	ln -sF ../v1 $@

$(OUT_DIR)/kanji.stamp: kanjidic2.xml main.py kanjiapi/api_data.py kanjiapi/entry.py kanjiapi/entry_data.py | directories
	python main.py
	touch $@

$(SITE_DIR)/index.html: $(SITE_SRC_DIR)/index.html | $(SITE_DIR)/tachyons.min.css $(SITE_DIR)/styling.css directories $(SITE_DIR)/index.js
	cp $^ $@

$(SITE_DIR)/index.js: $(SITE_SRC_DIR)/index.js | directories
	$(BROWSERIFY) $^ -o $@

$(SITE_DIR)/404.html: $(SITE_SRC_DIR)/404.html | $(SITE_DIR)/styling.css directories
	cp $^ $@

$(SITE_DIR)/styling.css: $(SITE_SRC_DIR)/styling.css | directories
	cp $^ $@

$(SITE_DIR)/tachyons.min.css: $(TACHYONS) | directories
	cp $^ $@

clean:
	rm -rf $(OUT_DIR)
