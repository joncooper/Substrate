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

+ (id) paletteFromFile:(NSString *)filename {
	
	Palette *palette = [[[Palette alloc] init] autorelease];
	
	// Retval
	NSMutableArray *result = [NSMutableArray array];
	
	// Load image
	UIImage *image = [UIImage imageNamed:filename];
	
	// Get a Core Graphics image reference and set up parameters to the bitmap context creation
	CGImageRef imageRef = [image CGImage];
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
		uint8_t red   = rawData[i];
        uint8_t green = rawData[i + 1]; 
        uint8_t blue  = rawData[i + 2];
        uint8_t alpha = rawData[i + 3];
		
		FBPixel pixel = MakeFBPixel((float) (red / 255.0),
									(float) (green / 255.0), 
									(float) (blue / 255.0), 
									(float) (alpha / 255.0));
		
		// NSLog(@"%x %x %x %x", red, green, blue, alpha);
		// NSLog(@"%f %f %f %f", pixel.r, pixel.g, pixel.b, pixel.a);
		
		NSValue *wrappedPixel = [NSValue value:&pixel withObjCType:@encode(FBPixel)];
		if (![result containsObject:wrappedPixel])
			[result addObject:wrappedPixel];
    }
	
	free(rawData);
	palette.colors = result;
	
	return palette;
}

- (void) setupSamplePalette
{
	NSMutableArray *newColors = [NSMutableArray arrayWithCapacity:3];
	
	FBPixel c1 = MakeFBPixel(214.0 / 255.0, 180.0 / 255.0, 159.0 / 255.0, 1.0);
	FBPixel c2 = MakeFBPixel(158.0 / 255.0, 213.0 / 255.0, 206.0 / 255.0, 1.0);
	FBPixel c3 = MakeFBPixel(158.0 / 255.0, 164.0 / 255.0, 213.0 / 255.0, 1.0);
	
	[newColors addObject:[NSValue value:&c1 withObjCType:@encode(FBPixel)]];
	[newColors addObject:[NSValue value:&c2 withObjCType:@encode(FBPixel)]];
	[newColors addObject:[NSValue value:&c3 withObjCType:@encode(FBPixel)]];
	
	colors = newColors;
}

- (FBPixel) randomColor {
	if (colors != nil) {
		int index = random() % [colors count];
		FBPixel pixel;
		[[colors objectAtIndex:index] getValue:&pixel];
		NSLog(@"Palette -randomColor: %f %f %f %f", pixel.r, pixel.g, pixel.b, pixel.a);
		return pixel;
	} 
	else {
		[NSException raise:@"Palette" format:@"Tried to get a random color from an uninitialized Palette."];
		return MakeFBPixel(0, 0, 0, 0);
	}
}

@end
