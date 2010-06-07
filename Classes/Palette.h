//
//  Palette.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "FBPixel.h"

@interface Palette : NSObject {
	NSArray *colors;
}

@property (retain) NSArray *colors; 

+ (id) paletteFromUIImage:(UIImage *)image;
+ (id) paletteFromFile:(NSString *)filename;
- (FBPixel) randomColor;

- (void) setupSamplePalette;

@end
