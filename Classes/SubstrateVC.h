//
//  SubstrateVC.h
//  Substrate
//
//  Created by Jonathan Cooper on 6/2/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"
#import "SubstrateRenderer.h"
#import "IASKAppSettingsViewController.h"

@interface SubstrateVC : UIViewController <IASKSettingsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	SubstrateRenderer *renderer;
	OpenGLView *glView;
	
	BOOL animating;
	
	UIToolbar *toolbar;
	UIPopoverController *popoverController;
	UIBarButtonItem *pausedLabel;
	UIView *aboutBox;
	
	BOOL aboutBoxIsDisplayed;
}

@property (nonatomic, retain) IBOutlet OpenGLView *glView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (void) togglePause;
- (void) pause;
- (void) unpause;
- (void) restart;

- (void) setupToolbar;
- (void) hideInfoBox;

@end
