#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseDataKey = @"JSONResponseSerializerSHData";

@interface RAASJSONResponseSerializer : AFJSONResponseSerializer

@end
