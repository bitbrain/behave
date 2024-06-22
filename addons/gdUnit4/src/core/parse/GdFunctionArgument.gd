class_name GdFunctionArgument
extends RefCounted


var _cleanup_leading_spaces := RegEx.create_from_string("(?m)^[ \t]+")
var _fix_comma_space := RegEx.create_from_string(""", {0,}\t{0,}(?=(?:[^"]*"[^"]*")*[^"]*$)(?!\\s)""")
var _name: String
var _type: int
var _default_value :Variant
var _parameter_sets :PackedStringArray = []

const UNDEFINED :Variant = "<-NO_ARG->"
const ARG_PARAMETERIZED_TEST := "test_parameters"


func _init(p_name :String, p_type :int = TYPE_MAX, value :Variant = UNDEFINED) -> void:
	_name = p_name
	_type = p_type
	if p_name == ARG_PARAMETERIZED_TEST:
		_parameter_sets = _parse_parameter_set(value)
	_default_value = value


func name() -> String:
	return _name


func default() -> Variant:
	return GodotVersionFixures.convert(_default_value, _type)


func value_as_string() -> String:
	if has_default():
		return str(_default_value)
	return ""


func type() -> int:
	return _type


func has_default() -> bool:
	return not is_same(_default_value, UNDEFINED)


func is_parameter_set() -> bool:
	return _name == ARG_PARAMETERIZED_TEST


func parameter_sets() -> PackedStringArray:
	return _parameter_sets


static func get_parameter_set(parameters :Array[GdFunctionArgument]) -> GdFunctionArgument:
	for current in parameters:
		if current != null and current.is_parameter_set():
			return current
	return null


func _to_string() -> String:
	var s := _name
	if _type != TYPE_MAX:
		s += ":" + GdObjects.type_as_string(_type)
	if _default_value != UNDEFINED:
		s += "=" + str(_default_value)
	return s


func _parse_parameter_set(input :String) -> PackedStringArray:
	if not input.contains("["):
		return []

	input = _cleanup_leading_spaces.sub(input, "", true)
	input = input.replace("\n", "").strip_edges().trim_prefix("[").trim_suffix("]").trim_prefix("]")
	var single_quote := false
	var double_quote := false
	var array_end := 0
	var current_index := 0
	var output :PackedStringArray = []
	var buf := input.to_utf8_buffer()
	var collected_characters: = PackedByteArray()
	var matched :bool = false

	for c in buf:
		current_index += 1
		matched = current_index == buf.size()
		collected_characters.push_back(c)

		match c:
			# ' ': ignore spaces between array elements
			32: if array_end == 0 and (not double_quote and not single_quote):
					collected_characters.remove_at(collected_characters.size()-1)
			# ',': step over array element seperator ','
			44: if array_end == 0:
					matched = true
					collected_characters.remove_at(collected_characters.size()-1)
			# '`':
			39: single_quote = !single_quote
			# '"':
			34: if not single_quote: double_quote = !double_quote
			# '['
			91: if not double_quote and not single_quote: array_end +=1 # counts array open
			# ']'
			93: if not double_quote and not single_quote: array_end -=1 # counts array closed

		# if array closed than collect the element
		if matched:
			var parameters := _fix_comma_space.sub(collected_characters.get_string_from_utf8(), ", ", true)
			if not parameters.is_empty():
				output.append(parameters)
			collected_characters.clear()
			matched = false
	return output
