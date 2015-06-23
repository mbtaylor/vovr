
SAMPLIB = jsamp.jar
STIL = stil.jar
JARFILE = vovr.jar
SRCFILES = TableClient.java
ICON = goggles2.png
BUILDDIR = classes

build: vovr.jar

$(SAMPLIB):
	curl http://www.star.bris.ac.uk/~mbt/jsamp/jsamp-1.3.5.jar >$@

$(STIL):
	curl http://www.star.bris.ac.uk/~mbt/stil/stil.jar >$@

vovr.jar: $(SAMPLIB) $(STIL) $(SRCFILES) $(ICON)
	rm -rf $(BUILDDIR)
	mkdir $(BUILDDIR)
	javac -d $(BUILDDIR) -classpath $(SAMPLIB):$(STIL) $(SRCFILES) \
        && cp $(ICON) $(BUILDDIR)/ \
        && cd $(BUILDDIR) \
        && jar cf ../$@ . \

clean:
	rm -f $(JARFILE)
	rm -rf $(BUILDDIR)

run: $(SAMPLIB) $(STIL) $(JARFILE)
	java -classpath $(SAMPLIB):$(STIL):$(JARFILE) TableClient

