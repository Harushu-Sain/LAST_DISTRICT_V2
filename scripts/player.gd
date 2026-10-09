extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var attack_damage: int = 10
@export var attack_range: float = 2.0
@export var attack_cooldown: float = 1.0
@export var gravity: float = 18.0

var health: float = 100.0
var _attack_cooldown_left: float = 0.0

func _physics_process(delta: float) -> void:
	if _attack_cooldown_left > 0.0:
	    _attack_cooldown_left = maxf(0.0, _attack_cooldown_left - delta)

	if not is_on_floor():
	    velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("ui_select"):
	    velocity.y = jump_velocity

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0.0, input_dir.y)
	if direction.length_squared() > 0.0:
	    direction = direction.normalized()
	    velocity.x = direction.x * speed
	    velocity.z = direction.z * speed
	else:
	    velocity.x = move_toward(velocity.x, 0.0, speed)
	    velocity.z = move_toward(velocity.z, 0.0, speed)

	if Input.is_action_just_pressed("ui_accept"):
	    _attack()

	move_and_slide()

func _attack() -> void:
	if _attack_cooldown_left > 0.0:
	    return
	_attack_cooldown_left = attack_cooldown

	var sphere := SphereShape3D.new()
	sphere.radius = attack_range
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = sphere
	query.transform = Transform3D(Basis.IDENTITY, global_position + Vector3(0.0, 0.8, -attack_range * 0.5))
	query.exclude = [get_rid()]
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var hits := get_world_3d().direct_space_state.intersect_shape(query, 16)
	for hit in hits:
	    var collider: Object = hit.get("collider")
	    if collider != null and collider.has_method("take_damage"):
	        collider.take_damage(attack_damage)

func take_damage(amount: float) -> void:
	health = maxf(0.0, health - amount)
	if health <= 0.0:
	    queue_free()
