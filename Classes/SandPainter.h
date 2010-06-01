//
//  SandPainter.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/27/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Substrate.h"
#import "Palette.h"

@interface SandPainter : NSObject {
	Substrate *substrate;
	Palette *palette;
	FBPixel c;
	float gain;
}

- (id) initWithSubstrate:(Substrate *)substrate;
- (void) renderX:(float) x Y:(float)y OX:(float)ox OY:(float) oy;

@end
