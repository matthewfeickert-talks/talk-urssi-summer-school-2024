makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
dir_path := $(dir $(makefile_path))
current_dir := $(notdir $(patsubst %/,%,$(dir_path)))

default: decktape

all: decktape

decktape: talk.md
	docker run --rm -v ${dir_path}:/slides/ astefanutti/decktape:3.7.0 \
	https://matthewfeickert-talks.github.io/${current_dir}/index.html \
	talk.pdf
	cp talk.pdf feickert_odsl-forum_2023-09-08.pdf

decktape_local: talk.md
	docker run --rm -t --net=host -v ${dir_path}:/slides astefanutti/decktape:3.7.0 \
	http://localhost:8001 \
	localhost_draft.pdf
