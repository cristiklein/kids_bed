all: bed.stl

%.stl: %.scad
	openscad $^ -o $@
