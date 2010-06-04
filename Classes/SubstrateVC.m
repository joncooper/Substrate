    //
//  SubstrateVC.m
//  Substrate
//
//  Created by Jonathan Cooper on 6/2/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "SubstrateVC.h"
#import "SubstrateRenderer.h"
#import "IASKAppSettingsViewController.h"

@implementation SubstrateVC

@synthesize glView;
@synthesize toolbar;

- (void) viewDidLoad
{ 	
	renderer = [[SubstrateRenderer alloc] init];
	[glView setRenderer:renderer];
	[glView startAnimation];		
	[self setupToolbar];
}

- (void) setupToolbar
{
	NSMutableArray *buttons = [NSMutableArray array];
	UIBarButtonItem *cracksButton = [[UIBarButtonItem alloc] initWithTitle:@"Configure" style:UIBarButtonItemStyleBordered target:self action:@selector(showConfigurePopover:)];
	[buttons addObject:cracksButton];
	[cracksButton release];
	[toolbar setItems:buttons animated:NO];
}

- (void) showConfigurePopover:(id) sender
{
	[glView stopAnimation];
	IASKAppSettingsViewController *settingsVC = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
	UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
	popoverController = [[UIPopoverController alloc] initWithContentViewController:settingsNavController];
	[settingsVC setDelegate:self];
	[popoverController presentPopoverFromBarButtonItem:[toolbar.items objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
	[popoverController dismissPopoverAnimated:YES];
	[renderer clearAndRestart];
	[glView startAnimation];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
