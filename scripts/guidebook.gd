extends Control
@onready var hints: Control = $SubViewportContainer/SubViewport/Hints
@onready var recipes: Control = $SubViewportContainer/SubViewport/Recipes
@onready var starton

func switch(new: bool):
	hints.visible=new
	recipes.visible=not new
