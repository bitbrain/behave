class_name GdUnitObjectInteractions
extends RefCounted


static func verify(interaction_object :Object, interactions_times :int) -> Variant:
	if not _is_mock_or_spy(interaction_object, "__verify"):
		return interaction_object
	return interaction_object.__do_verify_interactions(interactions_times)


static func verify_no_interactions(interaction_object :Object) -> GdUnitAssert:
	var __gd_assert :GdUnitAssert = ResourceLoader.load("res://addons/gdUnit4/src/asserts/GdUnitAssertImpl.gd", "GDScript", ResourceLoader.CACHE_MODE_REUSE).new("")
	if not _is_mock_or_spy(interaction_object, "__verify"):
		return __gd_assert.report_success()
	var __summary :Dictionary = interaction_object.__verify_no_interactions()
	if __summary.is_empty():
		return __gd_assert.report_success()
	return __gd_assert.report_error(GdAssertMessages.error_no_more_interactions(__summary))


static func verify_no_more_interactions(interaction_object :Object) -> GdUnitAssert:
	var __gd_assert :GdUnitAssert = ResourceLoader.load("res://addons/gdUnit4/src/asserts/GdUnitAssertImpl.gd", "GDScript", ResourceLoader.CACHE_MODE_REUSE).new("")
	if not _is_mock_or_spy(interaction_object, "__verify_no_more_interactions"):
		return __gd_assert
	var __summary :Dictionary = interaction_object.__verify_no_more_interactions()
	if __summary.is_empty():
		return __gd_assert
	return __gd_assert.report_error(GdAssertMessages.error_no_more_interactions(__summary))


static func reset(interaction_object :Object) -> Object:
	if not _is_mock_or_spy(interaction_object, "__reset"):
		return interaction_object
	interaction_object.__reset_interactions()
	return interaction_object


static func _is_mock_or_spy(interaction_object :Object, mock_function_signature :String) -> bool:
	if interaction_object is GDScript and not interaction_object.get_script().has_script_method(mock_function_signature):
		push_error("Error: You try to use a non mock or spy!")
		return false
	return true
