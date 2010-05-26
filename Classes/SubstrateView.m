//
//  SubstrateView.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "SubstrateView.h"

@implementation SubstrateView


#pragma mark -
#pragma mark Framebuffer packing / unpacking / convenience

// This is going to be a raw framebuffer for our pixels.
// use int32_t to guarantee 4 8-bit bytes will fit. going to pack into bytes in RGBA order.
uint32_t *pixels;
// TODO: dealloc!
int width;
int height;

uint32_t pack(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
	return ((uint32_t) r) | ((uint32_t) g) << 8 | ((uint32_t) b) << 16 | ((uint32_t) a) << 24;
}

uint8_t unpackR(uint32_t packed) {
	return ((uint8_t) packed);
}

// Be careful to apply the shift before the cast, otherwise you are shifting something that's already 8 bits.

uint8_t unpackG(uint32_t packed) 
{
	return ((uint8_t) (packed >> 8));
}

uint8_t unpackB(uint32_t packed) {
	return ((uint8_t) (packed >> 16));
}

uint8_t unpackA(uint32_t packed) {
	return ((uint8_t) (packed >> 24));
}

int offset(int x, int y) {
	return ((y * width) + x);
}

- (void) makeSomeFakePixels {
	int32_t someColor = pack(0xFF, 0xAA, 0xBB, 0xFF);
	pixels[offset(100, 100)] = someColor;
	pixels[offset(200, 200)] = someColor;
	pixels[offset(300, 300)] = someColor;
	pixels[offset(400, 400)] = someColor;
}

- (void) setupPixels:(CGRect)theFrame {
	NSLog(@"SubstrateView -setupPixels");
	width = (int) theFrame.size.width;
	height = (int) theFrame.size.height;
	// malloc and clear
	pixels = calloc(width * height, sizeof(uint32_t));
	
	[self makeSomeFakePixels];
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
	NSTimeInterval tickInterval = 1.0 / 1.0;
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
	static BOOL initialized = NO;
	if (!initialized) {
		[self setupPixels:rect];
		[self setupPalette];
		[self startTimer];
		initialized = YES;
	}
	
	NSLog(@"drawRect - rect is %@", NSStringFromCGRect(rect));
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Color in the background
	[[UIColor blackColor] set];
	UIRectFill(rect);
	
	// Apparently rects are drawn in a path
	CGContextBeginPath(context);
	
	// Since we are going to draw dots, we are drawing rects with side length 1. Let's see how this works.. 
	CGFloat sideLength = 1.0;
	
	// Scan pixel array and draw
	uint32_t emptyPixel = 0;
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			uint32_t pixel = pixels[offset(x, y)];
			if (pixel != emptyPixel) {
								
				CGFloat r = (CGFloat) unpackR(pixel) / 0xFF;
				CGFloat g = (CGFloat) unpackG(pixel) / 0xFF;
				CGFloat b = (CGFloat) unpackB(pixel) / 0xFF;
				CGFloat a = (CGFloat) unpackA(pixel) / 0xFF;
				
				NSLog(@"pixel: %x", pixel);
				NSLog(@"rgba is: %x %x %x %x", unpackR(pixel), unpackG(pixel), unpackB(pixel), unpackA(pixel));
				NSLog(@"drawing a pixel at (%i, %i) with RGBA = [%f,%f,%f,%f]", x, y, r, g, b, a);
				
				// TODO: the palette should probably get cached and be a static lookup
				[[UIColor colorWithRed:r green:g blue:b alpha:a] set];
				CGRect rectToDraw;
				rectToDraw.origin.x = x;
				rectToDraw.origin.y = y;
				rectToDraw.size.width = sideLength;
				rectToDraw.size.height = sideLength;
				CGContextAddRect(context, rectToDraw);
			}
		}
	}
	
	// End path
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
}

- (void)dealloc {
    [super dealloc];
}


@end
