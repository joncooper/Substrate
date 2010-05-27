//
//  SubstrateRenderer.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "SubstrateRenderer.h"
#import <Foundation/Foundation.h>

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

- (void) render 
{
	// Set up the projection and viewport
	
	glViewport(0, 0, backingWidth, backingHeight);

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	//glOrthof(-1.0, 1.0, -1.0, 1.0, -1.0, 1.0);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Fascinating. If you don't light the scene, you can't see anything.
	
	glEnable(GL_LIGHTING);
    
	GLfloat ambientLight[] = {1.0, 1.0, 1.0, 1.0};
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientLight);
/*
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    GLfloat light0Ambient[] = {10.0, 10.0, 10.0, 1.0};
	glLightfv(GL_LIGHT0, GL_AMBIENT, light0Ambient);
    
    // Define the diffuse component of the first light
    GLfloat light0Diffuse[] = {1.0, 1.0, 1.0, 1.0};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, light0Diffuse);
    
    // Define the position of the first light
    // const GLfloat light0Position[] = {10.0, 10.0, 10.0}; 
    Vertex3D light0Position[] = {{10.0, 10.0, 10.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
*/
	// Textures.
	
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
	
/*
	// NOTE: textures need to be a power of 2 pixels on a side (but not necessarily square)
	// NOTE:you are using RGBA8888 right now; can use RGBA4444 to save memory
	// Use glTexImage2D to load an RGBA array into a texture
	GLsizei t_width = 512;
	GLsizei t_height = 512;
	GLubyte *imageData = malloc(512*512*4);
	
	// fill imageData from janky FrameBuffer here.
	// for now just fill it with something so we can see that it worked
	for (int idx = 0; idx <= (t_width * t_height); idx += 4) {
		imageData[idx]   = 0xFF;
		imageData[idx+1] = 0xCC;
		imageData[idx+2] = 0xCC;
		imageData[idx+3] = 0xFF;
	}
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, t_width, t_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	free(imageData);
*/
	// Load example texture
	
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
	
	// Draw
	
	Vertex3D squareVertices[] = {
        {-0.5f, -0.33f, 0.0f},
		{ 0.5f, -0.33f, 0.0}, 
		{-0.5f,  0.33f, 0.0f},
		{ 0.5f,  0.33f, 0.0f}
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
	
	GLfloat texCoords[] = { 
		0.0, 1.0, 
		1.0, 1.0, 
		0.0, 0.0, 
		1.0, 0.0 
	};
	
	// Material setup
	
	GLfloat ambientAndDiffuse[] = {0.75, 0.75, 0.75, 1.0};
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse);
		
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	
	glBindTexture(GL_TEXTURE_2D, blitterTexture[0]);

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
