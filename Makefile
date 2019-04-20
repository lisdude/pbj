VERSION="z5"

SOURCES=pbj.z5
ZFILES=$(SOURCES:.zil=.$(VERSION))

all: $(ZFILES)

%.zap: %.zil
	zilf $<

%.z5: %.zap
	zapf $<

.PHONY: all

clean:
	rm *.$(VERSION) ; rm *.zap
