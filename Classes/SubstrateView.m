//
//  SubstrateView.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "FrameBuffer.h"
#import "SubstrateView.h"

@implementation SubstrateView

- (void) setupFrameBuffer:(CGRect) rect {
	fb = [[FrameBuffer alloc] initWithWidth:rect.size.width AndHeight:rect.size.height];
}

- (void) setupPalette {
	UIImage *paletteImageToClone = [UIImage imageNamed:@"pollockShimmering.gif"];
	palette = [Palette paletteFromImage:paletteImageToClone];
	for (int i = 0; i < 10; i++) 
		NSLog(@"%@", [palette randomColor]);
}

- (void) tick:(NSTimer *)theTimer {
	NSLog(@"Tick");
	[self setNeedsDisplay];
}

- (void) startTimer {
	// Kick off a thread to animate the view. Let's try 10 frames per second.
	NSTimeInterval tickInterval = 1.0 / 10.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:tickInterval target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}


- (id)initWithFrame:(CGRect)frame {
	NSLog(@"HMM");
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
    }
    return self;
}


- (void) drawRect:(CGRect) rect {
	NSDate *start = [NSDate date];
	
	static BOOL initialized = NO;
	if (!initialized) {
		[self setupFrameBuffer:rect];
		[self setupPalette];
		[self startTimer];
		initialized = YES;
	}
	
	NSLog(@"drawRect - rect is %@", NSStringFromCGRect(rect));
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Color in the background
	[[UIColor blackColor] set];
	UIRectFill(rect);
		
	// Since we are going to draw dots, we are drawing rects with side length 1. Let's see how this works.. 
	CGFloat sideLength = 1.0;

	// Put some shit in the frame buffer 
	int width = (int) rect.size.width;
	int height = (int) rect.size.height;
	int toDraw = 1000;
	
	for (int i = 0; i < toDraw; i++) {
		uint32_t someColor;
		uint8_t r = random() % 255;
		uint8_t g = random() % 255;
		uint8_t b = random() % 255;
		uint8_t a = 0xFF;
		someColor = pack(r, g, b, a);
		
		int x = random() % width;
		int y = random() % height;
		[fb setPixelAtX:x andY:y to:someColor];
	}
	
	// Scan pixel array and draw
	uint32_t emptyPixel = 0;
	for (int x = 0; x < rect.size.width; x++) {
		for (int y = 0; y < rect.size.height; y++) {
			uint32_t pixel = [fb getPixelAtX:x andY:y];
			
			if (pixel != emptyPixel) {		
				[[UIColor colorWithRed:unpackR(pixel) green:unpackG(pixel) blue:unpackB(pixel) alpha:unpackA(pixel)] setFill];
				
				CGRect rectToDraw;
				rectToDraw.origin.x = x;
				rectToDraw.origin.y = y;
				rectToDraw.size.width = sideLength;
				rectToDraw.size.height = sideLength;
				CGContextBeginPath(context);
				CGContextAddRect(context, rectToDraw);
				CGContextClosePath(context);
				CGContextDrawPath(context, kCGPathFill);
			}
		}
	}
	
	NSTimeInterval elapsed = [start timeIntervalSinceNow];
	NSLog(@"Elapsed time: %f", elapsed);
}

- (void)dealloc {
    [super dealloc];
}


@end
