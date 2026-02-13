#Documentation: docs.google.com/document/d/1kCbnpUemEP7YI1-PUrbTQ0jnLCsttjf01NY-T5T8JT0

#The @tool allows code to be run in the editor
@tool
extends Node2D

@onready var container_area_collision1: CollisionPolygon2D = $ContainerArea1/ContainerAreaCollision
@onready var container_area_collision2: CollisionPolygon2D = $ContainerArea2/ContainerAreaCollision
@onready var container_visual: Line2D = $ContainerVisual
@onready var container_collision_inside: StaticBody2D = $ContainerCollisionInside
@onready var container_outside_collision: CollisionPolygon2D = $ContainerCollisionOutside/ContainerOutsideCollision
@onready var container_visual_inside: Polygon2D = $ContainerVisualInside
@onready var container_inside_collision: CollisionPolygon2D = $ContainerCollisionInside/ContainerInsideCollision
@onready var container_alarm: RichTextLabel = $ContainerAlarm
@onready var container_collision_outside: StaticBody2D = $ContainerCollisionOutside

const one_way_collider=preload("res://scenes/one_way_collider.tscn")


#Modify points metadata to change the number of vertices in the container's polygons
var points
#Modify size metadata to change the size of the container
var size
#Modify border thickness metadata to change the thickness of the container
var border_thickness
#Only set the is_bag metadata if its the players bag
var is_bag
#Modify color metadata to change the container's color
var color
#Modify closed metadata to change whether the container has one side open or not
var closed
#Modify container size metadata to change the number of objects the container is able to hold
var container_size=0

var is_deposit=false

var container_scale_mod=0.66

#This array tracks which objects are in the container
var contained=[]
#Allows contained objects to be seen from other nodes
func get_contained():
	return contained
#Gets whether the container is full for use by other nodes
func container_full():
	return contained.size()>=container_size

#Changes the containers shape if info has been changed
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and (points!=get_meta("points") or is_bag!=get_meta("is_bag") or is_deposit!=get_meta("is_deposit") or color!=get_meta("color") or closed!=get_meta("closed") or size!=get_meta("size") or border_thickness!=get_meta("border_thickness")):
		#Sets appropriate variables
		points=get_meta("points")
		is_bag=get_meta("is_bag")
		is_deposit=get_meta("is_deposit")
		color=get_meta("color")
		closed=get_meta("closed")
		size=get_meta("size")
		border_thickness=get_meta("border_thickness")
		change_shape()
