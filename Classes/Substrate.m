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
#import "NSUserDefaults+ReadWithDefaults.h"

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
	height = 1024;
		
	// Setup the palette
	palette = [Palette paletteFromFile:@"pollockShimmering.gif"];
	
	[self setupCrackGrid];

	return self;
}

- (void) pause
{
	PAUSE = YES;
}

- (void) unpause
{
	PAUSE = NO;
}

- (void) setupCrackGrid
{
	// Clean up memory if necessary
	[self cleanupMemory];
	
	// Create frame buffer and painter; set background color to white
	
	fbPainter = [[FBPainter alloc] init];
	fbPainter.fb = [[FrameBuffer alloc] initWithWidth:width AndHeight:height];
	[fbPainter setBackgroundColor:MakeFBPixel(0.95, 0.95, 0.85, 1.0)];
	
	// Grab properties from settings
	/*
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults registerDefaults:[NSUserDefaults getDefaultsFromSettingsBundle]];
	[defaults synchronize];
	 */
	
	// Load settings and/or initialize them
	[NSUserDefaults registerDefaultsFromSettingsBundleIfNecessary];

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

- (void) cleanupMemory
{
	free(cgrid);
	[cracks release];
	[fbPainter.fb release];
	[fbPainter release];
}

- (void) dealloc 
{
	[self cleanupMemory];
	[super dealloc];
}


- (void) threadRun
{
	PAUSE = NO;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // Top-level pool
	while (![[NSThread currentThread] isCancelled]) {
		if (!PAUSE) {
			for (int i = 0; i < [cracks count]; i++) {
				[[cracks objectAtIndex:i] move];
			}
		}
	}
	[pool release];
}

@end 
