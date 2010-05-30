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
}

- (void) setupGL;
- (void) render;

@end
