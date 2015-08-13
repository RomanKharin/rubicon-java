
# specify callable Java compiler (or full path)
JAVAC := javac
# add any required compile flags
CFLAGS :=
# specify callable Python config (python-config or python3-config)
PYTHONCFG := python3-config
# set to 'yes' to avoid "_ctypes.so: undefined symbol: PyFloat_Type"
PYTHON_FIX_RTLD_GLOBAL := no
# if PYTHON_FIX_RTLD_GLOBAL set specify library name
PYTHON_FIX_RTLD_GLOBAL_NAME := libpython2.7.so

uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

ifeq ($(uname_S),Linux)
	JAVA_HOME:=$(shell sh -c 'dirname $$(dirname $$(readlink -e $$(which $(JAVAC))))')
	JAVA_PLATFORM := $(JAVA_HOME)/include/linux
	CFLAGS += -fPIC
	ifeq ($(PYTHON_FIX_RTLD_GLOBAL),yes)
		CFLAGS += -DLIBPYTHON_RTLD_GLOBAL=1 -DLIBPYTHON_RTLD_GLOBAL_NAME=$(PYTHON_FIX_RTLD_GLOBAL_NAME)
	endif
	CFLAGS += $(shell sh -c '$(PYTHONCFG) --cflags')
	SOEXT := so
	PYLDFLAGS +=  $(shell sh -c '$(PYTHONCFG) --ldflags')
endif
ifeq ($(uname_S),Darwin)
	JAVA_HOME := $(shell /usr/libexec/java_home)
	JAVA_PLATFORM := $(JAVA_HOME)/include/darwin
	SOEXT := dylib
	PYLDFLAGS += -lPython
endif

all: dist/rubicon.jar dist/librubicon.$(SOEXT) dist/test.jar

dist/rubicon.jar: org/pybee/rubicon/Python.class org/pybee/rubicon/PythonInstance.class
	mkdir -p dist
	jar -cvf dist/rubicon.jar org/pybee/rubicon/Python.class org/pybee/rubicon/PythonInstance.class

dist/test.jar: org/pybee/rubicon/test/BaseExample.class org/pybee/rubicon/test/Example.class org/pybee/rubicon/test/ICallback.class org/pybee/rubicon/test/AbstractCallback.class org/pybee/rubicon/test/Thing.class org/pybee/rubicon/test/Test.class
	mkdir -p dist
	jar -cvf dist/test.jar org/pybee/rubicon/test/*.class

dist/librubicon.$(SOEXT): jni/rubicon.o
	mkdir -p dist
	gcc -shared -o $@ $< $(PYLDFLAGS)

test: all
	java org.pybee.rubicon.test.Test

clean:
	rm -f org/pybee/rubicon/test/*.class
	rm -f org/pybee/rubicon/*.class
	rm -f jni/*.o
	rm -rf dist

%.class : %.java
	$(JAVAC) $<

%.o : %.c
	gcc -c $(CFLAGS) -Isrc -I$(JAVA_HOME)/include -I$(JAVA_PLATFORM) -o $@ $<

