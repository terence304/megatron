BUILD := build

CXX   := g++ 

CXX_SRC  += $(wildcard src/*.cc)

# generate all %.o files in build/%.o, every .o file will call $(BUILD)/%.o to compile
# addprefix, add "build/" prefix
# notdir, remove dir prefix
# addsufix, add .o suffix
# basename, get CXX_SRC file name
OBJECTS  = $(addprefix $(BUILD)/,$(notdir $(addsuffix .o,$(basename $(CXX_SRC)))))

CXXFLAGS += -Wall 
CXXFLAGS += -O0 
CXXFLAGS += -std=gnu++11 
CXXFLAGS += -Isrc

LDFLAGS  += 

DIRS     += $(BUILD) 

all : $(DIRS) | $(BUILD)/megatron

flash : $(BUILD)/megatron
	@./$^

debug : CXXFLAGS += -g
debug : $(DIRS) | $(BUILD)/megatron

gdb : 
	@gdb -q $(BUILD)/megatron

$(DIRS) :
	@echo Creating $(@)
	@mkdir -p $(@)

$(BUILD)/megatron : $(OBJECTS)
	@echo Linking $@
	$(CXX) $(LDFLAGS) $^ -o $@

# % means match filename without extension
$(BUILD)/%.o : src/%.cc
	@echo Compiling $<
	$(CXX) $(CXXFLAGS) -c $< -o $@

# PHONY means not files, they are commands, so always execute it, 
# don't check timestamp of file
.PHONY : clean all flash debug

clean : 
	@rm -rf $(BUILD)

