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
	rgb565pixels = calloc(width * height, sizeof(uint16_t));
	pixels = calloc(width * height, sizeof(uint32_t));
	return self;
}

- (void) dealloc 
{
	free(pixels);
	free(rgb565pixels);
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
					
/*
 When type is GL_UNSIGNED_BYTE, each of these bytes is interpreted as one color component, depending on format. 
 When type is one of GL_UNSIGNED_SHORT_5_6_5, GL_UNSIGNED_SHORT_4_4_4_4, GL_UNSIGNED_SHORT_5_5_5_1, 
 each unsigned value is interpreted as containing all the components for a single pixel, 
 with the color components arranged according to format.

 i.e., GL_UNSIGNED_BYTE is an array of that looks like (in bits) RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA (32 bits)
   and GL_UNSIGNED_SHORT_5_6_5 is an array that looks like       RRRRRGGGGGGBBBBB                (16 bits)
 
 */

- (GLubyte *) getBufferRGB565Pixels
{
	dirty = NO;
	
	uint32_t inputPixel32;
	uint16_t outputPixel16;
	
	NSDate *startFrame = [NSDate date];

	for (int i = 0; i < width * height; i++)
	{
		inputPixel32 = pixels[i];
	
		// Set red
		
		uint32_t red;
		red = (inputPixel32 & 0xFF);
		red >>= 3;
		red <<= 11;
		
		// Set green
		
		uint32_t green;
		green = ((inputPixel32 >> 8) & 0xFF);
		green >>= 2;
		green <<= 5;
		
		// Set blue
		
		uint32_t blue;
		blue = ((inputPixel32 >> 16) & 0xFF);
		blue >>= 3;
		
		// Now repack into a uint16_t
		
		outputPixel16 = red | green | blue;	
		
		rgb565pixels[i] = outputPixel16;
	}
	
	NSLog(@"copy took %f", [startFrame timeIntervalSinceNow]);
	
	return (GLubyte *) rgb565pixels;
}

/*
 uint8_t *tempData = malloc(height * width * 2);
 inPixel32 = (unsigned int*)data;
 outPixel16 = (unsigned short*)tempData;
 for(int i = 0; i < width * height; ++i, ++inPixel32)
 *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) 
 | ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) 
 | ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0);
 free(data);
 data = tempData;
 */

- (GLubyte *) getBufferRGBA8888Pixels
{
	dirty = NO;
	return (GLubyte *) pixels;
}

@end
