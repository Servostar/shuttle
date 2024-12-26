
.PHONY: shellcheck formatcheck actionlint format clean

shellcheck:
	shellcheck -x --check-sourced shuttle.sh

formatcheck:
	ls *.sh src/*.sh | xargs shfmt -d

format:
	ls *.sh src/*.sh | xargs shfmt -w

actionlint:
	ls .github/workflows/*.yml | xargs actionlint

build: build/%.min.sh:
	# Setup build environment
	mkdir build || true
	cp *.sh build/
	mkdir build/src || true
	cp src/*.sh build/src/
	# Minify scripts
	ls build/*.sh build/src/*.sh | xargs shfmt -w -mn -s
	# Inline sourced scripts
	bash -c "./scripts/inline.bash build/shuttle.sh"
	cp build/shuttle.sh build/shuttle.min.sh

clean:
	rm -rf build
