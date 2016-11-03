//
//  MoneyManager.m
//  What's left?
//
//  Created by Swee Har Ng on 16/7/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "MoneyManager.h"
static MoneyManager *singleton;
@implementation MoneyManager
@synthesize spentThisMonth;
@synthesize expenditureLimitGoal;
@synthesize payAmount;
@synthesize payDate;
@synthesize savingsGoal;
-(id)init
{
    if (singleton == nil) {
        singleton = self;
    }
    return singleton;
}

-(NSInteger)DaysLeftInMonth
{
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:today];
     NSUInteger totalNumberOfDaysThisMonth = days.length;
     return (totalNumberOfDaysThisMonth - [c component:NSCalendarUnitDay fromDate:today]);
    

}
-(NSInteger)DaysPassedInMonth
{
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:today];
    return [c component:NSCalendarUnitDay fromDate:today];
}
//====================================================
//              Month Calculation Functions
//====================================================
-(float)LeftToSpendThisMonth
{
    float output;
    
    NSMutableArray * thisMonthEvents = [[NSMutableArray alloc]init];
    Bank *thisBank = [Bank Singleton];
    thisMonthEvents = [thisBank ThisMonthEvents];
    spentThisMonth = [thisBank CalculateMonthExpenditure: thisMonthEvents];
    
    output = (expenditureLimitGoal + spentThisMonth);
    
    return output;
}

-(float)CalculateExpenditure:(NSArray *)eventArray
{
    float output = 0;
    for (int i = 0; i < eventArray.count; i ++) {
        Event *thisEvent = [eventArray objectAtIndex:i];
        
        if (thisEvent.eventType == -1) {
            output -= thisEvent.eventValue;
        }
    }
    return output;
}
-(float)CalculateBalance:(NSArray *)eventArray
{
    float output = 0;
    for (int i = 0; i < eventArray.count; i ++) {
        Event *thisEvent = [eventArray objectAtIndex:i];

        if (thisEvent.eventType == -1) {
            output -= fabsf(thisEvent.eventValue);
        }
        else if(thisEvent.eventType == 1 )
        {
            output += thisEvent.eventValue;
        }
        else if (thisEvent.eventType == 0)
        {
            output -= fabsf(thisEvent.eventValue);
        }

    }
    return output;
}
-(float)CalculateClaimable:(NSArray *)eventArray
{
    float output = 0;
    for (int i = 0; i < eventArray.count; i ++) {
        Event *thisEvent = [eventArray objectAtIndex:i];
        if (thisEvent.eventType == 0)
        {
            output += fabsf(thisEvent.eventValue);
        }
        
    }
    return output;
}
-(float)LeftToSpendEachDayAverage
{
    float output;

    spentThisMonth = [self CalculateExpenditure: [Bank Singleton].ThisMonthEvents];
    
    output = (expenditureLimitGoal + spentThisMonth)/[self DaysLeftInMonth];
    
    return output;
}
-(float)SpentEachDayAverage
{
    float output;
    
    spentThisMonth = [self CalculateExpenditure: [Bank Singleton].ThisMonthEvents];
    
    output = (spentThisMonth)/[self DaysPassedInMonth];
    
    return output;
}

@end
