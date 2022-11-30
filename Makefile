uname = $(shell uname)

ifeq (Darwin, $(uname))
	tool = darwin-rebuild
else
	tool = nixos-rebuild
endif

build:
	$(tool) build --flake .#

switch:
	$(tool) switch --flake .#
