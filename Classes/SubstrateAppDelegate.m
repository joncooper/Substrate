//
//  SubstrateAppDelegate.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright Jon Cooper 2010. All rights reserved.
//

#import "SubstrateAppDelegate.h"
#import "OpenGLView.h"

@implementation SubstrateAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[glView startAnimation];
	[window makeKeyAndVisible];
    return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
