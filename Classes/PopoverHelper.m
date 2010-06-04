//
//  PopoverHelper.m
//
//  Created by Tyler Neylon on 4/26/10.
//  Copyleft 2010 Bynomial.
//

#import "PopoverHelper.h"

// strong
static UIPopoverController *popover = nil;
static UIView *sourceView = nil;
static UIDeviceOrientation lastOrientation = UIDeviceOrientationUnknown;

@implementation PopoverHelper

+ (UIPopoverController *)popoverForViewController:(UIViewController *)viewController {
  NSAssert(popover == nil, @"Attept to make popover while one is active; PopoverHelper only works with one at a time.");
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
  popover.delegate = [PopoverHelper popoverReleaserDelegate];
  return popover;
}

+ (void)discardPopover {
  if (popover == nil) return;
  [popover autorelease];
  popover = nil;
  [sourceView release];
  sourceView = nil;
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

+ (PopoverHelper *)popoverReleaserDelegate {
  static PopoverHelper *instance = nil;
  if (instance == nil) instance = [[PopoverHelper alloc] init];
  return instance;
}

+ (void)load {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(orientationDidChange:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
}

+ (void)updatePopoverForNewOrientation {
  UIView *view = sourceView;
  while (![view isKindOfClass:[UIWindow class]]) {
    if (view == nil || view.hidden) {
      // The source view is hidden, so we discard the popover.
      [popover dismissAndRelease];
      return;
    }
    view = view.superview;
  }
  [popover presentPopoverFromView:sourceView];
}

+ (void)orientationDidChange:(NSNotification *)note {
  UIDeviceOrientation newOrientation = [UIDevice currentDevice].orientation;
  if (newOrientation == UIDeviceOrientationUnknown ||
      newOrientation == lastOrientation) {
    return;
  }
  if (!UIDeviceOrientationIsPortrait(newOrientation) &&
      !UIDeviceOrientationIsLandscape(newOrientation)) {
    return;
  }
  lastOrientation = newOrientation;
  [self performSelector:@selector(updatePopoverForNewOrientation)
             withObject:nil afterDelay:0.0];
}

#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [PopoverHelper discardPopover];
}

@end


@implementation UIPopoverController (Present)

- (void)presentPopoverFromView:(UIView *)view {
  sourceView = [view retain];
  self.popoverContentSize = self.contentViewController.view.frame.size;
  [self presentPopoverFromRect:sourceView.frame inView:sourceView.superview
      permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dismissAndRelease {
  [popover dismissPopoverAnimated:NO];
  [PopoverHelper discardPopover];
}

@end
