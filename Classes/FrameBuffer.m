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

- (id) initWithWidth:(int)w AndHeight:(int)h 
{
	width = w;
	height = h;
	pixels = calloc(width * height, sizeof(uint32_t));
	return self;
}

- (void) dealloc 
{
	free(pixels);
	[super dealloc];
}

#pragma mark -
#pragma mark Utilities

int offset(int x, int y, int width)
{
	return ((y * width) + x);
}

#pragma mark -
#pragma mark Instance method implementations

- (int) getWidth
{
	return width;
}

- (int) getHeight 
{
	return height;
}

- (FBPixel) getPixelAtX:(int)x andY:(int)y
{
	return Uint32ToFBPixel(pixels[offset(x, y, width)]);
}

- (void) setPixelAtX:(int)x andY:(int)y to:(FBPixel)pixel 
{
	dirty = YES;
	pixels[offset(x, y, width)] = FBPixelToUint32(pixel);
}

// Semantics: isDirty gets unset on a getBuffer* call and set on setPixel* call
								  
- (BOOL) isDirty
{
	return dirty;
}
					
- (GLubyte *) getBufferRGBA8888Pixels
{
	// Now here's a question.
	// Does a uint32_t alloc equal four GLubyte allocs?
	// If this blows up in my face I'm going to swap the backing from uint32_t to GLubyte.
	
	dirty = NO;
	return (GLubyte *) pixels;
}

@end
