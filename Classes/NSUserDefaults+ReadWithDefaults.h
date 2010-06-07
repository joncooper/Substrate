//
//  NSUserDefaults+ReadWithDefaults.h
//  Substrate
//
//  Created by Jonathan Cooper on 6/4/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObject.h>

@interface NSUserDefaults (ReadWithDefaults) 

+ (NSDictionary *) getDefaultsFromSettingsBundle;
- (NSInteger) integerForKey:(NSString *)key withDefault:(NSInteger)value;
- (BOOL)      boolForKey:(NSString *)key    withDefault:(BOOL)value;
- (float)     floatForKey:(NSString *)key   withDefault:(float)value;
- (id)        objectForKey:(NSString *)key  withDefault:(NSObject*)value;

@end
