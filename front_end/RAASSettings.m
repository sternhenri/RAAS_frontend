#import "RAASSettings.h"

@implementation RAASSettings

- (instancetype) initWithAttributes:(NSDictionary *)info{
    self = [super init];
    
    if (self){
        
        self.isActive = [[info valueForKeyPath:@"settings.is_active"] boolValue];
        if (self.isActive){
            self.supportEmail = [[info valueForKeyPath:@"settings.support_email"] boolValue];
            self.supportSMS = [[info valueForKeyPath:@"settings.support_sms"] boolValue];
            
            self.thanks = [info valueForKeyPath:@"settings.referral_thanks"];
            self.prompt = [info valueForKeyPath:@"settings.referral_prompt"];
            self.clientName = [[info valueForKeyPath:@"entity_name"] lowercaseString];
        }
    }
    return self;
}

@end
