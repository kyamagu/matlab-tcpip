# Build the matlab_tcpip package.
#
# On old Mac, specify Matlab's JRE version to compile.
#
#    JAVA_HOME=`/usr/libexec/java_home -v 1.6.0_65` make -C java/
#

CLASSPATH := .
SOURCES := $(wildcard matlab_tcpip/*.java)
TARGETS = $(patsubst %.java,%.class,$(SOURCES))
JARFILE = matlab_tcpip.jar

all: $(JARFILE)

$(JARFILE): $(TARGETS)
	jar cvf $@ matlab_tcpip
	jar i $@

%.class:%.java
	javac -cp $(CLASSPATH) $<

test: $(JARFILE)
	java -cp $(CLASSPATH):$(JARFILE)

clean:
	rm matlab_tcpip/*.class $(JARFILE)
