//
//  MoneyManager.h
//  What's left?
//
//  Created by Swee Har Ng on 16/7/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bank.h"
@interface MoneyManager : NSObject

@property float spentThisMonth;
-(NSInteger)DaysLeftInMonth;
-(float)LeftToSpendThisMonth;

-(float)LeftToSpendEachDayAverage;
-(float)SpentEachDayAverage;
-(float)CalculateBalance:(NSArray *)eventArray;
-(float)CalculateExpenditure:(NSArray *)eventArray;
-(float)CalculateClaimable:(NSArray *)eventArray;

@property NSDate *payDate;
@property float payAmount;
@property float expenditureLimitGoal;
@property NSDate *lastExpGoalSetDate;
@property float savingsGoal;
@property NSDate *lastSavingsGoalSetDate;
@end
