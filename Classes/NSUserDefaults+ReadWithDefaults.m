//
//  NSUserDefaults+ReadWithDefaults.m
//  Substrate
//
//  Created by Jonathan Cooper on 6/4/10.
//  Copyright 2010 Jon Cooper. All rights reserved.
//

#import "NSUserDefaults+ReadWithDefaults.h"

@implementation NSUserDefaults (ReadWithDefaults)

// Get our bundle's display name
+ (NSString *) getBundleDisplayName
{
	NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
	return prodName;
}

// See if there's an existing registration domain for our app
//
+ (BOOL) persistentDomainExists
{
	NSString *bundleName = [self getBundleDisplayName];
	NSArray *existingPersistentDomainNames = [[NSUserDefaults standardUserDefaults] persistentDomainNames];
	if ([existingPersistentDomainNames containsObject:bundleName]) {
		return YES;
	}
	else {
		return NO;
	}

}

// Set defaults from Settings.bundle/Root.plist if necessary.
// This will *NOT* save the settings; they will be registered in a temporary domain.
// This is useful if you wish to parameterize a bunch of settings in a plist but not create a Settings item.
//
+ (void) registerDefaultsFromSettingsBundleIfNecessary
{	
	if (![self persistentDomainExists]) {
		// Write defaults from settings bundle
		NSDictionary *defaultsFromSettingsBundle = [NSUserDefaults getDefaultsFromSettingsBundle];
		[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsFromSettingsBundle];
	}
}

// Load defaults from Settings.bundle/Root.plist; persist them if necessary
//
+ (void) persistDefaultsFromSettingsBundleIfNecessary
{
	if (![self persistentDomainExists]) {
		NSDictionary *defaultsFromSettingsBundle = [NSUserDefaults getDefaultsFromSettingsBundle];
		[[NSUserDefaults standardUserDefaults] setPersistentDomain:defaultsFromSettingsBundle forName:[self getBundleDisplayName]];
	}
}

// Generate a dictionary suitable for setting with [NSBundle -registerDefaults]
// 
//     [NSUserDefaults standardUserDefaults] registerDefaults:[NSUserDefaults getDefaultsFromSettingsBundle]];
//     [NSUserDefaults standardUserDefaults] synchronize];
//
+ (NSDictionary *) getDefaultsFromSettingsBundle
{		  
	NSString *settingsBundle = [[NSBundle mainBundle] bundlePath];
	settingsBundle = [settingsBundle stringByAppendingPathComponent:@"Settings.bundle"];
	settingsBundle = [settingsBundle stringByAppendingPathComponent:@"Root.plist"];
	
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:settingsBundle];
	NSArray *preferenceSpecifiers = [settingsDict objectForKey:@"PreferenceSpecifiers"];
	
	NSMutableDictionary *emittedDictionary = [NSMutableDictionary dictionary];
	NSDictionary *preferenceItem;
	for (preferenceItem in preferenceSpecifiers) {
		
		// Ignore groups
		NSString *pType = [preferenceItem objectForKey:@"Type"];
		if ([pType isEqual:@"PSGroupSpecifier"])
			continue;
		
		// Grab key name and default value
		NSString *pKey = [preferenceItem objectForKey:@"Key"];
		id *pDefaultValue = [preferenceItem objectForKey:@"DefaultValue"];
		
		// Add to emitted dictionary
		[emittedDictionary setObject:pDefaultValue forKey:pKey];
	}
	
	return (NSDictionary *) emittedDictionary;
}

- (NSInteger) integerForKey:(NSString *)key withDefault:(NSInteger)value
{
	if ([self objectForKey:key])
		return [self integerForKey:key];
	else
		return value;
}

- (BOOL) boolForKey:(NSString *)key withDefault:(BOOL)value
{
	if ([self objectForKey:key])
		return [self boolForKey:key];
	else
		return value;
}

- (float) floatForKey:(NSString *)key withDefault:(float)value
{
	if ([self objectForKey:key])
		return [self floatForKey:key];
	else
		return value;
}

- (id) objectForKey:(NSString *)key withDefault:(id)value
{
	id obj = [self objectForKey:key];
	if (obj)
		return obj;
	else
		return value;
}

@end
