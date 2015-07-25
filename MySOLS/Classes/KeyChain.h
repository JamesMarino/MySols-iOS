#import <Foundation/Foundation.h>

@interface KeyChain : NSObject 

+ (int)storeWithUsername: (NSString *)Username WithPassword:(NSString *)Password;
+ (int)updateWithUsername: (NSString *)Username WithPassword:(NSString *)Password;
+ (NSDictionary *)getDataWithUsername: (NSString *)Username;

@end
