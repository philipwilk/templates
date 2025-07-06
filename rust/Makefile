CC := sccache gcc
command := ${CC} -std=iso9899:2024
# All the commented out lines are for caching when you have more than one source file.
# They split object compilation and linking so sccache can work.

#classFiles :=  a b c
#classDirs := $(addprefix src/classes/,$(classFiles))
#classSources := $(addsuffix .c,$(classDirs))
#src := $(addprefix ../../,$(classSources))
#objs := $(addsuffix .o,$(addprefix build/objs/,$(classFiles)))

# This must be at the top of the makefile or nix explodes
all: build-main
	
prep:
	mkdir -p build build/objs

build-main: prep
	#cd build/objs && $(foreach file,$(src),$(command) -c $(file);) $(command) -c ../../src/main.c
	#$(command) -o build/main $(objs) build/objs/main.o
	cd build/objs && $(command) -c ../../src/main.c
	$(command) -o build/main build/objs/main.o

main: build-main
	build/main

clean:
	rm -r build

run: all
	clear
	build/main
