# This is not the Makefile you were looking for.  Move along.

update: Configure\ Example\ HUD.lsl Movable\ Resizeable\ HUD.lsl
Configure\ Example\ HUD.lsl: Configure\ Example\ HUD-link.lsl
	cp "$<" "$@"

Movable\ Resizeable\ HUD.lsl: Movable\ Resizeable\ HUD-link.lsl
	cp "$<" "$@"
	
