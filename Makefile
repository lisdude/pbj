version = .z6

src = $(wildcard *.zil)
obj = $(src:.zil=.zap)
final = $(src:.zil=$(version))

%.zap: %.zil
	zilf $<

$(final): $(obj)
	zapf $<

.PHONY: clean

clean:
	rm $(final) ; rm *.zap