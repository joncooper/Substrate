//
//  Substrate.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/28/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBPainter.h"

@interface Substrate : NSObject {
	FBPainter *fbPainter;
	int *cgrid;
	int width;
	int height;
	NSMutableArray *palette;
	NSMutableArray *cracks;
}

@property (nonatomic, retain) FBPainter *fbPainter;
@property (nonatomic, assign) int *cgrid;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

- (void) tick;

@end
