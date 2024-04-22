# GdUnit generated TestSuite
class_name SimpleParallelTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/beehave/nodes/composites/simple_parallel.gd"
const __count_up_action = "res://test/actions/count_up_action.gd"
const __blackboard = "res://addons/beehave/blackboard.gd"
const __tree = "res://addons/beehave/nodes/beehave_tree.gd"

var tree: BeehaveTree
var simple_parallel: SimpleParallelComposite
var action1: ActionLeaf
var action2: ActionLeaf
var actor: Node
var blackboard: Blackboard


func before_test() -> void:
	tree = auto_free(load(__tree).new())
	simple_parallel = auto_free(load(__source).new())
	action1 = auto_free(load(__count_up_action).new())
	action2 = auto_free(load(__count_up_action).new())
	actor = auto_free(Node2D.new())
	blackboard = auto_free(load(__blackboard).new())
	
	tree.add_child(simple_parallel)
	simple_parallel.add_child(action1)
	simple_parallel.add_child(action2)
	
	tree.actor = actor
	tree.blackboard = blackboard


func test_always_return_first_node_result() -> void:
	action2.status = BeehaveNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.SUCCESS)
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(0)
	
	action1.status = BeehaveNode.FAILURE
	action2.status = BeehaveNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.FAILURE)
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(0)

func test_interrupt_second_when_first_is_succeeding() -> void:
	action1.status = BeehaveNode.RUNNING
	action2.status = BeehaveNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(1)
	
	action1.status = BeehaveNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.SUCCESS)
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(0)


func test_interrupt_second_when_first_is_failing() -> void:
	action1.status = BeehaveNode.RUNNING
	action2.status = BeehaveNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(1)
	
	action1.status = BeehaveNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.FAILURE)
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(0)


func test_continue_tick_when_child_returns_failing() -> void:
	action1.status = BeehaveNode.RUNNING
	action2.status = BeehaveNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(1)
	
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(2)


func test_child_continue_tick_in_delay_mode() -> void:
	simple_parallel.delay_mode = true
	action1.status = BeehaveNode.RUNNING
	action2.status = BeehaveNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(1)
	
	action1.status = BeehaveNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)	
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(2)
	
	action2.status = BeehaveNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.SUCCESS)	
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(3)

func test_child_tick_count() -> void:
	simple_parallel.secondary_node_repeat_count = 2
	action1.status = BeehaveNode.RUNNING
	action2.status = BeehaveNode.FAILURE
	assert_that(tree.tick()).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(1)
	assert_that(simple_parallel.secondary_node_repeat_left).is_equal(1)
	
	action2.status = BeehaveNode.RUNNING
	assert_that(tree.tick()).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(2)
	assert_that(simple_parallel.secondary_node_repeat_left).is_equal(1)
	
	action2.status = BeehaveNode.SUCCESS
	assert_that(tree.tick()).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(3)
	assert_that(action2.count).is_equal(3)
	assert_that(simple_parallel.secondary_node_repeat_left).is_equal(0)

	assert_that(tree.tick()).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(4)
	assert_that(action2.count).is_equal(3)

func test_nested_simple_parallel() -> void:
	var simple_parallel2 = auto_free(load(__source).new())
	var action3 = auto_free(load(__count_up_action).new())
	simple_parallel.remove_child(action2)
	simple_parallel.add_child(simple_parallel2)
	simple_parallel2.add_child(action2)
	simple_parallel2.add_child(action3)
	
	action1.status = BeehaveNode.RUNNING
	action2.status = BeehaveNode.RUNNING
	action3.status = BeehaveNode.RUNNING
	
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	
	assert_that(action1.count).is_equal(1)
	assert_that(action2.count).is_equal(1)
	assert_that(action3.count).is_equal(1)
	
	action2.status = BeehaveNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(2)
	assert_that(action2.count).is_equal(2)
	assert_that(action3.count).is_equal(0)
	
	action3.status = BeehaveNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(3)
	assert_that(action2.count).is_equal(3)
	assert_that(action3.count).is_equal(0)
	
	action2.status = BeehaveNode.RUNNING
	action3.status = BeehaveNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.RUNNING)
	assert_that(action1.count).is_equal(4)
	assert_that(action2.count).is_equal(4)
	assert_that(action3.count).is_equal(1)
	
	action1.status = BeehaveNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BeehaveNode.SUCCESS)
	assert_that(action1.count).is_equal(5)
	assert_that(action2.count).is_equal(0)
	assert_that(action3.count).is_equal(0)
	
	simple_parallel2.remove_child(action2)
	simple_parallel2.remove_child(action3)
	simple_parallel.remove_child(simple_parallel2)
	simple_parallel.add_child(action2)
