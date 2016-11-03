//
//  Bank.h
//  What's left?
//
//  Created by Swee Har Ng on 14/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@protocol bankDelegate <NSObject>

@end

@interface Bank : NSObject
{
}

-(void)AddEvent: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags;
-(void)EditEvent:(Event*) event withName: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags;

-(void)initFromLoad;
-(void)LoadAllMonthsArray;
-(void)LoadAllTags;
-(NSMutableArray*)ThisMonthEvents;


-(void)CalculateBalance;
-(void)ArrangeAndSplitByMonth: (NSMutableArray*) Input withOutput: (NSMutableArray*) Output;
-(void)ArrangeAndSplitByPayCycle: (NSMutableArray*) Input withOutput: (NSMutableArray*) Output;

-(NSInteger)NumberOfMonths;
-(NSInteger)MonthFromDate: (NSDate*) date;
-(NSInteger)YearFromDate: (NSDate*) date;
-(NSString*)MonthAndYearFromDate: (NSDate*) date;
-(float)CalculateMonthBalance: (NSArray*) month;
-(float)CalculateMonthExpenditure: (NSArray*) month;
-(float)CalculateMonthClaimable:(NSArray*)month;
-(float)CalculateSpendingByTag: (NSString*) tag;
-(float)CalculateSpendingByMonthAndYear: (NSString*) MonthAndYear;
-(float)CalculateSpendingByMonthByTag: (NSString*) tag withMonthAndYear: (NSString*) MonthAndYear;

-(float)ThisMonthExpenditure;
+(Bank*)Singleton;
@property float Balance;
@property float claimableBalance;
@property NSMutableArray *events;
@property NSMutableArray *eventsInMonths;
@property NSMutableArray *eventsInPayCycle;
@property NSInteger noOfMonths;
@property NSInteger noOfPayCycles;
@property NSMutableArray *allTags;
@property NSMutableArray *allMonthsDatesString;

@property (weak,nonatomic) id<bankDelegate> delegate;
@end
