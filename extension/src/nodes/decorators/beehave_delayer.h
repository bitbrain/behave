/**************************************************************************/
/*  beehave_delayer.h                                                     */
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

#ifndef BEEHAVE_DELAYER_H
#define BEEHAVE_DELAYER_H

#include "nodes/decorators/beehave_decorator.h"

namespace godot {

class BeehaveDelayer : public BeehaveDecorator {
	GDCLASS(BeehaveDelayer, BeehaveDecorator);

	float wait_time = 0.0f;
	int64_t previous_time = -1;

protected:
	static void _bind_methods();

public:
	BeehaveDelayer();
	~BeehaveDelayer();

	TickStatus tick(Ref<BeehaveContext> context);
};

}

#endif//BEEHAVE_DELAYER_H