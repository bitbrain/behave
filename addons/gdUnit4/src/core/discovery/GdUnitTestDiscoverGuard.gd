extends RefCounted

# contains all tracked test suites where discovered since editor start
# key : test suite resource_path
# value: the list of discovered test case names
var _discover_cache := {}


func _init() -> void:
	# Register for discovery events to sync the cache
	GdUnitSignals.instance().gdunit_add_test_suite.connect(sync_cache)


func sync_cache(dto :GdUnitTestSuiteDto) -> void:
	var resource_path := dto.path()
	var discovered_test_cases :Array[String] = []
	for test_case in dto.test_cases():
		discovered_test_cases.append(test_case.name())
	_discover_cache[resource_path] = discovered_test_cases


func discover(script: Script) -> void:
	if GdObjects.is_test_suite(script):
		# a new test suite is discovered
		if not _discover_cache.has(script.resource_path):
			var scanner := GdUnitTestSuiteScanner.new()
			var test_suite := scanner._parse_test_suite(script)
			var dto :GdUnitTestSuiteDto = GdUnitTestSuiteDto.of(test_suite)
			GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestSuiteAdded.new(script.resource_path, test_suite.get_name(), dto))
			sync_cache(dto)
			test_suite.queue_free()
			return

		var tests_added :Array[String] = []
		var tests_removed := PackedStringArray()
		var script_test_cases := extract_test_functions(script)
		var discovered_test_cases :Array[String] = _discover_cache.get(script.resource_path, [] as Array[String])

		# first detect removed/renamed tests
		for test_case in discovered_test_cases:
			if not script_test_cases.has(test_case):
				tests_removed.append(test_case)
		# second detect new added tests
		for test_case in script_test_cases:
			if not discovered_test_cases.has(test_case):
				tests_added.append(test_case)

		# finally notify changes to the inspector
		if not tests_removed.is_empty() or not tests_added.is_empty():
			var scanner := GdUnitTestSuiteScanner.new()
			var test_suite := scanner._parse_test_suite(script)
			var suite_name := test_suite.get_name()

			# emit deleted tests
			for test_name in tests_removed:
				discovered_test_cases.erase(test_name)
				GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestRemoved.new(script.resource_path, suite_name, test_name))

			# emit new discovered tests
			for test_name in tests_added:
				discovered_test_cases.append(test_name)
				var test_case := test_suite.find_child(test_name, false, false)
				var dto := GdUnitTestCaseDto.new()
				dto = dto.deserialize(dto.serialize(test_case))
				GdUnitSignals.instance().gdunit_event.emit(GdUnitEventTestDiscoverTestAdded.new(script.resource_path, suite_name, dto))
			# update the cache
			_discover_cache[script.resource_path] = discovered_test_cases
			test_suite.queue_free()


func extract_test_functions(script :Script) -> PackedStringArray:
	return script.get_script_method_list()\
		.map(map_func_names)\
		.filter(filter_test_cases)


func map_func_names(method_info :Dictionary) -> String:
	return method_info["name"]


func filter_test_cases(value :String) -> bool:
	return value.begins_with("test_")


func filter_by_test_cases(method_info :Dictionary, value :String) -> bool:
	return method_info["name"] == value
