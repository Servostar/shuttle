
.PHONY: shellcheck formatcheck actionlint format clean test

shellcheck:
	shellcheck -x --check-sourced shuttle.sh

formatcheck:
	ls *.sh lib/*.sh | xargs shfmt -d

format:
	ls *.sh lib/*.sh | xargs shfmt -w

actionlint:
	ls .github/workflows/*.yml | xargs actionlint

build: build/%.min.sh:
	# Setup build environment
	mkdir build || true
	cp *.sh build/
	mkdir build/lib || true
	cp lib/*.sh build/lib/
	# Minify scripts
	ls build/*.sh build/src/*.sh | xargs shfmt -w -mn -s
	# Inline sourced scripts
	bash -c "./scripts/inline.bash build/shuttle.sh"
	cp build/shuttle.sh build/shuttle.min.sh

test:
	shellspec

clean:
	rm -rf build
