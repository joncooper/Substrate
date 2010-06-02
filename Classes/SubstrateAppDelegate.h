//
//  SubstrateAppDelegate.h
//  Substrate
//
//  Created by Jonathan Cooper on 5/25/10.
//  Copyright Jon Cooper 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstrateVC.h"

@interface SubstrateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SubstrateVC *substrateVC;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SubstrateVC *substrateVC;

@end

