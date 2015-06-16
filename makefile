
SAMPLIB = jsamp.jar
JARFILE = vovr.jar
SRCFILES = TableClient.java
ICON = goggles2.png
BUILDDIR = classes

build: vovr.jar

$(SAMPLIB):
	curl http://www.star.bris.ac.uk/~mbt/jsamp/jsamp-1.3.5.jar >$@

vovr.jar: $(SAMPLIB) $(SRCFILES) $(ICON)
	rm -rf $(BUILDDIR)
	mkdir $(BUILDDIR)
	mkdir $(BUILDDIR)/img
	javac -d $(BUILDDIR) -classpath $(SAMPLIB) $(SRCFILES) \
        && cp $(ICON) $(BUILDDIR)/img/ \
        && cd $(BUILDDIR) \
        && jar cf ../$@ . \

clean:
	rm -f $(JARFILE)
	rm -rf $(BUILDDIR)

run: $(SAMPLIB) $(JARFILE)
	java -classpath $(SAMPLIB):$(JARFILE) TableClient