func change_shape():
	container_visual.default_color=color
	container_visual_inside.color=color
	container_visual.closed=closed
	container_inside_collision.disabled=is_bag or is_deposit
	container_collision_inside.set_collision_layer_value(4,is_bag)
	container_collision_inside.set_collision_layer_value(5,not (is_bag or is_deposit))
	container_collision_inside.set_collision_layer_value(1,not (is_deposit or is_bag))
	container_collision_inside.set_collision_layer_value(7,not (is_deposit or is_bag))
	container_collision_inside.set_collision_layer_value(9,is_deposit)
	container_visual_inside.z_index=0 if is_deposit else 1
	var collision_inside_polygon=[]
	#This contains the polygon for ContainerCollisionInside
	var inside_polygon=[]
	#This contains the polygon for the inside of the container
	var container_visual_polygon=[]
	#This contains the polygon for the lines of the container
	var container_outside_polygon=[]
	#This contains the polygon for the outside of the container
	
	#This runs for each point
	for i in points:
		#This gets the midpoint of each line if this is a bag, otherwise getting the outside points of the polygon
		if is_bag or is_deposit:
			collision_inside_polygon.append(Vector2(0,(size-border_thickness)*cos(PI/points)).rotated(PI*2/points*i))
		else:
			collision_inside_polygon.append(Vector2(0,size).rotated(PI*2/points*(i+0.5)))
		#This gets the vertices of the polygon of the container, minus the line thickness.
		inside_polygon.append(Vector2(0,size-border_thickness).rotated(PI*2/points*(i+0.5)))
		#This gets the vertices of the polygon of the container, minus half the line thickness.
		container_visual_polygon.append(Vector2(0,size-border_thickness*0.5).rotated(PI*2/points*(i+0.5)))
		#This gets the vertices of the polygon of the container.
		container_outside_polygon.append(Vector2(0,size).rotated(PI*2/points*(i+0.5)))
	if (not is_bag) and (not is_deposit):
		for i in points:
			collision_inside_polygon.append(Vector2(0,size-border_thickness).rotated(PI*2/points*(-0.5-i)))
		if closed:
			collision_inside_polygon.append(Vector2(0,size-border_thickness).rotated(PI*2/points*(-0.5)))
			collision_inside_polygon.append(Vector2(0,size).rotated(PI*2/points*(-0.5)))
	
	
	container_collision_outside.set_collision_layer_value(5,closed)
	#Resets inside border
	for child in container_collision_inside.get_children():
		if child != container_inside_collision:
			container_collision_inside.remove_child(child)
	if is_bag or is_deposit:
		container_inside_collision.polygon=[Vector2(0,0),Vector2(0,0),Vector2(0,0)]
		#Adds a worldborder for each line in the polygon, ensuring that an object can't fall out.
		for vector in collision_inside_polygon:
			var new_child=one_way_collider.instantiate()
			new_child.position=vector
			new_child.rotation=vector.angle_to_point(Vector2(0,0))-PI/2*3
			container_collision_inside.add_child(new_child)
	else:
		container_inside_collision.polygon=collision_inside_polygon
	#Sets shapes to their respective polygons
	container_area_collision1.polygon=inside_polygon
	container_area_collision2.polygon=container_outside_polygon
	container_visual_inside.polygon=container_outside_polygon
	container_visual.points=container_visual_polygon
	container_visual.width=border_thickness*cos(PI/points)
	container_outside_collision.polygon=container_outside_polygon

#Sets appropriate variables
func _ready() -> void:
	container_alarm.rotation=-rotation
	container_scale_mod=get_meta("scale_modifier")
	is_deposit=get_meta("is_deposit")
	points=get_meta("points")
	is_bag=get_meta("is_bag")
	color=get_meta("color")
	closed=get_meta("closed")
	size=get_meta("size")
	container_size=get_meta("container_size")
	border_thickness=get_meta("border_thickness")
	change_shape()

func fix_alarm():
	container_alarm.visible=contained.size()>=container_size-1
	if(contained.size()>=container_size):
		container_alarm.modulate=Color("red")
		container_collision_outside.set_collision_layer_value(2,true)
	else:
		container_alarm.modulate=Color("yellow")

#Handles objects entering the container
func _on_container_area_body_entered(body: Node2D) -> void:
	#Prevents objects from entering via glitches
	if body is collectible and (true if ((not closed) or body.get_meta("start_inside")) else body.held) and not contained.has(body) and contained.size()<container_size and not body.container:
		if body.get_meta("start_inside"):
			body.set_collision_mask_value(9,is_deposit)
			body.set_collision_mask_value(1,not is_deposit)
		#Fixes collision
		body.set_collision_mask_value(2,false)
		body.set_collision_layer_value(6,false)
		contained.append(body)
		body.set_container(self)

		#Changes size of object
		for child in body.get_children():
			child.scale*=container_scale_mod

		#Makes exclamation mark appear when container is full or close to full
		fix_alarm()

func _on_container_area_body_exited(body: Node2D) -> void:
	#Prevents objects from exiting via moving, unless the container is open
	if ((body.held if closed else true) and contained.has(body)):
		#Removes object from container
		contained.erase(body)
		body.set_collision_layer_value(6,true)
		#Changes size of object
		for child in body.get_children():
			child.scale/=container_scale_mod
		
		#Makes object properly collide
		body.set_collision_mask_value(2,true)
		
		#Makes exclamation mark disappear when container isn't close to full, and changes exclamation mark color
		fix_alarm()
		if(contained.size()<container_size):
			container_collision_outside.set_collision_layer_value(2,false)
		body.set_container(null)

func container_effect():
	pass

func _on_container_alarm_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		container_effect()
