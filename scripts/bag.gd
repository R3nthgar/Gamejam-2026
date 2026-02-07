@tool
extends Node2D
@onready var bag_area_collision: CollisionPolygon2D = $BagArea/BagAreaCollision
@onready var bag_visual: Line2D = $BagVisual
@onready var bag_collision_inside: StaticBody2D = $BagCollisionInside
@onready var bag_outside_collision: CollisionPolygon2D = $BagCollisionOutside/BagOutsideCollision
@onready var bag_visual_inside: Polygon2D = $BagVisualInside
const one_way_collider=preload("res://scenes/one_way_collider.tscn")
const points=12
const size=10
const border_thickness=2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var polygon1=[]
	var polygon2=[]
	var polygon3=[]
	var polygon4=[]
	for i in points:
		polygon1.append(Vector2(0,size-border_thickness).rotated(PI*2/points*i))
		polygon2.append(Vector2(0,size-border_thickness).rotated(PI*2/points*(i+0.5)))
		polygon3.append(Vector2(0,size-border_thickness*0.5).rotated(PI*2/points*(i+0.5)))
		polygon4.append(Vector2(0,size).rotated(PI*2/points*(i+0.5)))
	for vector in polygon1:
		var new_child=one_way_collider.instantiate()
		new_child.position=vector
		new_child.rotation=vector.angle_to_point(Vector2(0,0))-PI/2*3
		bag_collision_inside.add_child(new_child)
	bag_area_collision.polygon=polygon2
	bag_visual_inside.polygon=polygon2
	bag_visual.points=polygon3
	bag_outside_collision.polygon=polygon4
	bag_visual.width=border_thickness
