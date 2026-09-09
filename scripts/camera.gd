extends Camera2D

var target: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = target.position

func get_target():
		#localiza a tag Player para a camera
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("deu ruim na localização de player")
		return #encerra o processo
	target = nodes[0] #atribui o primeiro alvo do vetor Players
