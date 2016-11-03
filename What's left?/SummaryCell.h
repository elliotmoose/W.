//
//  SummaryCell.h
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
typedef enum
{
    Balance,
    Spent,
    LeftToSpend,
    LeftToSpendPerDay,
    Claimable,
    DaysToEndOfMonth
}DisplayMode;

typedef enum
{
    ThisMonth,
    AllTime,
    EachDayAverage,
    ThisPayCycle
}TimeFrame;

#import <UIKit/UIKit.h>
#import "Settings.h"
@interface SummaryCell : UITableViewCell
@property UIScreen *screen;
@property float hundredRelativePts;
@property float displayValue;
@property float displayMaxValue;
@property NSString *displayString;
@property DisplayMode displayMode;
@property TimeFrame timeFrame;
@property Settings *thisSettings;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *CellText;
-(void)UpdateDisplay;
@property (weak, nonatomic) IBOutlet UILabel *type2MainLabel;
@property (weak, nonatomic) IBOutlet UILabel *type2SecLabel;

-(void)initFromLoad;
@end
