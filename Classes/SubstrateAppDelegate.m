//
//  SubstrateAppDelegate.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright Jon Cooper 2010. All rights reserved.
//

#import "SubstrateAppDelegate.h"

@implementation SubstrateAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[window makeKeyAndVisible];
    return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
