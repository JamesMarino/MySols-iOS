#include "KeyChain.h"

@interface KeyChain ()



@end

@implementation KeyChain

+ (int)storeWithUsername:(NSString *)Username WithPassword:(NSString *)Password
{
	/**
	 * Error Handling:
	 * 0 = No Error
	 * !0 = Error
	 */
	
	// Empty Dictionary
	NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
	
	/*
	 * Populate the keychain
	 */
	// Specify what keychain this is
	keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
	// Allow only under unlocked screen
	keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
	// Store Items
	keychainItem[(__bridge id)kSecAttrServer] = SOLS_LOGIN_URL;
	keychainItem[(__bridge id)kSecAttrAccount] = Username;
	
	
	// Check if Item Exists
	if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
		
		// Call update routine
		NSLog(@"Status: Already Stored");
		[self updateWithUsername:Username WithPassword:Password];
		
	} else {
		// Store Password
		keychainItem[(__bridge id)kSecValueData] = [Password dataUsingEncoding:NSUTF8StringEncoding];
		
		// Store item, return status
		OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
		
		// If not 0, error has occured
		NSLog(@"Status: %d", (int)status);
		
		if ((int)status == 0) {
			return (int)status;
		} else {
			return (int)status;
		}
		
	}
	
	return 1;
}

+ (int)updateWithUsername:(NSString *)Username WithPassword:(NSString *)Password
{
	/**
	 * Error Handling:
	 * 0 = No Error
	 * !0 = Error
	 */
	
	// Empty Dictionary
	NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
	
	/*
	 * Populate the keychain
	 */
	// Specify what keychain this is
	keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
	// Allow only under unlocked screen
	keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
	// Store Items
	keychainItem[(__bridge id)kSecAttrServer] = SOLS_LOGIN_URL;
	keychainItem[(__bridge id)kSecAttrAccount] = Username;
	
	
	// Check if Item Exists
	if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
		
		// The item is found
		NSLog(@"Status: Updating");
		
		// Update the keychain item
		NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
		attributesToUpdate[(__bridge id)kSecValueData] = [Password dataUsingEncoding:NSUTF8StringEncoding];
		
		OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
		
		NSLog(@"Status: %d", (int)status);
		
		return (int)status;
		
	} else {
		
		// Item does not exist
		return 1;
		
	}
	
	return 1;
}

+ (NSDictionary *)getDataWithUsername: (NSString *)Username
{
	// Empty Dictionary
	NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
	
	/*
	 * Populate the keychain
	 */
	@try {
		// Specify what keychain this is
		keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
		// Allow only under unlocked screen
		keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
		// Store Items
		keychainItem[(__bridge id)kSecAttrServer] = SOLS_LOGIN_URL;
		keychainItem[(__bridge id)kSecAttrAccount] = Username;
		
		// Check if this keychain item exists
		keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
		keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
	}
	@catch (NSException *exception) {
		// Error Storing Value
		
		NSLog(@"Error Storing Value");
	}
	
	// Get Results
	CFDictionaryRef result = nil;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
	
	NSLog(@"Status: %d", (int)status);
	
	// Make Empty Dictionary
	NSDictionary *resultDict = NULL;
	
	if(status == noErr) {
		resultDict = (__bridge_transfer NSDictionary *)result;
		
		return resultDict;
	} else {
		return resultDict;
	}
}

+ (void)deleteAllKeysForSecClass:(CFTypeRef)secClass
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	[dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
	
	SecItemDelete((__bridge CFDictionaryRef) dict);
}

@end
