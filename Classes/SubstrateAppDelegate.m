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
@synthesize substrateVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[window addSubview:substrateVC.view];
	[window makeKeyAndVisible];
    return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
