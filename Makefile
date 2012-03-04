#----------------------------------------------------------
# Application-specific configuration:
# 	-- this is probabily where most of your customization
# 	-- will take place..
#
include source/Makefile.inc
# ember
APP_PATH = source/app.ember
APP_TARGET = public/js/app.js

# node
SERVER_PATH = source/app.node
API_PATH = $(SERVER_PATH)/handlers
SCHEMA_PATH = $(SERVER_PATH)/schema

# html rendering
HTML_LAYOUT = $(APP_PATH)/layouts/application.html
HTML_OUTPUT = public/index.html 

# tests
TESTS_PATH = source/tests.mocha
TESTS = $(TESTS_PATH)/*.js
REPORTER = spec

# stencils
STENCILS_PATH = stencils
BASE_STENCILS_PATH = $(STENCILS_PATH)/base

all: app.js html

assets: html

test:
	@mocha --reporter $(REPORTER) $(TESTS)

app.js: 
	@$(INFO) "generating $(APP_TARGET)\n"
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_app.js > $(APP_TARGET)
	@find $(APP_PATH) | grep .js$$ | xargs cat >> $(APP_TARGET) 
ifdef release
	@uglifyjs --overwrite $(APP_TARGET)
endif

html: 
	@$(eval TEMP_ASSETS_FILE := $(shell mktemp -t gorjsXXXXXXXXXX))
	@$(INFO) "generating $(HTML_OUTPUT)\n"
	@find $(APP_PATH)/templates | grep .html$$ | xargs -L1 -n2 -I % env val=% awk 'BEGIN {split(ENVIRON["val"],arr,"[./]") ; print "<script type=\"text/x-handlebars\" data-template-name=\"" arr[length(arr)-3]"-"arr[length(arr)-2] "\">"} {print $0} END {print "</script>"}' % > $(TEMP_ASSETS_FILE) ; sed -e '/templates/r '$(TEMP_ASSETS_FILE) -e '/templates/d' $(HTML_LAYOUT) > $(HTML_OUTPUT) ; rm $(TEMP_ASSETS_FILE)

clean: 
	@$(INFO) "removing generated javascript files"
	@rm -f $(APP_TARGET)
	@$(INFO) "removing generated html files"
	@rm -f $(HTML_OUTPUT) 

npm_install:
	npm install


submodules:
	@$(INFO) "downloading Twitter Bootstrap"
	@mkdir -p vendor/bootstrap
	@cd vendor/bootstrap ; curl http://twitter.github.com/bootstrap/assets/bootstrap.zip -O
	@$(INFO) "downloading Ember.js"
	@mkdir -p vendor/emberjs
	@cd vendor/emberjs ; curl http://cloud.github.com/downloads/emberjs/ember.js/ember-0.9.5.min.js -O
	@$(INFO) "downloading JQuery"
	@mkdir -p vendor/jquery
	@cd vendor/jquery ; curl http://code.jquery.com/jquery.min.js -O ; curl http://code.jquery.com/jquery.js -O
	@$(INFO) "copying stuff to public.."
	@cp vendor/emberjs/ember*.min.js public/js/ember.min.js
	@cd public ; unzip ../vendor/bootstrap/bootstrap.zip ; cp -R bootstrap/* . ; rm -R bootstrap
	@cp vendor/jquery/* public/js/

base:
	@$(eval enc_title := $(shell echo "$(title)" | sed -e "s;\ ;\\\ ;g"))
	@printf "APP_PREFIX=\"$(prefix)\"\n" >> source/Makefile.inc
	@printf "APP_TITLE=\"$(enc_title)\"\n" >> source/Makefile.inc
	@$(eval APP_PREFIX := $(prefix))
	@$(eval APP_TITLE := $(title))
	@$(TEMPLATE) $(BASE_STENCILS_PATH)/app.js > $(APP_PATH)/app.js
	@$(TEMPLATE) $(BASE_STENCILS_PATH)/server.js > $(SERVER_PATH)/server.js
	@$(TEMPLATE) $(BASE_STENCILS_PATH)/mainmenu.js > $(APP_PATH)/views/mainmenu.js
	@$(TEMPLATE) $(BASE_STENCILS_PATH)/application.html > $(APP_PATH)/layouts/application.html
	@mkdir -p vendor
	@mkdir -p public ; cd public ; mkdir -p js ; mkdir -p img ; mkdir -p css


check_environment:
	which node
	which uglifyjs
	which awk
	which sed
	which mocha

init: base submodules html app.js npm_install

destroy:
ifdef scaffold
	@rm $(APP_PATH)/models/$(scaffold).js
	@rm $(SCHEMA_PATH)/$(scaffold).js
	@rm -R $(APP_PATH)/templates/$(scaffold)s
	@rm $(APP_PATH)/controllers/$(scaffold)s_controller.js
	@rm -R $(APP_PATH)/views/$(scaffold)s
	@rm $(API_PATH)/$(scaffold)s.js
	@rm $(TESTS_PATH)/$(scaffold)_tests.js
endif
ifdef controller
	@rm $(APP_PATH)/controllers/$(controller)s_controller.js
endif
ifdef model
	@rm $(APP_PATH)/models/$(model).js
	@rm $(SCHEMA_PATH)/$(model).js
endif
ifdef view
	@rm -R $(APP_PATH)/views/$(view)s
endif
ifdef api
	@rm $(API_PATH)/$(api)s.js
endif
ifdef test
	@rm $(TESTS_PATH)/$(test)_tests.js
endif

scaffold:
ifdef for
	@$(MAKE) stencil model=$(for) --no-print-directory
	@$(MAKE) stencil view=$(for) --no-print-directory
	@$(MAKE) stencil controller=$(for) --no-print-directory
	@$(MAKE) stencil api=$(for) --no-print-directory
	@$(MAKE) stencil test=$(for) --no-print-directory
endif

#----------------------------------------------------------
# recipe: stencil
# 
# usage : make stencil {model|api|controller|view}=topic
#
# Use this to generate models, views, controllers and api
# scaffolds. Gorjs comes with a set of "stencils" in 
# ./$(STENCILS_PATH) to serve as code templates.
# You can modify these to suit your project specific
# requirements.
#
stencil:
ifndef APP_PREFIX
	@$(ERR) "project was not initialized.\n"
	@$(ERR) "use: make init prefix=YourAppPrefix title=\"Your App Title\"\n"
else

ifdef api
	@$(eval API_TARGET := $(API_PATH)/$(api)s.js)
	@$(eval RES := $(api))
	@$(eval CRES:=$(shell echo "$(RES)" | awk '{print toupper(substr($$0,1,1))substr($$0,2)}')) 
ifeq ($(wildcard $(API_TARGET)),) 
	@$(INFO) "generating $(SUBJECT_COLOR)$(API_TARGET)$(NO_COLOR) from $(STENCILS_PATH)/api.js\n"
	@$(TEMPLATE) $(STENCILS_PATH)/express_api.js > $(API_PATH)/$(api)s.js
else 
	@$(ERR) "API file $(SUBJECT_COLOR)$(api)s.js$(NO_COLOR) already exists\n"
endif
endif

ifdef model
	@$(eval MODEL_TARGET := $(APP_PATH)/models/$(model).js)
	@$(eval SCHEMA_TARGET := $(SCHEMA_PATH)/$(model).js)
	@$(eval RES := $(model))
	@$(eval CRES:=$(shell echo "$(RES)" | awk '{print toupper(substr($$0,1,1))substr($$0,2)}')) 
ifeq ($(wildcard $(APP_PATH)/models/$(model).js),) 
	@$(INFO) "generating $(SUBJECT_COLOR)$(MODEL_TARGET)$(NO_COLOR) from $(STENCILS_PATH)/emberjs_model.js\n"
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_model.js > $(MODEL_TARGET)
	@$(TEMPLATE) $(STENCILS_PATH)/mongoose_model.js > $(SCHEMA_TARGET)
else 
	@$(ERR) "$(SUBJECT_COLOR)$(MODEL_TARGET)$(NO_COLOR) already exists\n"
endif
endif

ifdef view
	@$(eval RES := $(view))
	@$(eval CRES:=$(shell echo "$(RES)" | awk '{print toupper(substr($$0,1,1))substr($$0,2)}')) 
ifeq ($(wildcard $(APP_PATH)/views/$(view)),) 
	@$(INFO) "generating views for $(SUBJECT_COLOR)$(view)$(NO_COLOR) from stencils\n"
	@mkdir $(APP_PATH)/views/$(view)s
	@mkdir $(APP_PATH)/templates/$(view)s
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_menu_item.js > $(APP_PATH)/views/$(view)s/menu.js
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_menu_item.hb.html >> $(APP_PATH)/templates/mainmenu.hb.html
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_list.js > $(APP_PATH)/views/$(view)s/list.js
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_item.js > $(APP_PATH)/views/$(view)s/item.js
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_form.js > $(APP_PATH)/views/$(view)s/form.js
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_toolbar.js > $(APP_PATH)/views/$(view)s/toolbar.js
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_list.hb.html > $(APP_PATH)/templates/$(view)s/list.hb.html
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_item.hb.html > $(APP_PATH)/templates/$(view)s/item.hb.html
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_form.hb.html > $(APP_PATH)/templates/$(view)s/form.hb.html
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_views_toolbar.hb.html > $(APP_PATH)/templates/$(view)s/toolbar.hb.html
else 
	@$(ERR) "View folder $(SUBJECT_COLOR)$(view)$(NO_COLOR) already exists\n"
endif
endif

ifdef controller
	@$(eval RES := $(controller))
	@$(eval CRES:=$(shell echo "$(RES)" | awk '{print toupper(substr($$0,1,1))substr($$0,2)}')) 
ifeq ($(wildcard $(APP_PATH)/controllers/$(controller)s_controller.js),) 
	@$(INFO) "generating controller $(SUBJECT_COLOR)$(controller)s_controller.js$(NO_COLOR) from stencil $(STENCILS_PATH)/emberjs_controller.js\n"
	@$(TEMPLATE) $(STENCILS_PATH)/emberjs_controller.js > $(APP_PATH)/controllers/$(controller)s_controller.js
else 
	@$(ERR) "Controller file $(SUBJECT_COLOR)$(controller)s_controller.js$(NO_COLOR) already exists\n"
endif
endif

ifdef test
	@$(eval RES := $(test))
	@$(eval CRES:=$(shell echo "$(RES)" | awk '{print toupper(substr($$0,1,1))substr($$0,2)}')) 
ifeq ($(wildcard $(TESTS_PATH)/$(test)_tests.js),) 
	@$(INFO) "generating $(SUBJECT_COLOR)$(test)_tests.js$(NO_COLOR) from stencil $(STENCILS_PATH)/mocha_test.js\n"
	@$(TEMPLATE) $(STENCILS_PATH)/mocha_test.js > $(TESTS_PATH)/$(test)_tests.js
else 
	@$(ERR) "$(SUBJECT_COLOR)$(test)_tests.js$(NO_COLOR) already exists\n"
endif
endif
endif # ifndef APP_PREFIX

#----------------------------------------------------------
# colors and color related macros
NO_COLOR=\x1b[0m
INFO_COLOR=\x1b[36;01m
SUBJECT_COLOR=\x1b[33;01m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m

OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[WARNINGS]$(NO_COLOR)

NO_COLOR=\x1b[0m
INFO = printf "$(INFO_COLOR)[Gor.js]$(NO_COLOR) " ; printf
ERR = printf "$(ERROR_COLOR)[Gor.js]$(NO_COLOR) " ; printf
TEMPLATE ?= sed -e "s;@RESOURCE@;$(RES);g" -e "s;@CRESOURCE@;$(CRES);g" -e "s;@APP@;$(APP_PREFIX);g" -e "s;@APP_TITLE@;$(APP_TITLE);g"

#----------------------------------------------------------
