/**************************************************************************/
/*  beehave_selector.cpp                                                  */
/**************************************************************************/
/*                         This file is part of:                          */
/*                               BEEHAVE                                  */
/*                      https://bitbra.in/beehave                         */
/**************************************************************************/
/* Copyright (c) 2024-present Beehave Contributors.                       */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

#include "beehave_selector.h"

using namespace godot;

BeehaveSelector::BeehaveSelector() {

}

BeehaveSelector::~BeehaveSelector() {

}

void BeehaveSelector::_bind_methods() {

}

BeehaveTickStatus BeehaveSelector::tick(Ref<BeehaveContext> context) {
	TypedArray<Node> children = get_children();
	for (int i = 0; i < children.size(); ++i) {
		if (i < last_execution_index) {
			// skip everything that was executed already
			continue;
		}
		BeehaveTreeNode *child = cast_node(Object::cast_to<Node>(children[i]));
		if (child == nullptr) {
			// skip anything that is not a valid beehave node
			continue;
		}
		BeehaveTickStatus response = child->tick(context);

		switch (response) {
			case SUCCESS:
				// TODO: introduce after_run mechanism
				return SUCCESS;
			case FAILURE:
				++last_execution_index;
				break;
			case RUNNING:
				return RUNNING;
		}
	}
	return BeehaveTickStatus::FAILURE;
}