# Build the matlab-tcpip package.
#
# On old Mac, specify Matlab's JRE version to compile.
#
#    JAVA_HOME=`/usr/libexec/java_home -v 1.6.0_65` make
#

MATLABDIR ?= /usr/local/matlab
MATLAB := $(MATLABDIR)/bin/matlab
MEX := $(MATLABDIR)/bin/mex
MEXEXT := $(shell $(MATLABDIR)/bin/mexext)
MEXSOURCES := $(wildcard private/*.cc)
MEXTARGETS := $(patsubst %.cc,%.$(MEXEXT),$(MEXSOURCES))
CLASSPATH := java
JAVASOURCES := $(wildcard java/matlab_tcpip/*.java)
JAVATARGETS = $(patsubst %.java,%.class,$(JAVASOURCES))
JARFILE = java/matlab_tcpip.jar

all: $(JARFILE) $(MEXTARGETS)

%.$(MEXEXT):%.cc
	$(MEX) $< -output $@

$(JARFILE): $(JAVATARGETS)
	jar cvf $@ -C java matlab_tcpip/
	jar i $@

%.class:%.java
	javac -cp $(CLASSPATH) $<

test: $(JARFILE)
	echo "run test/runServer.m" | $(MATLAB) -nodisplay & \
	echo "run test/runClient.m" | $(MATLAB) -nodisplay

clean:
	rm $(MEXTARGETS) java/matlab_tcpip/*.class $(JARFILE)
