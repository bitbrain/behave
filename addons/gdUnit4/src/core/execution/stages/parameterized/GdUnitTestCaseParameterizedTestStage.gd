## The parameterized test case execution stage.[br]
class_name GdUnitTestCaseParamaterizedTestStage
extends IGdUnitExecutionStage

var _stage_before: IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new()
var _stage_after: IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new()


## Executes a parameterized test case.[br]
## It executes synchronized following stages[br]
##  -> test_case( <test_parameters> ) [br]
func _execute(context: GdUnitExecutionContext) -> void:
	var test_case := context.test_case
	var test_parameter_index := test_case.test_parameter_index()
	var is_fail := false
	var is_error := false
	var failing_index := 0
	var parameter_set_resolver := test_case.parameter_set_resolver()
	var test_names := parameter_set_resolver.build_test_case_names(test_case)

	# if all parameter sets has static values we can preload and reuse it for better performance
	var parameter_sets :Array = []
	if parameter_set_resolver.is_parameter_sets_static():
		parameter_sets = parameter_set_resolver.load_parameter_sets(test_case, true)

	for parameter_set_index in test_names.size():
		# is test_parameter_index is set, we run this parameterized test only
		if test_parameter_index != -1 and test_parameter_index != parameter_set_index:
			continue
		var current_test_case_name := test_names[parameter_set_index]
		_stage_before.set_test_name(current_test_case_name)
		_stage_after.set_test_name(current_test_case_name)

		var test_context := GdUnitExecutionContext.of(context)
		await _stage_before.execute(test_context)
		var current_parameter_set :Array
		if parameter_set_resolver.is_parameter_set_static(parameter_set_index):
			current_parameter_set = parameter_sets[parameter_set_index]
		else:
			current_parameter_set = _load_parameter_set(context, parameter_set_index)
		if not test_case.is_interupted():
			await test_case.execute_paramaterized(current_parameter_set)
		await _stage_after.execute(test_context)
		# we need to clean up the reports here so they are not reported twice
		is_fail = is_fail or test_context.count_failures(false) > 0
		is_error = is_error or test_context.count_errors(false) > 0
		failing_index = parameter_set_index - 1
		test_context.reports().clear()
		if test_case.is_interupted():
			break
	# add report to parent execution context if failed or an error is found
	if is_fail:
		context.reports().append(GdUnitReport.new().create(GdUnitReport.FAILURE, test_case.line_number(), "Test failed at parameterized index %d." % failing_index))
	if is_error:
		context.reports().append(GdUnitReport.new().create(GdUnitReport.ABORT, test_case.line_number(), "Test aborted at parameterized index %d." % failing_index))
	await context.gc()


func _load_parameter_set(context: GdUnitExecutionContext, parameter_set_index: int) -> Array:
	var test_case := context.test_case
	var test_suite := context.test_suite
	# we need to exchange temporary for parameter resolving the execution context
	# this is necessary because of possible usage of `auto_free` and needs to run in the parent execution context
	var save_execution_context: GdUnitExecutionContext = test_suite.__execution_context
	context.set_active()
	var parameters := test_case.load_parameter_sets()
	# restore the original execution context and restart the orphan monitor to get new instances into account
	save_execution_context.set_active()
	save_execution_context.orphan_monitor_start()
	return parameters[parameter_set_index]


func set_debug_mode(debug_mode: bool=false) -> void:
	super.set_debug_mode(debug_mode)
	_stage_before.set_debug_mode(debug_mode)
	_stage_after.set_debug_mode(debug_mode)
