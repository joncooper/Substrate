//
//  Substrate.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/28/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "Substrate.h"
#import "Palette.h"
#import "FBPixel.h"
#import "FrameBuffer.h"
#import "FBPainter.h"
#import "Crack.h"

@implementation Substrate

@synthesize fbPainter;
@synthesize cgrid;
@synthesize width;
@synthesize height;
@synthesize palette;

- (id) init
{
	NSLog(@"Substrate -init");
	
	// seed the random number generator
	srandomdev();
	
	width = 768;
	height = 1004;
			
	// Create frame buffer and painter; set background color to white
	
	fbPainter = [[FBPainter alloc] init];
	fbPainter.fb = [[FrameBuffer alloc] initWithWidth:width AndHeight:height];
	[fbPainter setBackgroundColor:MakeFBPixel(1.0, 1.0, 1.0, 1.0)];
	
	[self setupCrackGrid];

	return self;
}

- (void) setupCrackGrid
{
	// Setup the palette
	palette = [Palette paletteFromFile:@"pollockShimmering.gif"];

	// Grab properties from settings
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	crack_density = [defaults floatForKey:@"crack_density"];
	simultaneous_cracks = [defaults integerForKey:@"simultaneous_cracks"];
	drawing_speed = [defaults integerForKey:@"drawing_speed"];
	
	// create and erase crack grid
	
	cgrid = calloc(width * height, sizeof(int));
	for (int x = 0; x < width; x++) 
		for (int y = 0; y < height; y++)
			cgrid[y * width + x] = 10001;
	
	// make random crack seeds
	
	int numCracks = width * height * crack_density;
	
	for (int seed = 0; seed < numCracks; seed++) {
		int i = random() % ((width * height) - 1);
		int angle = random() % 360;
		cgrid[i] = angle;
	}
	
	// make some cracks
	
	cracks = [[NSMutableArray alloc] init];
	for (int k = 0; k < simultaneous_cracks; k++) {
		Crack *aCrack = [[Crack alloc] initWithSubstrate:self];
		[cracks addObject:aCrack];
		[aCrack release];
	}
}

- (void) dealloc 
{
	free(cgrid);
	[fbPainter.fb dealloc];
	[fbPainter dealloc];
	[cracks dealloc];
	[super dealloc];
}

// Called per-frame

- (void) tick 
{	
	NSDate *startFrame = [NSDate date];
	
	int ticksPerFrame = drawing_speed;
	for (int k = 0; k < ticksPerFrame; k++) {
		for (int i = 0; i < [cracks count]; i++) {
			[[cracks objectAtIndex:i] move];
		}
	}
	
	NSTimeInterval frameTime = [startFrame timeIntervalSinceNow];
	NSLog(@"frame time: %f seconds", frameTime);
}

@end 
