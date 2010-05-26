//
//  OpenGLView.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/26/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "Renderer.h"

@interface OpenGLView : UIView {
@private
	Renderer *renderer;
	BOOL animating;
	NSInteger animationFrameInterval;
	id displayLink;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;

- (void) startAnimation;
- (void) stopAnimation;
- (void) drawView:(id)sender;

@end
