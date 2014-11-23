REBAR=          rebar

.PHONY: all deps compile get-deps clean

all: get-deps compile

deps: get-deps compile

get-deps:
	@$(REBAR) get-deps

compile:
	@$(REBAR) compile

clean:
	@$(REBAR) clean
