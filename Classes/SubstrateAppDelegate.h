//
//  SubstrateAppDelegate.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright Jon Cooper 2010. All rights reserved.
//

#import "OpenGLView.h"
#import <UIKit/UIKit.h>

@interface SubstrateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	OpenGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OpenGLView *glView;

@end

