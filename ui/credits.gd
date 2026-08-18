extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var progress: float = 0


func _ready() -> void:
	set_process(false)
	await get_tree().create_timer(2).timeout
	set_process(true)


func _process(delta: float) -> void:
	var vscrollbar: VScrollBar = rich_text_label.get_v_scroll_bar()
	progress += delta * 60
	vscrollbar.value = progress
	
	if progress > vscrollbar.value + 10:
		LevelManager.go_to_main_menu()
