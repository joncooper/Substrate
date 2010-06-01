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
	return (upper - lower) * ((float) random() / RAND_MAX) + lower;
}

static inline int random_int(int lower, int upper)
{ 
	int ret = random() % ((upper - lower) + lower);
	return ret;
}