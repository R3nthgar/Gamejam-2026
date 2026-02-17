extends "res://scripts/destructible.gd"
func destroy(level: int):
	if level>1:
		super(level)
