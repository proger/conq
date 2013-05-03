
run:
	cabal build
	open http://localhost:5555 &
	dist/build/conq/conq  +RTS -sstderr
