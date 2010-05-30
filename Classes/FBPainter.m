//
//  FBPainter.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/27/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "FBPainter.h"
#import <Foundation/Foundation.h>

@implementation FBPainter

@synthesize fb;

- (void) setColor:(FBPixel)color
{
	currentColor = color;
}

- (void) setBackgroundColor:(FBPixel) color;
{
	[self setColor:color];
	
	int width = [fb getWidth];
	int height = [fb getHeight];
	
	for (int x = 0; x < width; x++)
		for (int y = 0; y < height; y++)
			[fb setPixelAtX:x andY:y to:currentColor];
}

- (void) pointX:(int)x Y:(int)y
{
	// Draw points onto the FB with blending.
	// Use the associative (i.e. NON-premultiplied) approach. 
	
	FBPixel existingPixel = [fb getPixelAtX:x andY:y];
	FBPixel newPixel;
	
	float ccR, ccG, ccB, ccA;
	float epR, epG, epB, epA;
	float npR, npG, npB;
	float newAlpha;
	
	ccR = (float) (currentColor.r / 255.0);
	ccG = (float) (currentColor.g / 255.0);
	ccB = (float) (currentColor.b / 255.0);
	ccA = (float) (currentColor.a / 255.0);
	
	epR = (float) (existingPixel.r / 255.0);
	epG = (float) (existingPixel.g / 255.0);
	epB = (float) (existingPixel.b / 255.0);
	epA = (float) (existingPixel.a / 255.0);
	
	newAlpha = ccA + ((1.0 - ccA) * epA);
	
	npR = (ccR * ccA) + ((epR * epA) * (1.0 - ccA));
	npG = (ccG * ccA) + ((epG * epG) * (1.0 - ccA));
	npB = (ccB * ccA) + ((epB * epA) * (1.0 - ccA));

	if (newAlpha > 0.0) {
		npR /= newAlpha;
		npG /= newAlpha;
		npB /= newAlpha;
	}
	
	newPixel.r = (uint8_t) (npR * 255.0);
	newPixel.g = (uint8_t) (npG * 255.0);
	newPixel.b = (uint8_t) (npB * 255.0);
	newPixel.a = newAlpha;
	
	/*
	uint8_t newAlpha = currentColor.a + ((0xFF - currentColor.a) * (existingPixel.a/0xFF));
	newPixel.a = newAlpha;
	
	newPixel.r = (currentColor.r * (currentColor.a)/0xFF) + ((existingPixel.r * (existingPixel.a)/0xFF) * (0xFF - currentColor.a)); 
	newPixel.g = (currentColor.g * (currentColor.a)/0xFF) + ((existingPixel.g * (existingPixel.a)/0xFF) * (0xFF - currentColor.a));
	newPixel.b = (currentColor.b * (currentColor.a)/0xFF) + ((existingPixel.b * (existingPixel.a)/0xFF) * (0xFF - currentColor.a));
	if (newAlpha != 0x00) {
		newPixel.r *= (1 / (newAlpha/0xFF));
		newPixel.g *= (1 / (newAlpha/0xFF));
		newPixel.b *= (1 / (newAlpha/0xFF));
	} 

	 else 
		// Not super sure what I'm supposed to do here.
	}
	 */
	
	[fb setPixelAtX:x andY:y to:newPixel];
}

// Possibly antialias one day. For now, round.
- (void) pointXf:(float)x Yf:(float)y
{
	[self pointX:roundf(x) Y:roundf(y)];
}

#pragma mark -
#pragma mark FrameBuffer testing

FBPixel randomPixelA1() {
	FBPixel pixel;
	pixel.r = random() % 0xFF;
	pixel.g = random() % 0xFF;
	pixel.b = random() % 0xFF;
	pixel.a = 0xFF;
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
	
	FBPixel red = MakeFBPixel(0xFF, 0x00, 0x00, 0xFF);
	FBPixel green = MakeFBPixel(0x00, 0xFF, 0x00, 0xFF);
	FBPixel blue = MakeFBPixel(0x00, 0x00, 0xFF, 0xFF);
	
	[self setColor:red];
	for (int x = 0; x < width; x++) 
		for (int y = 0; y < (height / 3); y++)
			[self pointX:x Y:y];
	
	[self setColor:green];
	for (int x = 0; x < width; x++) 
		for (int y = (height / 3); y < ((height / 3) * 2); y++)
			[self pointX:x Y:y];
	
	[self setColor:blue];
	for (int x = 0; x < width; x++) 
		for (int y = ((height / 3) * 2); y < ((height / 3) * 3); y++)
			[self pointX:x Y:y];
}	

- (void) alphaTestFB {
	
	int width = [fb getWidth];
	int height = [fb getHeight];
	
	FBPixel red_50pct = MakeFBPixel(0xFF, 0x00, 0x00, 0x7F);
	FBPixel green_50pct = MakeFBPixel(0x00, 0xFF, 0x00, 0x7F);
	
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
