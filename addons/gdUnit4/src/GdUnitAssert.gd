## Base interface of all GdUnit asserts
class_name GdUnitAssert
extends RefCounted


## Verifies that the current value is null.
@warning_ignore("untyped_declaration")
func is_null():
	return self


## Verifies that the current value is not null.
@warning_ignore("untyped_declaration")
func is_not_null():
	return self


## Verifies that the current value is equal to expected one.
@warning_ignore("unused_parameter")
@warning_ignore("untyped_declaration")
func is_equal(expected):
	return self


## Verifies that the current value is not equal to expected one.
@warning_ignore("unused_parameter")
@warning_ignore("untyped_declaration")
func is_not_equal(expected):
	return self


@warning_ignore("untyped_declaration")
func test_fail():
	return self


## Overrides the default failure message by given custom message.
@warning_ignore("unused_parameter")
@warning_ignore("untyped_declaration")
func override_failure_message(message :String):
	return self
