
pid$target::getGCStats:entry
{
}

HaskellEvent$target:::run-thread
{
	trace(arg1)
}

HaskellEvent$target:::thread-label
{
	printf("%d %s", arg1, copyinstr(arg2));
}
