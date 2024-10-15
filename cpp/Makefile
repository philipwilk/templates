CC := sccache g++
command := ${CC} -std=c++20
# All the commented out lines are for caching when you have more than one source file.
# They split object compilation and linking so sccache can work.

#classFiles :=  a b c
#classDirs := $(addprefix src/classes/,$(classFiles))
#classSources := $(addsuffix .cpp,$(classDirs))
#src := $(addprefix ../../,$(classSources))
#objs := $(addsuffix .o,$(addprefix build/objs/,$(classFiles)))

all:
	mkdir -p build build/objs
	#cd build/objs && $(foreach file,$(src),$(command) -c $(file);) $(command) -c ../../src/main.cpp
	#$(command) -o build/main $(objs) build/objs/main.o
	cd build/objs && $(command) -c ../../src/main.cpp
	$(command) -o build/main build/objs/main.o

run: all
	build/main
