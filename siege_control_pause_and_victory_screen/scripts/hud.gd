extends CanvasLayer 


const HUD_BG_TEX: Texture2D = preload("res://.godot/imported/Shop_Bar.PNG-df020bfa31386a0b1bf17ae32f2fa10b.ctex") # <- change path

@onready var wave_label: Label  = $WaveLabel
@onready var timer_label: Label = $TimerLabel

# GameManager is sibling of HUD under Game
@onready var mgr: Node          = get_parent().get_node("GameManager")
@onready var break_timer: Timer = mgr.get_node("BreakTimer") as Timer

func _ready() -> void:
	layer = 100
	visible = true

	_setup_label(wave_label)
	_setup_label(timer_label)

	wave_label.text  = "Waiting for first wave..."
	timer_label.text = ""

	# connect to GameManager signals
	if not mgr.is_connected("wave_started", _on_wave_started):
		mgr.wave_started.connect(_on_wave_started)
	if not mgr.is_connected("wave_cleared", _on_wave_cleared):
		mgr.wave_cleared.connect(_on_wave_cleared)
	if not mgr.is_connected("all_waves_cleared", _on_all_done):
		mgr.all_waves_cleared.connect(_on_all_done)

func _process(_delta: float) -> void:
	if mgr == null:
		return

	# BREAK PHASE
	if break_timer and not break_timer.is_stopped():
		var current_wave = mgr.wave_idx

		if current_wave < 0:
			wave_label.text = "Break — next: Wave 1"
		else:
			wave_label.text = "Break — next: Wave %d" % int(current_wave + 2)

		timer_label.text = "Next wave in: %.1fs" % break_timer.time_left
		return

	# WAVE PHASE
	if mgr.wave_idx >= 0:
		wave_label.text = "Wave %d" % int(mgr.wave_idx + 1)
		timer_label.text = "Wave time left: %.1fs" % float(mgr.wave_time_left)

# -------- SIGNAL HANDLERS --------

func _on_wave_started(idx: int) -> void:
	wave_label.text  = "Wave %d" % (idx + 1)
	timer_label.text = "Wave time left: %.1fs" % float(mgr.wave_time_left)

func _on_wave_cleared(idx: int) -> void:
	wave_label.text = "Wave %d cleared!" % (idx + 1)
	# timer text will switch to "Next wave in..." automatically once BreakTimer starts

func _on_all_done() -> void:
	wave_label.text  = "All waves cleared!"
	timer_label.text = "You survived!"
	set_process(false) # stop updating HUD after game over

# -------- HELPERS --------

func _setup_label(lbl: Label) -> void:
	if lbl == null:
		return

	lbl.visible = true
	lbl.modulate = Color(1, 1, 1, 1)
	lbl.z_index = 1000

	# pixel font

	lbl.add_theme_font_size_override("font_size", 16)  # tweak to match your other UI

	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER

	# colors / outline (works with pixel font too)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
	lbl.add_theme_constant_override("outline_size", 2)

	# background image as stylebox
	var sb := StyleBoxTexture.new()
	sb.texture = HUD_BG_TEX
	sb.content_margin_left   = 6
	sb.content_margin_right  = 6
	sb.content_margin_top    = 2
	sb.content_margin_bottom = 2

	lbl.add_theme_stylebox_override("normal", sb)
