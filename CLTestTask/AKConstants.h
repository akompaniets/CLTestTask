//
//  AKConstants.h
//  CLTestTask
//
//  Created by Mobindustry on 6/22/15.
//  Copyright (c) 2015 ARC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AKAlertViewSeverity) {
    AKAlertViewSeverityError = 0,
    AKAlertViewSeverityWarning = 1,
    AKAlertViewSeveritySuccess = 2
};

#define ErrorColor [UIColor colorWithRed:236./255. green:85./255. blue:85./255. alpha:1.0]
#define WarningColor [UIColor colorWithRed:237./255. green:236./255. blue:121./255. alpha:1.0]
#define SuccessColor [UIColor colorWithRed:80./255. green:195./255. blue:84./255. alpha:1.0]

@interface AKConstants : NSObject

extern NSString *URL;



@end
