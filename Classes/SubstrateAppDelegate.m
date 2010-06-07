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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	// Bind the view controller to the window
	[window addSubview:substrateVC.view];
	
	// Fade out from splash screen
	
	UIImage *backImage = [UIImage imageNamed:@"Default-Portrait.png"];
	UIView *backView = [[UIImageView alloc] initWithImage:backImage];
	backView.frame = window.bounds;
	[window addSubview:backView];
	
	[UIView beginAnimations:@"FadeIn" context:(void*)backView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationBeginsFromCurrentState:YES];
	backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	// Smash
	[UIView beginAnimations:@"Squish" context:(void*) backView];
	[UIView setAnimationDuration:5.0f];
	backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
	backView.alpha = 0.5;
	[UIView commitAnimations];

	
	// Expand
	[UIView beginAnimations:@"Novafy" context:(void*) backView];
	[UIView setAnimationDuration:0.5f];
	backView.alpha = 0.375;
	backView.transform = CGAffineTransformScale(backView.transform, 3.0, 3.0);
	[UIView commitAnimations];

	
	[UIView beginAnimations:@"Spread" context:(void*) backView];
	[UIView setAnimationDuration:0.5f];
	backView.alpha = 0;
	backView.transform = CGAffineTransformScale(backView.transform, 100.0, 0.1);
	[UIView commitAnimations];

	
	[UIView commitAnimations];
	
	[window makeKeyAndVisible];
    return YES;
}

// Dispose of UIImageView for splash screen
-(void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished
				context:(void*)context
{
	UIView* backView = (UIView*)context;
	[backView removeFromSuperview];
	[backView release];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
