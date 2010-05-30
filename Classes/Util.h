/*
 *  Util.h
 *  Substrate
 *
 *  Created by Jonathan Cooper on 5/29/10.
 *  Copyright 2010 Jon Cooper. All rights reserved.
 *
 */

static inline float random_float(float lower, float upper) 
{
	float ret = fmodf((float) random(), (upper - lower)) + lower;
	return ret;
}

static inline int random_int(int lower, int upper)
{ 
	int ret = random() % ((upper - lower) + lower);
	return ret;
}