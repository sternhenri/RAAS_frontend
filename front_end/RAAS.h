//
//  RAAS.h
//  front_end
//
//  Created by Henri Stern on 26/02/16.
//  Copyright © 2016 Henri. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface RAAS : NSObject

+(RAAS *)inviteManagerWithIdentifier:(NSNumber *)clientID;
+(RAAS *)inviteManager;

-(void)associateToUserWithID:(NSNumber *)givenID andToken:(NSString *)givenToken;
-(void)associateToUserWithID:(NSNumber *)givenID;

- (void) trackRegistrationEvent;
- (void) trackRegistrationEventWithUserID:(NSNumber *)givenID;
- (void) checkDownloadEvent;


-(UIButton *) generateInviteButtonWithFrame:(CGRect)givenFrame andContainer:(UIViewController *)container;
-(UIButton *) generateInviteButtonWithTitle:(NSString *)givenPrompt andFrame:(CGRect)givenFrame andContainer:(UIViewController *)container;
-(UIButton *) generateInviteButtonWithImage:(UIImage *)givenImage andFrame:(CGRect)givenFrame andContainer:(UIViewController *)container;
@end
