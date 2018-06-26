# This is not a standalone project
# Include it into your master meson.build via subdir()

s7cpp_src = 's7.cpp'

s7cpp_dep = meson.get_compiler('cpp').find_library('snap7')

s7cpp = static_library('s7cpp', s7cpp_src,
                       dependencies : s7cpp_dep)
