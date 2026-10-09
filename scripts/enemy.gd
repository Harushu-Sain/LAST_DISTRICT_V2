extends CharacterBody3D

@export var speed: float = 2.0
@export var detection_range: float = 10.0
@export var contact_damage_per_second: float = 10.0

var target: Node3D
var health: float = 50.0
var _damage_cooldown: float = 0.0

func _physics_process(delta: float) -> void:
	if _damage_cooldown > 0.0:
	    _damage_cooldown = maxf(0.0, _damage_cooldown - delta)

	if not is_instance_valid(target):
	    target = null
	    var players := get_tree().get_nodes_in_group("player")
	    if not players.is_empty():
	        var candidate := players[0] as Node3D
	        if global_position.distance_to(candidate.global_position) <= detection_range:
	            target = candidate

	if not is_instance_valid(target):
	    velocity.x = move_toward(velocity.x, 0.0, speed)
	    velocity.z = move_toward(velocity.z, 0.0, speed)
	    if not is_on_floor():
	        velocity.y -= 18.0 * delta
	    move_and_slide()
	    return

	var offset := target.global_position - global_position
	offset.y = 0.0
	if offset.length() > 1.2:
	    var direction := offset.normalized()
	    velocity.x = direction.x * speed
	    velocity.z = direction.z * speed
	else:
	    velocity.x = 0.0
	    velocity.z = 0.0
	    if _damage_cooldown <= 0.0 and target.has_method("take_damage"):
	        target.take_damage(contact_damage_per_second)
	        _damage_cooldown = 1.0

	if not is_on_floor():
	    velocity.y -= 18.0 * delta
	move_and_slide()

func take_damage(amount: float) -> void:
	health = maxf(0.0, health - amount)
	if health <= 0.0:
	    queue_free()
