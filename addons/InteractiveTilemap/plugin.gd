@tool
extends EditorPlugin

var _http : HTTPRequest = null
var _version : String = ""
var _url : String = "https://raw.githubusercontent.com/Healleu/ExtendedShape/main/addons/ExtendedShape/plugin.cfg"

func _enter_tree() -> void :
	# Het plugin current version
	_version = get_plugin_version()
	
	# Request lastest plugin version in Github
	_http = HTTPRequest.new()
	call_deferred("add_child", _http)
	await _http.ready
	_http.request_completed.connect(_on_http_request_request_completed)
	_http.request(_url)
	
	add_custom_type("InteractiveTilemap", "Tilemap", preload("interactive_tilemap.gd"), null)
	print("Interactive Tilemap System initialized!")
	return


func _exit_tree() -> void :
	remove_custom_type("InteractiveTilemap")
	return

## Called when the request to the repository is completed, parses the config file and sets the newest version.
func _on_http_request_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray):
	var config = ConfigFile.new()
	var err = config.parse(body.get_string_from_ascii())
	
	if err == OK :
		var newest_version = config.get_value("plugin", "version")
		config.clear()
		if newest_version > _version :
			print("New version of ExtendedShape is available!")
			print("actual : " + _version + " / lastest : " + newest_version)
	else :
		print("Fail to get the lastest version of ExtendedShape")
	_http.call_deferred("queue_free")
	return