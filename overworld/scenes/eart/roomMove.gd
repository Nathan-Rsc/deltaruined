extends KinematicBody2D

var direction = "down"

export var playerId = 1
var playerInput = Vector2()
var playerXInput = 0.0
var playerYInput = 0.0
var playerVelocity = Vector2()
var speedScalar = 200

var do = null


var doing = false
var doable = false


var recording = true
var recordX = []
var recordY = []
var recordSize = 256

var moving = false








func _ready():
	# partyMember playerInput to source from
	recordX.resize(recordSize)
	recordY.resize(recordSize)
	var iterater = 0
	while iterater < recordSize - 1:
		recordX[iterater] = position.x
		recordY[iterater] = position.y
		iterater += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if doing == false:
		playerXInput = Input.get_action_strength("move_right" + String(playerId)) - Input.get_action_strength("move_left" + String(playerId))
		playerYInput = Input.get_action_strength("move_down" + String(playerId)) - Input.get_action_strength("move_up" + String(playerId))
		playerInput = Vector2(playerXInput, playerYInput)
		playerVelocity = playerInput * speedScalar
		
		playerVelocity = move_and_slide(playerVelocity)

		if playerInput.x > 0 and playerInput.y > 0:
			if playerInput.x == playerInput.y:
				direction = "downRight"
			if playerInput.x > playerInput.y:
				direction = "right"
			if playerInput.x < playerInput.y:
				direction = "down"
		if playerInput.x < 0 and playerInput.y > 0:
			if -playerInput.x == playerInput.y:
				direction = "downLeft"
			if -playerInput.x > playerInput.y:
				direction = "left"
			if -playerInput.x < playerInput.y:
				direction = "down"
		if playerInput.x < 0 and playerInput.y < 0:
			if -playerInput.x == -playerInput.y:
				direction = "upLeft"
			if -playerInput.x > -playerInput.y:
				direction = "left"
			if -playerInput.x < -playerInput.y:
				direction = "up"
		if playerInput.x > 0 and playerInput.y < 0:
			if playerInput.x == -playerInput.y:
				direction = "upRight"
			if playerInput.x > -playerInput.y:
				direction = "right"
			if playerInput.x < -playerInput.y:
				direction = "up"
		if playerInput.x > 0 and playerInput.y == 0:
			direction = "right"
		if playerInput.x < 0 and playerInput.y == 0:
			direction = "left"
		if playerInput.x == 0 and playerInput.y > 0:
			direction = "down"
		if playerInput.x == 0 and playerInput.y < 0:
			direction = "up"

		
		$PlayerSprite.play(direction)


	match direction:
		"down":
			$interact.position = Vector2(0,32)
		"downRight":
			$interact.position = Vector2(16,32)
		"downLeft":
			$interact.position = Vector2(-16,32)
		"right":
			$interact.position = Vector2(16,16)
		"left":
			$interact.position = Vector2(-16,16)
		"up":
			$interact.position = Vector2(0,0)
		"upRight":
			$interact.position = Vector2(16,0)
		"upLeft":
			$interact.position = Vector2(-16,0)

	if do != null and Input.is_action_just_pressed("accept" + String(playerId)) and doing == false:
		doing = true
		if do.name.find("Player") == -1:
			do.readyTextStuff()
		else:
			do.get_node("textRun").readyTextStuff()




	if playerVelocity != Vector2(0,0):
		moving = true
	else:
		moving = false


	if recording == true:
		if position.x != recordX[0] or position.y != recordY[0]:
			var shift = recordSize - 2
			while shift > 0:
				recordX[shift] = recordX[shift - 1]
				recordY[shift] = recordY[shift - 1]
				shift -= 1
			recordX[0] = position.x
			recordY[0] = position.y




func _on_interact_body_entered(body):
	if body.name != "Player":
		do = body
		doable = true


func _on_interact_body_exited(body):
	if body.name != "Player":
		do = null
		doable = false
