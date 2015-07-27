#import <Foundation/Foundation.h>
#import "Constants.h"

@interface KeyChain : NSObject 

+ (int)storeWithUsername: (NSString *)Username WithPassword:(NSString *)Password;
+ (int)updateWithUsername: (NSString *)Username WithPassword:(NSString *)Password;
+ (NSDictionary *)getDataWithUsername: (NSString *)Username;

+ (void)deleteAllKeysForSecClass:(CFTypeRef)secClass;

@end
