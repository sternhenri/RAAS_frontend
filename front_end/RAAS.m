//
//  RAAS.m
//  front_end
//
//  Created by Henri Stern on 26/02/16.
//  Copyright © 2016 Henri. All rights reserved.
//

#import "RAAS.h"
#import "RAASNetworkManager.h"
#import "RAASSettings.h"
#import "SVProgressHUD.h"
#import "RAASButton.h"
#import <MessageUI/MessageUI.h>

@interface RAAS() <UIActivityItemSource>
@property (nonatomic) NSNumber *clientID;
@property (nonatomic) NSString *userToken;
@property (nonatomic, strong) RAASSettings *settings;
@property (nonatomic) NSString *currentCode;
@property (nonatomic) NSNumber *userID;
@end

@implementation RAAS

+(RAAS *)inviteManagerWithIdentifier:(NSNumber *)clientID{
    
    RAAS *manager = [self inviteManager];
    manager.clientID = clientID;
    manager.userToken = @"";
    manager.userID = @-1;
    [manager configure];
    return manager;
}

+(RAAS *)inviteManager {
    static RAAS *_inviteManager = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _inviteManager = [[self alloc] init];
        
    });
    return _inviteManager;
}

- (void) configure{
    RAASNetworkManager *client = [RAASNetworkManager sharedClient];
    
    id params = @{@"client_id": self.clientID
                  };
    
    NSString *path = [NSString stringWithFormat:@"/referrals/configure.json"];
    
    [client GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Got configs");
        self.settings = [[RAASSettings alloc] initWithAttributes:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"settingsReceived" object:self];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Got shit");
    
    }];

}

-(void)associateToUserWithID:(NSNumber *)givenID andToken:(NSString *)givenToken{
    self.userToken = givenToken;
    self.userID = givenID;
}

-(void)associateToUserWithID:(NSNumber *)givenID{
    self.userID = givenID;
}

- (void) fetchCode{
    RAASNetworkManager *client = [RAASNetworkManager sharedClient];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"client_id": self.clientID}];
    
    if (![self.userToken isEqualToString:@""])
        [params setObject:self.userToken forKey:@"user_token"];
    if (![self.userID isEqualToNumber:@-1])
        [params setObject:self.userID forKey:@"user_id"];

    
    NSString *path = [NSString stringWithFormat:@"/referrals/initiate.json"];
    
    [client GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.currentCode = [responseObject objectForKey:@"code"];
        NSLog(@"Got code");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Got crap");
        
    }];
    
}

- (void) codeSent:(NSString *)givenType{
    RAASNetworkManager *client = [RAASNetworkManager sharedClient];

    givenType = [givenType isEqualToString:UIActivityTypeMail] ? @"mail" : @"sms";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"client_id": self.clientID,
                                                                                    @"code": self.currentCode,
                                                                                    @"code_type": givenType}];
    
    if (![self.userID isEqualToNumber:@-1])
        [params setObject:self.userID forKey:@"user_id"];
    
    NSString *path = [NSString stringWithFormat:@"/referrals/sent.json"];
    
    [client POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Sent code");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Got failure");
        
    }];
}

- (void) trackLaunch{
    RAASNetworkManager *client = [RAASNetworkManager sharedClient];

    id params = @{@"client_id": self.clientID
                  };
    
    NSString *path = [NSString stringWithFormat:@"/referrals/download.json"];
    
    [client PUT:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Got failure");
    }];
}

-(void)newUserRegistrationWithID:(NSNumber *)givenID{
    self.userID = givenID;
    RAASNetworkManager *client = [RAASNetworkManager sharedClient];
    id params = @{@"client_id": self.clientID,
                  @"user_id": givenID
                  };
    NSString *path = [NSString stringWithFormat:@"/referrals/registration.json"];
    
    [client PUT:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Got failure");
    }];
}


- (void) checkDownloadEvent{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"RAASFirstLaunch"])
    {
        [self trackLaunch];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RAASFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (UIButton *) generateInviteButtonWithFrame:(CGRect)givenFrame andContainer:(UIViewController *)createdIn{
    return [self generateInviteButtonWithImage:[UIImage imageNamed:@"shareButton"] andFrame:givenFrame andContainer:createdIn];
}

- (UIButton *) generateInviteButtonWithTitle:(NSString *)givenPrompt andFrame:(CGRect)givenFrame andContainer:(UIViewController *)createdIn{
    UIButton *refButton = [self generateButtonWithFrame:givenFrame andContainer:createdIn];
    [refButton setBackgroundColor:[UIColor blueColor]];
    [refButton setTitle:givenPrompt forState:UIControlStateNormal & UIControlStateSelected];
    [refButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected];
    return refButton;
}

- (UIButton *) generateInviteButtonWithImage:(UIImage *)givenImage andFrame:(CGRect)givenFrame andContainer:(UIViewController *)createdIn{
    UIButton *refButton = [self generateButtonWithFrame:givenFrame andContainer:createdIn];
    [refButton setBackgroundImage:givenImage forState:UIControlStateNormal & UIControlStateSelected];
    return refButton;
}

- (UIButton *) generateButtonWithFrame:(CGRect)givenFrame andContainer:(UIViewController *)createdIn{
    
    RAASButton *refButton = [[RAASButton alloc] initWithFrame:givenFrame];
    refButton.container = createdIn;
    
    [refButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [refButton setBackgroundColor:[UIColor clearColor]];
    
    refButton.hidden = !self.settings.isActive;
    [refButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];

     return refButton;
}


- (void) share:(RAASButton *)sender{
    
    [self fetchCode];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self] applicationActivities:nil];
    NSMutableArray *exclude = [[NSMutableArray alloc] initWithArray:@[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeOpenInIBooks, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter]];
    
    if (!self.settings.supportEmail){
        [exclude addObject:UIActivityTypeMail];
    }
    if (!self.settings.supportSMS){
        [exclude addObject:UIActivityTypeMessage];
    }
    
    controller.excludedActivityTypes = exclude;
    controller.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *items, NSError *e) {
        if (completed){
            [self codeSent:activityType];
            [self dismissedPopupView:sender];
        }
    };

    [sender.container presentViewController:controller animated:YES completion:nil];
}

-(void)dismissedPopupView:(RAASButton *)sender{
    [sender.container.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:self.settings.thanks];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSString *assembledLink = [NSString stringWithFormat:@"%@/referrals/%@/%@", @"http://162.243.151.156:3000", self.settings.clientName, self.currentCode];
    
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:self.settings.prompt];
        [str addAttribute: NSLinkAttributeName value: assembledLink range: NSMakeRange(0, str.length)];
        return str;
    }
    else{
        return [NSString stringWithFormat:@"%@ %@", self.settings.prompt, assembledLink];
    }
    
}

-(id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController{
    return @"";
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController
              subjectForActivityType:(NSString *)activityType{
    
    return @"A Great Product";
}

@end
