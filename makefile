
SAMPLIB = jsamp.jar
JARFILE = vovr.jar
SRCFILES = TableClient.java
BUILDDIR = classes

build: vovr.jar

$(SAMPLIB):
	curl http://www.star.bris.ac.uk/~mbt/jsamp/jsamp-1.3.5.jar >$@

vovr.jar: $(SAMPLIB) $(SRCFILES)
	rm -rf $(BUILDDIR)
	mkdir $(BUILDDIR)
	javac -d $(BUILDDIR) -classpath $(SAMPLIB) $(SRCFILES) \
        && cd $(BUILDDIR) \
        && jar cf ../$@ .

clean:
	rm -f $(JARFILE)
	rm -rf $(BUILDDIR)

run: $(SAMPLIB) $(JARFILE)
	java -classpath $(SAMPLIB):$(JARFILE) TableClient

