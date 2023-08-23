all: fabric-run.ipynb

clean:
	rm example.ipynb

SNIPDIR := ../fabric-snippets
SNIPPETS := $(SNIPDIR)/fab-config.md $(SNIPDIR)/reserve-resources.md $(SNIPDIR)/configure-resources.md $(SNIPDIR)/draw-topo-detailed-labels.md $(SNIPDIR)/log-in.md $(SNIPDIR)/delete-slice.md
fabric-run.ipynb: $(SNIPPETS) intro.md exp-define.md exp-exec.md exp-analyze.md
	pandoc --wrap=none \
		-i intro.md \
		$(SNIPDIR)/fab-config.md \
		exp-define.md \
		$(SNIPDIR)/reserve-resources.md $(SNIPDIR)/configure-resources.md  \
		exp-configure.md exp-validate.md \
		$(SNIPDIR)/draw-topo-detailed-labels.md $(SNIPDIR)/log-in.md \
		exp-exec.md exp-analyze.md \
		$(SNIPDIR)/delete-slice.md \
		-o fabric-run.ipynb  
