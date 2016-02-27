#import <Foundation/Foundation.h>

@interface RAASSettings : NSObject

- (instancetype) initWithAttributes:(NSDictionary *)info;

@property BOOL isActive;
@property NSString *prompt;
@property NSString *thanks;
@property BOOL supportSMS;
@property BOOL supportEmail;
@property NSString *clientName;
@end

