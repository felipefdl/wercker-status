# Executables
MOCHA_EXEC  = ./node_modules/.bin/mocha

.PHONY: test mocha

test: mocha

mocha:
	@echo "\n---| Running Mocha |---"
	@NODE_ENV=test $(MOCHA_EXEC) \
	--reporter spec \
	--ui tdd \
	--recursive \
	--compilers coffee:coffee-script/register \
	test/
