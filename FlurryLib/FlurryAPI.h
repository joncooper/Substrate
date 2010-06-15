//
//  FlurryAPI.h
//  Flurry iPhone Analytics Agent
//
//  Copyright 2009 Flurry, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class CLLocationManager;
@class CLLocation;

@interface FlurryAPI : NSObject {
}

/*
 optional sdk settings that can be changed before start session
 */
+ (void)setAppCircleEnabled:(BOOL)value;		// default is NO
+ (void)setShowErrorInLogEnabled:(BOOL)value;	// default is NO

/*
 start session, attempt to send saved sessions to server 
 */
+ (void)startSession:(NSString *)apiKey;

/*
 log events or errors after session has started
 */
+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;
+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;
/* 
 start or end timed events
 */
+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)eventName;
/*
 count page views
 */
+ (void)countPageViews:(id)target;		// automatically track page view on UINavigationController or UITabBarController
+ (void)countPageView;					// manually increment page view by 1
/*
 set user info
 */
+ (void)setUserID:(NSString *)userID;	// user's id in your system
+ (void)setAge:(int)age;				// user's age in years

/*
 optional session settings that can be changed after start session
 */
+ (void)setSessionReportsOnCloseEnabled:(BOOL)sendSessionReportsOnClose;	// default is YES
+ (void)setAppVersion:(NSString *)version;
+ (void)setEventLoggingEnabled:(BOOL)value;		// default is YES

@end
