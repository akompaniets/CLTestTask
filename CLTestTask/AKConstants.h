//
//  AKConstants.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserHandlingStatus) {
    DidStartUserHandling = 0,
    DidFinishUserHandling = 1,
};

#define ErrorColor [UIColor colorWithRed:236./255. green:85./255. blue:85./255. alpha:1.0]
#define WarningColor [UIColor colorWithRed:237./255. green:236./255. blue:121./255. alpha:1.0]
#define SuccessColor [UIColor colorWithRed:80./255. green:195./255. blue:84./255. alpha:1.0]
#define CustomFont [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
#define isNetworkAvailable [[AKNetworkManager sharedManager] reachability].isReachable
#define NormalButtonColor [UIColor colorWithRed:0 green:122.0/255. blue:255.0/255. alpha:1.0]
#define HighlightedButtonColor [UIColor colorWithRed:198./255. green:222.0/255. blue:249.0/255. alpha:1.0]
#define DisabledButtonColor [UIColor colorWithRed:196./255. green:196.0/255. blue:196.0/255. alpha:1.0]

@interface AKConstants : NSObject

extern NSString *URL;
extern NSString *AKNetworkManagerReachabilityStatusDidChangeNotification;
extern NSString *AKRandomUsersListModelDidChangeUserHandlingStatusNotification;
extern NSString *FriendDetailSegue;
extern NSString *PlaceholderImage;

@end
