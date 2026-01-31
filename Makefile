IMAGE := radix-kerko
PORT := 10000

build:
	docker build -t $(IMAGE) .

sync:
	docker run --rm \
  	-v $$PWD/instance:/kerkoapp/instance \
  	$(IMAGE) \
  	sh -lc 'flask kerko sync'

run:
	docker run --rm \
		-e PORT=$(PORT) \
		-p $(PORT):$(PORT) \
		-v $$PWD/instance:/kerkoapp/instance \
		$(IMAGE)
