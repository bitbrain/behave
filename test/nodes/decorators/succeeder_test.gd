# GdUnit generated TestSuite
class_name SucceederTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/beehave/nodes/decorators/succeeder.gd"
const __action = "res://test/actions/count_up_action.gd"
const __tree = "res://addons/beehave/nodes/beehave_tree.gd"
const __blackboard = "res://addons/beehave/blackboard.gd"

var tree: BeehaveTree
var action: ActionLeaf
var succeeder: AlwaysSucceedDecorator


func before_test() -> void:
	tree = auto_free(load(__tree).new())
	action = auto_free(load(__action).new())
	succeeder = auto_free(load(__source).new())

	var actor = auto_free(Node2D.new())
	var blackboard = auto_free(load(__blackboard).new())

	tree.add_child(succeeder)
	succeeder.add_child(action)

	tree.actor = actor
	tree.blackboard = blackboard


func test_tick() -> void:
	action.status = BeehaveNode.FAILURE
	assert_that(tree.tick()).is_equal(BeehaveNode.SUCCESS)


func test_clear_running_child_after_run() -> void:
	action.status = BeehaveNode.RUNNING
	tree.tick()
	assert_that(succeeder.running_child).is_equal(action)
	action.status = BeehaveNode.SUCCESS
	tree.tick()
	assert_that(succeeder.running_child).is_equal(null)
