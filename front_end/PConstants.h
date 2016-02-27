//
//  Constants.h
//  
//
//  Created by Connor on 6/22/15.
//
//

#import <Foundation/Foundation.h>

//simulator?
#ifdef __APPLE__
#include "TargetConditionals.h"
#endif


//Constants
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IS_IPHONE_4 SCREEN_HEIGHT == 480.0f
#define IS_IPHONE_5 SCREEN_HEIGHT == 568.0f
#define IS_IPHONE_6 SCREEN_HEIGHT == 667.0f
#define IS_IPHONE_6PLUS SCREEN_HEIGHT == 736.0f

#define IMAGE_COMPRESSION_RATE 0.1f


#define IS_IOS7       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)

#define IS_IOS8       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define TOOLBAR_HEIGHT 44.0f
#define TABBAR_HEIGHT 49.0f
#define NAVBAR_HEIGHT 64.0f

#define IPHONE_6PLUS_KEYBOARD_ORIGIN 510.f
#define IPHONE_6_KEYBOARD_ORIGIN 451.f
#define IPHONE_5_KEYBOARD_ORIGIN 352.f
#define IPHONE_4_KEYBOARD_ORIGIN 264.f

#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")

//Utility
static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}


