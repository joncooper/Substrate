//
//  SubstrateRenderer.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import "Substrate.h"


@interface SubstrateRenderer : Renderer {
	Substrate *substrate;
	NSThread *drawingThread;
}

@property (nonatomic, retain) Substrate *substrate;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (void) setupGL;
- (void) setupViewport;
- (void) setupLighting;
- (void) setupTexture;
- (void) updateTexture;

- (void) render;

- (void) clearAndRestart;

@end
