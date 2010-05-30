//
//  SandPainter.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/27/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "SandPainter.h"
#import "Util.h"
#import "Palette.h"

@implementation SandPainter

- (id) initWithSubstrate:(Substrate *)aSubstrate; 
{
	if (self = [super init]) {
		gain = random_float(0.01, 0.1);
		substrate = aSubstrate;
		palette = [Palette paletteFromFile:@"pollockShimmering.gif"];
		c = [palette randomColor];
	}
	return self;
}


- (void) renderX:(int) x Y:(int)y OX:(int)ox OY:(int) oy
{
	// modulate gain
	gain += random_float(-0.05, 0.05);
	
	float maxg = 1.0;
	if (gain < 0)
		gain = 0;
	if (gain > maxg)
		gain = maxg;
	
	// calculate grains by distance
	// TODO: do you need to use roundf()? 
	//int grains = (int) sqrtf((ox - x) * (ox - x) + (oy - y) * (oy - y));
	
	int grains = 32;
	
	// lay down grains of sand using transparent pixels
	float w = gain / (grains - 1.0);
	for (int i = 0; i < grains; i++) {
		float a = 0.1 - i / (grains * 10.0);
		FBPixel aColor = c;
		aColor.a = a * 0xFF;
		[substrate.fbPainter setColor:aColor];
		[substrate.fbPainter pointXf:ox + (x - ox) * sin(sin(i * w))
								  Yf:oy + (y - oy) * sin(sin(i * w))];
	}
} 

@end

