//
//  Palette.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "Palette.h"

@implementation Palette

@synthesize colors;

+ (id) paletteFromImage:(UIImage *)image {
	Palette *p = [Palette alloc];
	NSArray *colorSet = [Palette getImageColors:image];
	[p setColors:colorSet];
	return p;
}

+ (NSArray *) getImageColors:(UIImage *)image {
	// Retval
	NSMutableArray *result = [NSMutableArray array];
	// Get a Core Graphics image reference
	CGImageRef imageRef = [image CGImage];
	// Set up parameters to the bitmap context creation
	NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
	// Create bitmapped context, free memory, and draw the image into the context
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
												 bitsPerComponent, bytesPerRow, colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
	
    // Now your rawData contains the image data in the RGBA8888 pixel format.
	for (int i = 0; i < (width * height * bytesPerPixel); i += bytesPerPixel) {
		CGFloat red   = (rawData[i]     * 1.0) / 255.0;
        CGFloat green = (rawData[i + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[i + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[i + 3] * 1.0) / 255.0;
		UIColor *aColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
		if (![result containsObject:aColor])
			[result addObject:aColor];
    }
	
	free(rawData);
	
	return result;
}

- (UIColor *) randomColor {
	if (colors != nil) {
		int index = random() % [colors count];
		return ((UIColor *) [colors objectAtIndex:index]);
	} 
	else {
		[NSException raise:@"Palette" format:@"Tried to get a random color from an uninitialized Palette."];
		return nil;
	}
}

@end
