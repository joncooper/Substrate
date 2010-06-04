//
//  PopoverHelper.h
//
//  Created by Tyler Neylon on 4/26/10.
//  Copyleft 2010 Bynomial.
//
//  Code to help manage popover controllers.
//
//  Suggested usage:
//
//  UIPopoverController *popover = [PopoverHelper popoverForViewController:myViewController];
//  [popover presentPopoverFromView:myView];
//
//  Dismiss programmatically via:
//
//  [popover dismissAndRelease];
//
//  The popover is retained/released by PopoverHelper, which also handles rotations for you.
//  If your source view (myView in the example) becomes hidden after a rotation,
//  the popover is dismissed and released for you.  If the user clicks outside the
//  popover, and not in a pass-through view, the popover is also released for you.
//
//  If you want to specify your own delegate, you must be sure that
//  [PopoverHelper discardPopover] is called after you dismiss the popover when you're
//  done with it; this performs all clean-up including releasing it.  Otherwise you
//  never have to explicitly call this method.
//

#import <Foundation/Foundation.h>


@interface PopoverHelper : NSObject <UIPopoverControllerDelegate> {}

+ (UIPopoverController *)popoverForViewController:(UIViewController *)viewController;

// Can be used as a delegate; it's only action is to call
// [PopoverHelper discardPopover] when it's dismissed.
+ (PopoverHelper *)popoverReleaserDelegate;

+ (void)discardPopover;

@end

@interface UIPopoverController (Present)

- (void)presentPopoverFromView:(UIView *)view;
- (void)dismissAndRelease;

@end
