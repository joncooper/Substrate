//
//  Crack.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/28/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Substrate.h"
#import "SandPainter.h"

@interface Crack : NSObject {
	Substrate *substrate;
	SandPainter *sandPainter;
	
	int dimx;
	int dimy;
	
	float x;
	float y;
	float t; // angle of travel in degrees
	
	int crack_divergence_from_perpendicular;
	BOOL allow_curvature;
	float curvature_probability;
	float curvature_rate;
	float curvature;
	BOOL antialias;
}

@property (nonatomic, retain) Substrate *substrate;

- (id) initWithSubstrate:(Substrate *)theSubstrate;
- (void) findStart;
- (void) startCrackX:(int)cx Y:(int)cy Angle:(int)ca;
- (void) move;

@end
