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
#import "FlurryAPI.h"
#import "InfoBox.h"

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
	aboutBoxIsDisplayed = NO;
}

// A touch has finished
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *touch = [[event allTouches] anyObject];
	if (aboutBoxIsDisplayed) {
		if (CGRectContainsPoint(aboutBox.frame, [touch locationInView:glView])) {
			[self hideInfoBox];
			return;
		}
	}
	if ([touch tapCount] == 2) {
		[self restart];
	}
	else {
		[self togglePause];
	}
}

- (void) restart
{
	[FlurryAPI logEvent:@"Started a new drawing"];
	
	[self pause];
	[glView stopAnimation];
	[renderer clearAndRestart];
	[self unpause];
	[glView startAnimation];
}

- (void) togglePause
{
	if (animating) {
		[self pause];
	}
	else {
		[self unpause];
	}
}

- (void) pause
{
	[pausedLabel setTitle:@"PAUSED"];
	[renderer pause];
	animating = NO;
}

- (void) unpause
{
	[pausedLabel setTitle:@""];
	[renderer unpause];
	animating = YES;
}

- (void) setupToolbar
{
	NSMutableArray *buttons = [NSMutableArray array];
	
	// UIBarButtonItem *cracksButton = [[UIBarButtonItem alloc] initWithTitle:@"Configure" style:UIBarButtonItemStyleBordered target:self action:@selector(showConfigurePopover:)];
	UIBarButtonItem *cracksButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20-gear2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showConfigurePopover:)];
	[buttons addObject:cracksButton];
	[cracksButton release];
	
	// UIBarButtonItem *pickImageButton = [[UIBarButtonItem alloc] initWithTitle:@"Palette" style:UIBarButtonItemStyleBordered target:self action:@selector(showPalettePopover:)];
	UIBarButtonItem *pickImageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"98-palette.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showPalettePopover:)];
	[buttons addObject:pickImageButton];
	[pickImageButton release];
	
	UIBarButtonItem *savePictureImageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"86-camera.png"] style:UIBarButtonItemStylePlain target:self action:@selector(savePicture:)];
	[buttons addObject:savePictureImageButton];
	[savePictureImageButton release];
	
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttons addObject:spacer];
	[spacer release];
	
	pausedLabel = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];						
	[buttons addObject:pausedLabel];
			
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(showInfoBox:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[buttons addObject:infoBarButton];
	[infoBarButton release];
	
	[toolbar setItems:buttons animated:NO];
}

- (void) showInfoBox:(id) sender
{
	if (aboutBoxIsDisplayed) {
		[self hideInfoBox];
		return;
	}
	
	[FlurryAPI logEvent:@"About box showed"];
	
	aboutBoxIsDisplayed = YES;
	UIImage *aboutBoxImage = [UIImage imageNamed:@"AboutBox.png"];
	
	// Center
	
	aboutBox = [[UIImageView alloc] initWithImage:aboutBoxImage];
	CGRect frame = CGRectMake(glView.center.x - (aboutBox.frame.size.width / 2), 
							  glView.center.y - (aboutBox.frame.size.height / 2), 
							  aboutBox.frame.size.height, 
							  aboutBox.frame.size.width);
	
	aboutBox.frame = frame;
	aboutBox.alpha = 0.0;
	[glView addSubview:aboutBox];
	
	// Fade in
	
	[UIView beginAnimations:@"AboutBoxFadeIn" context:(void *)aboutBox];
	[UIView setAnimationDuration:1.0f];
	aboutBox.alpha = 1.0;
	[UIView commitAnimations];
}

- (void) hideInfoBox
{
	// Fade out
	[UIView beginAnimations:@"AboutBoxFadeOut" context:(void *)aboutBox];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(infoBoxDidFinishFadingOut:finished:context:)];
	aboutBox.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) infoBoxDidFinishFadingOut:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	aboutBoxIsDisplayed = NO;
	[aboutBox removeFromSuperview];
	[aboutBox release];
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
	[FlurryAPI logEvent:@"Palette chosen from image"];
	
	[picker release];
	[popoverController dismissPopoverAnimated:YES];
	
	UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	Palette *newPalette = [Palette paletteFromUIImage:selectedImage];
	[renderer.substrate setPalette:newPalette];
		
	[self restart];
}

// <UIImagePickerControllerDelegate>
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker release];
	[popoverController dismissPopoverAnimated:YES];
	[self unpause];
}

- (void) savePicture:(id) sender
{
	[FlurryAPI logEvent:@"Screenshot taken"];
	
	// Ugly traversal, but it works.
	UIImage *viewImage = [renderer.substrate.fbPainter.fb getBufferAsUIImage];
	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
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
	[FlurryAPI logEvent:@"Configuration dialog closed"];
	[popoverController dismissPopoverAnimated:YES];
	[self unpause];
}

// Any orientation is okay - rotation is handled by autoresize mask and the renderer
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/*
// Handle rotation
//
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	CGRect bounds = [glView bounds];
	CGRect frame = [glView frame];
	NSLog(@"didRotate:\nbounds: %@\nframe: %@", NSStringFromCGRect(bounds), NSStringFromCGRect(frame));
	
	BOOL eh = ([glView contentMode] == UIViewContentModeScaleToFill);
	NSLog(@"%i", eh);
}
*/

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
	[toolbar release];
	[pausedLabel release];
    [super dealloc];
}


@end
