
LIBNAME         = S7-cpp-for-Snap7

SOURCEFILES_LIST = \
	s7.cpp

CXX            ?= g++
LINK.a          = ar $(ARFLAGS) $@ $%
CXXSTD          = -std=c++98

OPTIMIZED       = -O2

# For trivial projects, where this is not recursively called
OBJDIR         ?= .

# common flags (common for C and C++ compiler)
CCFLAGS        += $(ARCHITECTURE) -g -DDMSG -D_REENTRANT -Wall -Wextra -Wshadow
CCFLAGS        += $(OPTIMIZED) $(DEBUG) $(POSINDEPCODE)

# C++ compiler flags
CXXFLAGS       += $(CXXSTD)

# Does the user want more detailed build output?
ifneq (${V},1)
VERBOSE_DO=@
else
VERBOSE_DO=
endif

ALLTHINGS       = $(OBJDIR)/$(LIBNAME).a

OBJECTS         = $(patsubst %.cpp,$(OBJDIR)/%.o,$(patsubst %.cc,$(OBJDIR)/%.o,$(SOURCEFILES_LIST)))
DEPENDS         = $(OBJECTS:%.o=%.d)

all: $(OBJDIR) $(ALLTHINGS)

-include $(DEPENDS)

$(OBJDIR)/%.o : %.cpp
	@echo "CXX   $(subst $(OBJDIR)/,,$<)"
	$(VERBOSE_DO)$(CXX) $(CPPFLAGS) $(CCFLAGS) $(CXXFLAGS) -MMD -c $< -o $@

$(OBJDIR)/$(LIBNAME).a: $(OBJECTS)
	@echo "AR    $@"
	$(VERBOSE_DO)$(LINK.a) $^ > /dev/null 2>&1

$(OBJDIR):
	@test -d $@ || echo "MKDIR $@" && mkdir -p $@

.PHONY: clean
clean:
	@echo "RM    $(subst $(OBJDIR)/,,$(OBJECTS))"
	@rm -f $(OBJECTS)
	@echo "RM    $(subst $(OBJDIR)/,,$(ALLTHINGS))"
	@rm -f $(ALLTHINGS)
	@echo "RM    $(subst $(OBJDIR)/,,$(DEPENDS))"
	@rm -f $(DEPENDS)
