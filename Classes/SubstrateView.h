//
//  SubstrateView.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameBuffer.h"
#import "Palette.h"

@interface SubstrateView : UIView {
	NSTimer *timer;
	FrameBuffer *fb;
	Palette *palette;
}

@end
