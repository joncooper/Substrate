//
//  FrameBuffer.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameBuffer : NSObject {	
	uint32_t *pixels;
	int width;
	int height;
}

- (id) initWithWidth:(int)width AndHeight:(int)height;
- (uint32_t) getPixelAtX:(int)x andY:(int)y;
- (void) setPixelAtX:(int)x andY:(int)y to:(uint32_t)pixel;

@end
