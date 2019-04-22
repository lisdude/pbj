VERSION="z6"

SOURCES=pbj.z6
ZFILES=$(SOURCES:.zil=.$(VERSION))

all: $(ZFILES)

%.zap: %.zil
	zilf $<

%.z6: %.zap
	zapf $<

.PHONY: all

clean:
	rm *.$(VERSION) ; rm *.zap
