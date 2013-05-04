PROC= conq/conq
EKG = localhost:5555

default: mux

run:
	cabal build
	dist/build/$(PROC) +RTS -sstderr -lsu

ekg:
	open http://$(EKG)

dtrace:
	sudo dtrace -p $(shell pgrep -f $(PROC)) -s rts.d

TMUX_SESSION= conq
mux: kill-mux
	tmux new-session -s $(TMUX_SESSION) \; \
		set set-remain-on-exit on \; \
		bind-key C-d kill-session \; \
		new-window -n run 'make run' \; \
		new-window -n dtrace 'sleep 3 && make dtrace'

kill-mux:
	-pkill -f $(PROC)
	-tmux kill-session -t $(TMUX_SESSION)
