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

@interface SubstrateVC : UIViewController <IASKSettingsDelegate> {
	SubstrateRenderer *renderer;
	OpenGLView *glView;
	
	UIToolbar *toolbar;
	
	UIPopoverController *popoverController;
}

@property (nonatomic, retain) IBOutlet OpenGLView *glView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (IBAction) redraw;

@end
