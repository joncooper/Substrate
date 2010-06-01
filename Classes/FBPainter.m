//
//  FBPainter.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/27/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "FBPainter.h"
#import <Foundation/Foundation.h>
#import "Util.h"

@implementation FBPainter

@synthesize fb;

- (void) setColor:(FBPixel)color
{
	currentColor = color;
}

// A background color is always opaque. So we are going to blow away any alpha.
//
- (void) setBackgroundColor:(FBPixel) color;
{
	color.a = 1.0;
	[self setColor:color];
	
	int width = [fb getWidth];
	int height = [fb getHeight];
	
	for (int x = 0; x < width; x++)
		for (int y = 0; y < height; y++)
			[fb setPixelAtX:x andY:y to:currentColor];
}

// I assume that pixels are going to come in not premultiplied, because that's how I think of colors.
// If we used setBackgroundColor we are drawing onto a surface with an alpha of 1.0.
// 
- (void) pointX:(float)x Y:(float)y
{
	// Consider adding antialiasing, but for now, round.
	int rx = roundf(x);
	int ry = roundf(y);
	
	// Bounds check
	if ((rx < 0) || (rx >= [fb getWidth]) || (ry < 0) || (ry >= [fb getHeight]))
		return;
	
	FBPixel existingPixel = [fb getPixelAtX:rx andY:ry];
	FBPixel newPixel;
	
	// Blend into something with an alpha of 1.0. i.e. the FB itself is always alpha 1.
	newPixel.r = (currentColor.r * currentColor.a) + ((existingPixel.r) * (1.0 - currentColor.a));
	newPixel.g = (currentColor.g * currentColor.a) + ((existingPixel.g) * (1.0 - currentColor.a));
	newPixel.b = (currentColor.b * currentColor.a) + ((existingPixel.b) * (1.0 - currentColor.a));
	
	// definitionally
	newPixel.a = 1.0; 	
	
	/*
	// TODO: remove after debug
	if (!BlessFBPixel(newPixel)) {
		NSLog(@"Aieee!");
	}
	 */
	
	[fb setPixelAtX:rx andY:ry to:newPixel];
}

#pragma mark -
#pragma mark FrameBuffer testing

FBPixel randomPixelA1() {
	FBPixel pixel;
	pixel.r = random_float(0.0, 1.0);
	pixel.g = random_float(0.0, 1.0);
	pixel.b = random_float(0.0, 1.0);
	pixel.a = 1.0;
	return pixel;
}

- (void) randomizeFB {
	int width = [fb getWidth];
	int height = [fb getHeight];
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			[self setColor:randomPixelA1()];
			[self pointX:x Y:y];
		}	
	}
}

- (void) rgbLinesFB {
	int width = [fb getWidth];
	int height = [fb getHeight];

	[self setColor:MakeFBPixel(1.0, 0.0, 0.0, 1.0)];
	for (int x = 0; x < width; x++) 
		for (int y = 0; y < (height / 3); y++)
			[self pointX:x Y:y];
	
	[self setColor:MakeFBPixel(0.0, 1.0, 0.0, 1.0)];
	for (int x = 0; x < width; x++) 
		for (int y = (height / 3); y < ((height / 3) * 2); y++)
			[self pointX:x Y:y];
	
	[self setColor:MakeFBPixel(0.0, 0.0, 1.0, 1.0)];
	for (int x = 0; x < width; x++) 
		for (int y = ((height / 3) * 2); y < ((height / 3) * 3); y++)
			[self pointX:x Y:y];
}	

- (void) alphaTestFB {
	
	int width = [fb getWidth];
	int height = [fb getHeight];
	
	FBPixel red_50pct = MakeFBPixel(1.0, 0.0, 0.0, 0.5);
	FBPixel green_50pct = MakeFBPixel(0.0, 0.0, 1.0, 0.5);
	
	[self setColor:red_50pct];
	for (int x = 0; x < width; x++)
		for (int y = 0; y < (height / 2); y++)
			[self pointX:x Y:y];
	
	[self setColor:green_50pct];
	for (int x = 0; x < width; x++)
		for (int y = (height / 2); y < height; y++)
			[self pointX:x Y:y];
	
	[self setColor:red_50pct];
	for (int x = 0; x < (width / 2); x++)
		for (int y = 0; y < height; y++)
			[self pointX:x Y:y];
	
	[self setColor:green_50pct];
	for (int x = (width / 2); x < width; x++)
		for (int y = 0; y < height; y++)
			[self pointX:x Y:y];
}

@end
