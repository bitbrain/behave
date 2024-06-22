class_name GdUnitSignals
extends RefCounted

@warning_ignore("unused_signal")
signal gdunit_client_connected(client_id :int)
@warning_ignore("unused_signal")
signal gdunit_client_disconnected(client_id :int)
@warning_ignore("unused_signal")
signal gdunit_client_terminated()

@warning_ignore("unused_signal")
signal gdunit_event(event :GdUnitEvent)
@warning_ignore("unused_signal")
signal gdunit_event_debug(event :GdUnitEvent)
@warning_ignore("unused_signal")
signal gdunit_add_test_suite(test_suite :GdUnitTestSuiteDto)
@warning_ignore("unused_signal")
signal gdunit_message(message :String)
@warning_ignore("unused_signal")
signal gdunit_report(execution_context_id :int, report :GdUnitReport)
@warning_ignore("unused_signal")
signal gdunit_set_test_failed(is_failed :bool)
@warning_ignore("unused_signal")
signal gdunit_settings_changed(property :GdUnitProperty)

const META_KEY := "GdUnitSignals"


static func instance() -> GdUnitSignals:
	if Engine.has_meta(META_KEY):
		return Engine.get_meta(META_KEY)
	var instance_ := GdUnitSignals.new()
	Engine.set_meta(META_KEY, instance_)
	return instance_


static func dispose() -> void:
	var signals := instance()
	# cleanup connected signals
	for signal_ in signals.get_signal_list():
		for connection in signals.get_signal_connection_list(signal_["name"]):
			connection["signal"].disconnect(connection["callable"])
	signals = null
	Engine.remove_meta(META_KEY)
