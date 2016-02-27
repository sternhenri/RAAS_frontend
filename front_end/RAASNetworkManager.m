//
//  NetworkManager.m
//  Journal
//
//  Created by Connor on 6/22/15.
//  Copyright (c) 2015 Shout. All rights reserved.
//

#import "RAASNetworkManager.h"
#import "AppDelegate.h"
#import "PConstants.h"
#import "RAASJSONResponseSerializer.h"
#import <SVProgressHUD.h>

#define USER_ERROR_MESSAGE "We're sorry, something went wrong."

@interface RAASNetworkManager() <UIAlertViewDelegate>
@property (nonatomic) BOOL alertShowing;
@property (nonatomic) BOOL loggingOut;
@end

@implementation RAASNetworkManager
//production -
//local - http://localhost:3000

+(RAASNetworkManager *)sharedClient {
    static RAASNetworkManager *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://162.243.151.156:3000"]];
    });
    return _sharedClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        self.responseSerializer = [RAASJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.alertShowing = NO;
        self.loggingOut = NO;
    }
    return self;
}

-(BOOL)processMetaTagsAndSuccess:(NSDictionary *)metaTags{
    NSInteger code = [[metaTags valueForKeyPath:@"meta.code"] integerValue];
    NSString *message = [metaTags valueForKey:@"meta.message"];
    
    if (code >= 200 && code < 300){
        [SVProgressHUD showSuccessWithStatus:message];
        return YES;
    }
    else {
        [SVProgressHUD showErrorWithStatus:message];
        return NO;
    }

}

@end