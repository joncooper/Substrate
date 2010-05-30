//
//  FBPainter.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/27/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameBuffer.h"
#import "FBPixel.h"

@interface FBPainter : NSObject {
	FrameBuffer *fb;
@private
	FBPixel currentColor;
}

@property (nonatomic, retain) FrameBuffer *fb;

- (void) setColor:(FBPixel)color;
- (void) setBackgroundColor:(FBPixel) color;
- (void) pointX:(int)x Y:(int)y;
- (void) pointXf:(float)x Yf:(float)y;

- (void) randomizeFB;

@end
