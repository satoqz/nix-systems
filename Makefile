# shortcuts for quick iteration of configs

uname = $(shell uname)

ifeq (Darwin, $(uname))
	tool = darwin-rebuild
else
	tool = sudo nixos-rebuild
endif

build:
	$(tool) build --flake .

switch:
	$(tool) switch --flake .
