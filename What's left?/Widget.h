//
//  Widget.h
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
typedef enum
{
    Balance,
    Spent,
    Saved,
    Claimable,
    DaysToEndOfMonth,
    LeftToSpend,
    LeftToSpendPerDay
}DisplayMode;
#import <UIKit/UIKit.h>
#import "Settings.h"

@interface Widget : UIButton

@property UIScreen *screen;
@property float hundredRelativePts;
@property float displayValue;
@property NSString *displayString;
@property DisplayMode displayMode;
@property Settings *thisSettings;

-(void)UpdateDisplay;
@end
