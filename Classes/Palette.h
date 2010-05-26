//
//  Palette.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

@interface Palette : NSObject {
	NSArray *colors;
}

@property (retain) NSArray *colors; 

+ (id) paletteFromImage:(UIImage *)image;
+ (NSArray *) getImageColors:(UIImage *)image;

- (UIColor *) randomColor;

@end
