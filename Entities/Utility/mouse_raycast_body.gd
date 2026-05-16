extends StaticBody3D



@export var parent : Node




func clicked():
	if parent:
		parent.clicked()
