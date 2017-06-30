BUILD := build

CXX   := g++ 

CXX_SRC  += $(wildcard src/*.cc)

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

$(BUILD)/%.o : src/%.cc
	@echo Compiling $<
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY : clean all flash debug

clean : 
	@rm -rf $(BUILD)

