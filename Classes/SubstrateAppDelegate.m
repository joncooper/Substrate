//
//  SubstrateAppDelegate.m
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright Jon Cooper 2010. All rights reserved.
//

#import "NSUserDefaults+ReadWithDefaults.h"
#import "SubstrateAppDelegate.h"
#import "OpenGLView.h"

@implementation SubstrateAppDelegate

@synthesize window;
@synthesize substrateVC;

void uncaughtExceptionHandler(NSException *exception) {
//    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	// Set up the Flurry analytics API
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
//	[FlurryAPI startSession:@"GG7WI18ZDK2KCQRZB6NY"];
	
	// Bind the view controller to the window
	[window addSubview:substrateVC.view];
	
	// Draw the intro fadeout animation
	// [self drawIntroAnimation];
	
	[window makeKeyAndVisible];
    return YES;
}

- (void) drawIntroAnimation
{
	// Fade out from splash screen
	UIImage *backImage;
	if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
		backImage = [UIImage imageNamed:@"Default-Portrait.png"];
	}
	else {
		backImage = [UIImage imageNamed:@"Default-Landscape.png"];
	}
	
	UIView *backView = [[UIImageView alloc] initWithImage:backImage];
	backView.frame = window.bounds;
	backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[window addSubview:backView];
	
	[UIView beginAnimations:@"FadeOut" context:(void*)backView];
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	backView.alpha = 0.0;
	[UIView commitAnimations];
}
/*

// Dispose of UIImageView for splash screen
-(void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished
				context:(void*)context
{
	UIView* backView = (UIView*)context;
	[backView removeFromSuperview];
	[backView release];
}
*/
- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
