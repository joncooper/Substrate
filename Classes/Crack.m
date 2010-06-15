//
//  Crack.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/28/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "Crack.h"
#import "Util.h"

@implementation Crack

@synthesize substrate;

- (id) initWithSubstrate:(Substrate *)theSubstrate
{
	substrate = theSubstrate;
	dimx = [substrate.fbPainter.fb getWidth];
	dimy = [substrate.fbPainter.fb getHeight];
	sandPainter = [[SandPainter alloc] initWithSubstrate:substrate];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	crack_divergence_from_perpendicular = [defaults integerForKey:@"crack_divergence_from_perpendicular"];
	allow_curvature = [defaults boolForKey:@"allow_curvature"];
	curvature_probability = [defaults floatForKey:@"curvature_probability"];
	curvature_rate = [defaults floatForKey:@"curvature_rate"];
	antialias = YES;

	[self findStart];
	return self;
}

- (void) dealloc 
{
	[sandPainter dealloc];
	[super dealloc];
}

- (void) findStart
{
	// pick random point
	int px = 0;
	int py = 0;
	
	// shift until crack is found
	BOOL found = false;
	int timeout = 0;
	while ((!found) || (timeout++ > 1000)) {
		px = random() % dimx;
		py = random() % dimy;
		if (substrate.cgrid[py * dimx + px] < 10000) {
			found = YES;
		}
	}
	
	if (found) {
		// start crack perpendicular to the one we just found
		int crackAngle = substrate.cgrid[py * dimx + px];
		int crackRandomness = random_int(-crack_divergence_from_perpendicular, crack_divergence_from_perpendicular);
		if ((random() % 100) < 50) {
			crackAngle -= 90 + crackRandomness;
		} else {
			crackAngle += 90 + crackRandomness;
		}
		[self startCrackX:px Y:py Angle:crackAngle];
	} else {
		// We timed out.
	}
}

- (void) startCrackX:(int)cx Y:(int)cy Angle:(int)ca
{
	x = cx;
	y = cy;
	// t = ca;
	t = fmodf(ca, 360.0); // %360
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	allow_curvature = [defaults boolForKey:@"allow_curvature"];
	curvature_probability = [defaults floatForKey:@"curvature_probability"];
	curvature_rate = [defaults floatForKey:@"curvature_rate"];
	
	if (allow_curvature) 
	{
		if (random_float(0.0, 1.0) >= (1.0 - curvature_probability))
			curvature = random_float((curvature_rate / 4.0), curvature_rate);
	}
	else {
		curvature = 0.0;
	}
	
	// This constant adjusts spacing from the crack point. It's not magic otherwise.
	x += 0.61 * cos(t * M_PI/180);
	y += 0.61 * sin(t * M_PI/180);
}

- (void) regionColor
{	
	// start checking one step away
	float rx = x;
	float ry = y;
	BOOL openSpace = YES;
	
	// find extents of open space
	while (openSpace) {
		// move perpendicular to crack
		rx += 0.81 * sin(t * (M_PI/180));
		ry -= 0.81 * cos(t * (M_PI/180));
		int cx = (int) rx;
		int cy = (int) ry;
		if ((cx >= 0) && (cx < dimx) && (cy >= 0) && (cy < dimy)) {
			// safe to check
			if (substrate.cgrid[cy * dimx + cx] > 10000) {
				// space is open
			} else {
				openSpace = NO;
			}
		} else {
			openSpace = NO;
		}
	}

	// Bounds check.
	if ((rx < 0) || (rx >= (dimx - 1)) || (ry < 0) || (ry >= (dimy - 1)))
		return;
	
	[sandPainter renderX:rx Y:ry OX:x OY:y];
}
		
- (void) move
{
	if (t >= 180.0)
		t += curvature;
	else 
		t -= curvature;
	
	if (random_float(0.0, 1.0) > 0.95)
		curvature *= 1.005;
	
	// continue cracking; this constant adjusts the spacing of points along the crack
	x += 0.42 * cos(t * M_PI/180);
	y += 0.42 * sin(t * M_PI/180);
	
	if ((x >= dimx) || (y >= dimy) || (y < 0) || (x < 0)) {
		[self findStart];
	}
	
	// current location
	float z = 0.33;
	float fx = fmax(x + random_float(-z, z), 0);
	float fy = fmax(y + random_float(-z, z), 0);
	int cx = (int) (fx); // add fuzz
	int cy = (int) (fy);

	// draw sand painter
	[self regionColor];
	
	// bound check (sic)
	if ((cx >= 0) && (cx < dimx) && (cy >= 0) && (cy < dimy)) 
	{
		[substrate.fbPainter setColor:MakeFBPixel(0.0, 0.0, 0.0, 0.85)]; // 0xD8 ?
		
		if (antialias) {
			[substrate.fbPainter antialiasedPointX:fx Y:fy];
		}
		else {
			[substrate.fbPainter pointX:x Y:y];
		}

		
		// [substrate.fbPainter pointXf:fmax(x + random_float(-z, z), 0)
		//						  Yf:fmax(y + random_float(-z, z), 0)]
		
		// safe to check
		if ((substrate.cgrid[cy * dimx + cx] > 10000) || (abs(substrate.cgrid[cy * dimx + cx] - t) < 5)) 
		{
			// continue cracking
			substrate.cgrid[cy * dimx + cx] = (int) t;
		}
		else if (abs(substrate.cgrid[cy * dimx + cx] - t) > 2) {
			// we encountered another crack (not self), stop cracking
			// NSLog(@"Crack -move: encountered a crack");
			[self findStart];
		}
	}
	else {
		// out of bounds, stop cracking
		// NSLog(@"Crack -move: out of bounds");
		[self findStart];;
	}
}


@end
