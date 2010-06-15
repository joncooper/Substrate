//
//  FrameBuffer.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "FBPixel.h"
#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@interface FrameBuffer : NSObject {
@private
	int width;
	int height;
	uint16_t *rgb565pixels;
	uint32_t *pixels;
	BOOL dirty;
}

- (id) initWithWidth:(int)width AndHeight:(int)height;

- (int) getWidth;
- (int) getHeight;

- (FBPixel) getPixelAtX:(int)x andY:(int)y;
- (void) setPixelAtX:(int)x andY:(int)y to:(FBPixel)pixel;

// Semantics: isDirty gets unset on a getBuffer* call and set on setPixel* call
- (BOOL) isDirty;
- (GLubyte *) getBufferRGB565Pixels;
- (GLubyte *) getBufferRGBA8888Pixels;
- (UIImage *) getBufferAsUIImage;

@end

