extends CharacterBody2D

@onready var attack_area_collision: CollisionShape2D = get_node("AttackArea/Collision")
@onready var animation: AnimationPlayer = get_node("Animation")
@onready var texture: Sprite2D = get_node("Textura")
@onready var aux_animation_player: AnimationPlayer = get_node("AuxAnimationPlayer")

var can_attack: bool = true
var can_die: bool = false

@export var health: int = 5
@export var move_speed: float = 256.0
@export var damage: int = 1

func _ready() -> void:
	if transition_screen.player_health != 0:
		health = transition_screen.player_health
		return
		
	transition_screen.player_health = health
	
	
func _physics_process(_delta: float) -> void:
	if( 
		can_attack == false or 
		can_die
	):
		return
		
	move()
	animate()
	attack_enemie()
	

func move() -> void:
	var direction: Vector2 = get_direction()
	velocity = direction * move_speed
	move_and_slide()
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()


func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
		attack_area_collision.position.x = 58
		
	if velocity.x < 0:
		texture.flip_h = true
		attack_area_collision.position.x = -58

	if velocity != Vector2.ZERO:
		animation.play("run")
		return
	
	animation.play("idle")
	
func attack_enemie() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		animation.play("attack")

func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack": 
			can_attack = true
		
		"death":
			transition_screen.fade_in()
			transition_screen.player_health = 0
			transition_screen.player_score = 0

func on_attack_area_body_entered(body) -> void:
	body.update_health(damage)

func update_health(value: int) -> void:
	health -= value
	
	transition_screen.player_health = health
	get_tree().call_group("level", "update_health", health)
	
	
	if health <= 0:
		can_die = true
		animation.play("death")
		
		return

	aux_animation_player.play("hit")
