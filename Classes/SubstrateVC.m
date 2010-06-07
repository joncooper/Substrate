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
	animating = YES;
}

// A touch has finished
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"got a touch in SubstrateVC");
	
	if (animating) {
		[self pause];
	}
	else {
		[self unpause];
	}
	
	UITouch *touch = [[event allTouches] anyObject];
	if ([touch tapCount] == 2) {
		[self restart];
	}
}

- (void) restart
{
	[renderer pause];
	[glView stopAnimation];
	[renderer clearAndRestart];
	[renderer unpause];
	[glView startAnimation];
}

- (void) pause
{
	[renderer pause];
	[glView stopAnimation];
	animating = NO;
}

- (void) unpause
{
	[renderer unpause];
	[glView startAnimation];
	animating = YES;
}

- (void) setupToolbar
{
	NSMutableArray *buttons = [NSMutableArray array];
	
	UIBarButtonItem *cracksButton = [[UIBarButtonItem alloc] initWithTitle:@"Configure" style:UIBarButtonItemStyleBordered target:self action:@selector(showConfigurePopover:)];
	[buttons addObject:cracksButton];
	[cracksButton release];
	
	UIBarButtonItem *pickImageButton = [[UIBarButtonItem alloc] initWithTitle:@"Palette" style:UIBarButtonItemStyleBordered target:self action:@selector(showPalettePopover:)];
	[buttons addObject:pickImageButton];
	[pickImageButton release];
	
	[toolbar setItems:buttons animated:NO];
}

- (void) showPalettePopover:(id) sender
{
	if ([popoverController isPopoverVisible]) {
		[popoverController dismissPopoverAnimated:YES];
		[self unpause];
		return;
	}
	
	[self pause];
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	[imagePicker setDelegate:self];
	popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
	[popoverController presentPopoverFromBarButtonItem:[toolbar.items objectAtIndex:1] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	Palette *newPalette = [Palette paletteFromUIImage:selectedImage];
	[renderer.substrate setPalette:newPalette];
	[popoverController dismissPopoverAnimated:YES];
	[self restart];
}

// <UIImagePickerControllerDelegate>
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[popoverController dismissPopoverAnimated:YES];
	[self unpause];
}

- (void) showConfigurePopover:(id) sender
{
	if ([popoverController isPopoverVisible]) {
		[popoverController dismissPopoverAnimated:YES];
		[self unpause];
		return;
	}
		
	[self pause];
	IASKAppSettingsViewController *settingsVC = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
	UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
	popoverController = [[UIPopoverController alloc] initWithContentViewController:settingsNavController];
	[settingsVC setDelegate:self];
	[popoverController presentPopoverFromBarButtonItem:[toolbar.items objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// <IASKSettingsDelegate>
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
	[popoverController dismissPopoverAnimated:YES];
	[self unpause];
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
