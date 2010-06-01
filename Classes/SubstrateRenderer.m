//
//  SubstrateRenderer.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "SubstrateRenderer.h"
#import <Foundation/Foundation.h>
#import "FBPixel.h"
#import "Substrate.h"

@implementation SubstrateRenderer

typedef struct {
	GLfloat x;
	GLfloat y;
	GLfloat z;
} Vertex3D;

// See http://ask.metafilter.com/101438/Getting-to-the-point-in-OpenGL-ES

// See http://www.scottlu.com/2008/04/fast-2d-graphics-wopengl-es.html
//
// You want to:
//
// 1. Use glOrtho to set up a parallel projection
// 2. Create a PBuffer surface and associate it with a texture name. Use powers of 2 dimensions.
// 3. Use glTexSubImage to update only the parts that are changing (worst case, all of it)
// 4. Once the PBuffer is ready, draw it to the window surface by setting the cropping rect and calling glDrawTex.
// 5. Swap buffers. Goto 3. 
// 

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		substrate = [[Substrate alloc] init];
		[self setupGL];
	}
	return self;
}

- (void) dealloc {
	[substrate release];
	[super dealloc];
}

#pragma mark -
#pragma mark Earlier texture experiments

// Load example texture
- (void) bindExampleTexture {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
	UIImage *image = [[UIImage alloc] initWithData:texData];
	if (image == nil)
	NSAssert(false, @"Ack!");
	GLuint twidth = CGImageGetWidth(image.CGImage);
	GLuint theight = CGImageGetWidth(image.CGImage);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	void *imageData = malloc(twidth * theight * 4);
	CGContextRef cgContext = CGBitmapContextCreate(imageData, twidth, theight, 8, 4 * twidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClearRect(cgContext, CGRectMake(0, 0, twidth, theight));
	CGContextTranslateCTM(cgContext, 0, theight - theight);
	CGContextDrawImage(cgContext, CGRectMake(0, 0, twidth, theight), image.CGImage);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, twidth, theight, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	CGContextRelease(cgContext);
	free(imageData);
	[image release];
	[texData release];	
}

// Mutate the existing texture using glTexSubImage2D.
- (void) mutateTextureWidth:(GLuint)width Height:(GLuint)height {
	NSLog(@"Mutated!");
	// Mangle a 64x64 subregion randomly
	GLsizei subWidth = 64;
	GLsizei subHeight = 64;
	// This region should have an origin like (0 <= x <= width - subWidth, 0 <= y <= height - subHeight);
	int xRegions = width / subWidth;
	int yRegions = height / subHeight;
	NSLog(@"%i %i", xRegions, yRegions);
	GLint xOffset = (random() % (xRegions - 1)) * subWidth;
	GLint yOffset = (random() % (yRegions - 1)) * subHeight;
	NSLog(@"%i %i", xOffset, yOffset);
	// Make random pixel data, RGBA
	GLubyte *pixelData = malloc(subWidth * subHeight * 4);
	for (int i = 0; i < (subWidth * subHeight * 4); i+=4) {
		GLubyte r = random() % 0xFF;
		GLubyte g = random() % 0xFF;
		GLubyte b = random() % 0xFF;
		GLubyte a = 0xFF;
		pixelData[i]   = r;
		pixelData[i+1] = g;
		pixelData[i+2] = b;
		pixelData[i+3] = a;		
	}
	glTexSubImage2D(GL_TEXTURE_2D, 0, xOffset, yOffset, subWidth, subHeight, GL_RGBA, GL_UNSIGNED_BYTE, pixelData);
	free(pixelData);
}

#pragma mark -
#pragma mark OpenGL

- (void) setupGL {
	[self setupViewport];
	[self setupLighting];
	[self setupTexture];	
}

- (void) setupTexture {
	
	// Enable them.
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_SRC_COLOR);
	
	// Create a texture
	
	GLuint blitterTexture[1];
	glGenTextures(1, &blitterTexture[0]);
	
	// Bind it and set up
	
	glBindTexture(GL_TEXTURE_2D, blitterTexture[0]);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Grab the texture in RGBA from the frame buffer and copy the data in
	
	GLubyte *textureData = [substrate.fbPainter.fb getBufferRGBA8888Pixels];
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1024, 1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);

}

// Update the texture with new image data from the FB
- (void) updateTexture {
	GLubyte *textureData = [substrate.fbPainter.fb getBufferRGBA8888Pixels];
	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 768, 1004, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
}

// Set up the projection and viewport
//
- (void) setupViewport 
{
	glViewport(0, 0, backingWidth, backingHeight);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrthof(0, 1.0, 0, 1.0, -1.0, 1.0);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

// Set up the lighting model
//
- (void) setupLighting
{
	// If you don't light the scene, you can't see anything.
	
	glEnable(GL_LIGHTING);
    
	GLfloat ambientLight[] = {1.0, 1.0, 1.0, 1.0};
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight);
}

// Called every frame - do the drawing
//
- (void) render
{	
	// Tick the substrate model!
		
	// [substrate.fbPainter randomizeFB];
	[self setupViewport];
	[self setupLighting];
	
    //[substrate.fbPainter setBackgroundColor:MakeFBPixel(0x00, 0x00, 0x00, 0x00)];
	//[substrate.fbPainter alphaTestFB];
	[substrate tick];
	
	// Don't do anything unless it drew something
	if (![substrate.fbPainter.fb isDirty]) 
		return;
	
	[self updateTexture];

	// Draw
	
	/*
	Vertex3D squareVertices[] = {
        {-0.5f, -0.33f, 0.0f},
		{ 0.5f, -0.33f, 0.0}, 
		{-0.5f,  0.33f, 0.0f},
		{ 0.5f,  0.33f, 0.0f}
    };
	 */
	
	Vertex3D squareVertices[] = {
		{0.0f, 0.0f, 0.0f},
		{1.0f, 0.0f, 0.0f},
		{0.0f, 1.0f, 0.0f},
		{1.0f, 1.0f, 0.0f}
	};
	
	GLfloat normals[] = {
		0.0, 0.0, 1.0,
		0.0, 0.0, 1.0,
		0.0, 0.0, 1.0,
		0.0, 0.0, 1.0
	};
	
	glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
	
	// Map and enable the texture
	
	GLfloat tw = 768.0  / 1024.0;
	GLfloat th = 1004.0 / 1024.0;
	
	GLfloat texCoords[] = { 
		0.0, th, 
		tw, th, 
		0.0, 0.0, 
		tw, 0.0 
	};
	
	// Material setup
	
	GLfloat ambientAndDiffuse[] = {0.75, 0.75, 0.75, 1.0};
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse);
		
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	
	glVertexPointer(3, GL_FLOAT, 0, squareVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glNormalPointer(GL_FLOAT, 0, normals);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_NORMAL_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];	
}

@end
