//
//  Renderer.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface Renderer : NSObject {
@protected
	//
	// An EAGLContext defines the rendering context that is the target of all OpenGL ES commands.
	//
	EAGLContext *context;
	
	// Pixel dimensions of the the Core Animation layer that we're rendering into
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL ES names for the framebuffer and renderbuffer used to render to this view 
	GLuint defaultFramebuffer;
	GLuint colorRenderbuffer;
	GLuint depthRenderbuffer;
}

- (void) render;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

@end