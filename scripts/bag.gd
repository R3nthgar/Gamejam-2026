#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

#The @tool allows code to be run in the editor
@tool
extends Node2D

@onready var bag_area_collision1: CollisionPolygon2D = $BagArea1/BagAreaCollision
@onready var bag_area_collision2: CollisionPolygon2D = $BagArea2/BagAreaCollision
@onready var bag_visual: Line2D = $BagVisual
@onready var bag_collision_inside: StaticBody2D = $BagCollisionInside
@onready var bag_outside_collision: CollisionPolygon2D = $BagCollisionOutside/BagOutsideCollision
@onready var bag_visual_inside: Polygon2D = $BagVisualInside
const one_way_collider=preload("res://scenes/one_way_collider.tscn")

var prev_points=0

#Modify points to change the number of vertices in the bag's polygons
const points=12
#Modify size to change the size of the bag
const size=10
#Modify border thickness to change the thickness of the bag
const border_thickness=2

#Changes the bags shape if number of points has been changed in the editor
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and prev_points!=points:
		prev_points=points
		change_shape()
func change_shape():
	var collision_inside_polygon=[]
	#This contains the polygon for BagCollisionInside
	var inside_polygon=[]
	#This contains the polygon for the inside of the bag
	var bag_visual_polygon=[]
	#This contains the polygon for the lines of the bag
	var bag_outside_polygon=[]
	#This contains the polygon for the outside of the bag
	
	#This runs for each point
	for i in points:
		#This gets the midpoint of each line.
		collision_inside_polygon.append(Vector2(0,size*cos(PI/points)).rotated(PI*2/points*i))
		#This gets the vertices of the polygon of the bag, minus the line thickness.
		inside_polygon.append(Vector2(0,size-border_thickness).rotated(PI*2/points*(i+0.5)))
		#This gets the vertices of the polygon of the bag, minus the half line thickness.
		bag_visual_polygon.append(Vector2(0,size-border_thickness*0.5).rotated(PI*2/points*(i+0.5)))
		#This gets the vertices of the polygon of the bag.
		bag_outside_polygon.append(Vector2(0,size).rotated(PI*2/points*(i+0.5)))
	
	#Resets the BagCollisionInside's children
	for child in bag_collision_inside.get_children():
		bag_collision_inside.remove_child(child)
	
	#Adds a worldborder for each line in the polygon, ensuring that an object can't fall out.
	for vector in collision_inside_polygon:
		var new_child=one_way_collider.instantiate()
		new_child.position=vector
		new_child.rotation=vector.angle_to_point(Vector2(0,0))-PI/2*3
		bag_collision_inside.add_child(new_child)
	
	#Sets shapes to their respective polygons
	bag_area_collision1.polygon=inside_polygon
	bag_area_collision2.polygon=bag_outside_polygon
	bag_visual_inside.polygon=bag_outside_polygon
	bag_visual.points=bag_visual_polygon
	bag_outside_collision.polygon=bag_outside_polygon
	bag_visual.width=border_thickness
func _ready() -> void:
	prev_points=points
	change_shape()
