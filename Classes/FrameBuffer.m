//
//  FrameBuffer.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "FrameBuffer.h"

// This is going to be a raw framebuffer for our pixels.
// use int32_t to guarantee 4 8-bit bytes will fit. going to pack into bytes in RGBA order.

@implementation FrameBuffer

#pragma mark -
#pragma mark Lifecycle

- (id) initWithWidth:(int)w AndHeight:(int)h {
	width = w;
	height = h;
	pixels = calloc(width * height, sizeof(uint32_t));
	return self;
}

- (void) dealloc {
	free(pixels);
	[super dealloc];
}

#pragma mark -
#pragma mark Utilities

uint32_t pack(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
	return ((uint32_t) r) | ((uint32_t) g) << 8 | ((uint32_t) b) << 16 | ((uint32_t) a) << 24;
}

// Be careful to apply the shift before the cast, otherwise you are shifting something that's already 8 bits.

uint8_t unpackR(uint32_t packed) {
	return ((uint8_t) packed);
}

uint8_t unpackG(uint32_t packed) 
{
	return ((uint8_t) (packed >> 8));
}

uint8_t unpackB(uint32_t packed) {
	return ((uint8_t) (packed >> 16));
}

uint8_t unpackA(uint32_t packed) {
	return ((uint8_t) (packed >> 24));
}

int offset(int x, int y, int width) {
	return ((y * width) + x);
}

#pragma mark -
#pragma mark Instance method implementations

- (uint32_t) getPixelAtX:(int)x andY:(int)y {
	return pixels[offset(x,y,width)];
}

- (void) setPixelAtX:(int)x andY:(int)y to:(uint32_t)pixel {
	pixels[offset(x,y,width)] = pixel;
}

@end
