//
//  NetworkManager.h
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum {
    JNetworkErrorTypeServerUnavailable = 1011,
    JNetworkErrorTypeNetworkUnavailable = 1009,
    JNetworkErrorTypeNetworkSwitch = 1003,
    JNetworkErrorTypeAuthenticationError = 401,
    JNetworkErrorTypeFormatError = 406,
    JNetworkErrorTypeResourceNotFound = 404,
    JNetworkErrorTypeOtherError,
    JNetworkErrorTypeRestrictedAccess = 403,
    JNetworkErrorTypeUnknownError = 1
} JNetworkErrorType;

@interface RAASNetworkManager : AFHTTPSessionManager

+(RAASNetworkManager *)sharedClient;
-(BOOL)processMetaTagsAndSuccess:(NSDictionary *)metaTags;

@end