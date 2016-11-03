//
//  Bank.m
//  What's left?
//
//  Created by Swee Har Ng on 14/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "Bank.h"
@implementation Bank
@synthesize events;
@synthesize noOfMonths;
@synthesize noOfPayCycles;
@synthesize Balance;
@synthesize eventsInMonths;
@synthesize allTags;
@synthesize allMonthsDatesString;
@synthesize claimableBalance;
-(id)init
{

    return self;
}

+(Bank*)Singleton
{
    static Bank *bankSingleton = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken,^{
    
        bankSingleton = [[Bank alloc]init];
        bankSingleton.events = [[NSMutableArray alloc]init];
        bankSingleton.eventsInMonths = [[NSMutableArray alloc]init];
        bankSingleton.allTags = [[NSMutableArray alloc]init];
         bankSingleton.allMonthsDatesString = [[NSMutableArray alloc]init];
    });
    
    return bankSingleton;
}
-(void)initFromLoad
{
    if (events == nil) {
        events  = [[NSMutableArray alloc] init];
    }
    
    if (eventsInMonths == nil) {
        eventsInMonths  = [[NSMutableArray alloc] init];
    }
    

    
    if (allTags == nil) {
        allTags = [[NSMutableArray alloc]init];
    }
    
    if (allMonthsDatesString == nil) {
        allMonthsDatesString = [[NSMutableArray alloc]init];
    }
    
    
    [self LoadAllTags];
    [self LoadAllMonthsArray];
}

-(void)CalculateBalance
{
    Balance = 0;
    claimableBalance = 0;
    for (int i = 0; i < events.count; i ++) {
        Event *thisEvent = events[i];
        
        if (thisEvent.eventType != 0) {
            Balance += thisEvent.eventValue*thisEvent.eventType;
        }
        else
        {
            Balance -= thisEvent.eventValue;
            claimableBalance += thisEvent.eventValue;
        }
    }
}

-(NSInteger)MonthFromDate: (NSDate*) date
{
    NSInteger output =[[[[date description]substringToIndex:7]substringFromIndex:5] integerValue];
    return output;
}
-(NSInteger)YearFromDate: (NSDate*) date
{
    NSInteger output = [[[[date description]substringToIndex:4]substringFromIndex:0] integerValue];
    return output;
}
-(NSString*)MonthAndYearFromDate: (NSDate*) date
{
    NSString *output = [[[date description]substringToIndex:7]substringFromIndex:0];
    return output;
}
-(void)LoadAllMonthsArray
{
    for (Event *event in events) {
        NSString *dateString = [self MonthAndYearFromDate:event.eventDate];
        if (![allMonthsDatesString containsObject:dateString]) {
            [allMonthsDatesString addObject:dateString];
        }
    }
    
    [allMonthsDatesString sortUsingComparator:^NSComparisonResult(NSString *obj1,NSString *obj2){
        return [obj2 compare:obj1];
    }];
}

-(void)ArrangeAndSplitByPayCycle: (NSMutableArray*) Input withOutput: (NSMutableArray*) Output
{

    NSMutableArray *breakPoints = [[NSMutableArray alloc]init];
    //organizeD by date
    [Output removeAllObjects];
    
    noOfPayCycles = 0;
    
    if (Input.count == 1) {
        [Output addObject: [Input copy]];
    }
    
    if (Input.count > 0) {
        noOfPayCycles = 1;
    }
    
    [Input sortUsingComparator:^NSComparisonResult(Event *obj1, Event *obj2){
        return [obj2.eventDate compare:obj1.eventDate];
    }];
    
    for (int i = 1; i < Input.count; i ++) {
        Event *thisEvent = Input[i];
        Event *prevEvent = Input[i-1];
        
        BOOL isBreakpt = NO;
        if (![self IsFromSamePayCycle:thisEvent witheventB:prevEvent]) {
            isBreakpt = YES;
        }
        
        
        //check if its a new pay cycle
        
        
        if (isBreakpt) {
            NSNumber *number = [NSNumber numberWithInt:i];
            [breakPoints addObject:number];
            noOfPayCycles += 1;
        }
    }
    
    //for each breakpoint create an array (month)
    for (int x = 0; x<[breakPoints count]; x++) {
        NSMutableArray *thisPayCycle = [[NSMutableArray alloc]init];
        
        //split the events array using this break point
        NSNumber *thisBreakNumber = breakPoints[x];
        int thisBreakPoint = [thisBreakNumber intValue];
        
        if (x == 0) {
            thisPayCycle = [NSMutableArray arrayWithArray: [Input subarrayWithRange: NSMakeRange(0, thisBreakPoint)]];
        }
        else
        {
            NSNumber *prevBreakNumber = breakPoints[x-1];
            int prevBreakPoint = [prevBreakNumber intValue];
            thisPayCycle = [NSMutableArray arrayWithArray: [Input subarrayWithRange: NSMakeRange(prevBreakPoint, thisBreakPoint - prevBreakPoint)]];
        }
        
        if (thisPayCycle != nil) {
            [Output addObject:thisPayCycle];
        }
    }
    
    //add in last month (those after last breakpt)
    if (breakPoints.count != 0) {
        NSNumber *lastBreakNumber = breakPoints[breakPoints.count-1];
        int lastBreakPoint = [lastBreakNumber intValue];;
        NSMutableArray *lastPayCycle = [[NSMutableArray alloc]initWithArray:[Input subarrayWithRange:NSMakeRange(lastBreakPoint, Input.count - lastBreakPoint)]];
        [Output addObject:lastPayCycle];
    }
    
    
    
    
    //if all in one month
    if (Input.count > 1 && breakPoints.count == 0) {
        //all same month
        noOfPayCycles = 1;
        [Output addObject: [Input copy]];
    }
    
}
-(BOOL)IsFromSamePayCycle: (Event*) eventA witheventB: (Event*)eventB
{
    BOOL output;
    
    
    return output;
}
-(void)ArrangeAndSplitByMonth: (NSMutableArray*) Input withOutput: (NSMutableArray*) Output
{
    
    
    NSMutableArray *breakPoints = [[NSMutableArray alloc]init];
    //organizeD by date
    [Output removeAllObjects];
    
    noOfMonths = 0;
    
    if (Input.count == 1) {
        [Output addObject: [Input copy]];
    }
    
    if (Input.count > 0) {
        noOfMonths = 1;
    }
    
    [Input sortUsingComparator:^NSComparisonResult(Event *obj1, Event *obj2){
        return [obj2.eventDate compare:obj1.eventDate];
    }];
    
    for (int i = 1; i < Input.count; i ++) {
        Event *thisEvent = Input[i];
        Event *prevEvent = Input[i-1];
        
        if ([self YearFromDate:thisEvent.eventDate] != [self YearFromDate:prevEvent.eventDate]) {
            NSNumber *number = [NSNumber numberWithInt:i];
            [breakPoints addObject:number];
            noOfMonths += 1;
            

        }
        else
        {
            if ([self MonthFromDate:thisEvent.eventDate] != [self MonthFromDate:prevEvent.eventDate]) {
                //take note of breakpoint
                
                NSNumber *number = [NSNumber numberWithInt:i];
                [breakPoints addObject:number];
                noOfMonths += 1;
                
                

            }
            else
            {
                continue;
            }
        }
    }
    
    //for each breakpoint create an array (month)
    for (int x = 0; x<[breakPoints count]; x++) {
        NSMutableArray *thisMonth = [[NSMutableArray alloc]init];
        
        //split the events array using this break point
        NSNumber *thisBreakNumber = breakPoints[x];
        int thisBreakPoint = [thisBreakNumber intValue];
        
        if (x == 0) {
            thisMonth = [NSMutableArray arrayWithArray: [Input subarrayWithRange: NSMakeRange(0, thisBreakPoint)]];
        }
        else
        {
            NSNumber *prevBreakNumber = breakPoints[x-1];
            int prevBreakPoint = [prevBreakNumber intValue];
            thisMonth = [NSMutableArray arrayWithArray: [Input subarrayWithRange: NSMakeRange(prevBreakPoint, thisBreakPoint - prevBreakPoint)]];
        }
        
        if (thisMonth != nil) {
            [Output addObject:thisMonth];
        }
    }
    
    //add in last month (those after last breakpt)
    if (breakPoints.count != 0) {
        NSNumber *lastBreakNumber = breakPoints[breakPoints.count-1];
        int lastBreakPoint = [lastBreakNumber intValue];;
        NSMutableArray *lastMonth = [[NSMutableArray alloc]initWithArray:[Input subarrayWithRange:NSMakeRange(lastBreakPoint, Input.count - lastBreakPoint)]];
        [Output addObject:lastMonth];
    }
    

    
    
    //if all in one month
    if (Input.count > 1 && breakPoints.count == 0) {
        //all same month
        noOfMonths = 1;
        [Output addObject: [Input copy]];
    }

        
        

    
}

//for search
-(float)CalculateSpendingByMonthByTag: (NSString*) tag withMonthAndYear: (NSString*) MonthAndYear
{
    float output = 0;
    for (Event* event in events) {
        if ([event.tags containsObject:tag]) {
            if ([[self MonthAndYearFromDate:event.eventDate] isEqualToString:MonthAndYear]) {
                if (event.eventType == -1) {
                    output += event.eventValue;
                }
            }
        }
    }
    return output;
}

-(float)CalculateSpendingByTag: (NSString*) tag
{
    float output = 0;
    for (Event* event in events) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == -1) {
                output += event.eventValue;
            }
        }
    }
    return output;
}
-(float)CalculateSpendingByMonthAndYear: (NSString*) MonthAndYear
{
    float output = 0;
    for (Event* event in events) {
        if ([[self MonthAndYearFromDate:event.eventDate] isEqualToString:MonthAndYear]) {
            if (event.eventType == -1) {
                output += event.eventValue;
            }
        }
    }
    return output;
}

//for main display
-(float)CalculateMonthBalance:(NSArray *)month
{
    float output = 0;
    for (int i = 0; i < month.count; i ++) {
        Event *thisEvent = [month objectAtIndex:i];
        
        if (thisEvent.eventType == 0) {
            output -= thisEvent.eventValue;
        }
        else
        {
            output += thisEvent.eventType * thisEvent.eventValue;
        }
        
    }
    return  output;
}

-(float)CalculateMonthExpenditure:(NSArray *)month
{
    float output = 0;
    for (int i = 0; i < month.count; i ++) {
        Event *thisEvent = [month objectAtIndex:i];
        
        if (thisEvent.eventType == -1) {
            output -= thisEvent.eventValue;
        }
    }
    return output;
}

-(float)CalculateMonthClaimable:(NSArray*)month
{
    float output = 0;
    for (int i = 0; i < month.count; i ++) {
        Event *thisEvent = [month objectAtIndex:i];
        
        if (thisEvent.eventType == 0) {
            output += thisEvent.eventValue;
        }
        
    }
    return  output;
}
-(NSInteger)NumberOfMonths
{
    if (noOfMonths == 0) {
        return 1;
    }
    return noOfMonths;
}
-(void)AddEvent: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags
{
    Event *event = [[Event alloc]init];
    event.eventName = Name;
    event.eventType = eventType;
    event.tags = tags;

    if (eventType != 0) {
        event.eventValue = Value;
    }
    else
    {
        event.eventValue = Value;

    }
    event.eventDate = Date;
    [events addObject:event];
}

-(void)EditEvent:(Event *)event withName:(NSString *)Name withAmount:(float)Value withDate:(NSDate *)Date witheventType:(float)eventType withTags:(NSMutableArray *)tags
{
    event.eventName = Name;
    event.eventType = eventType;
    if (eventType != 0) {
        event.eventValue = Value;
    }
    else
    {
        event.eventValue = Value;
        
    }    event.eventDate = Date;
    event.tags = tags;
}


-(void)LoadAllTags
{
    if (allTags == nil) {
        allTags = [[NSMutableArray alloc]init];
    }
    
    [allTags removeAllObjects];
    for (Event* event in events) {
        for (NSString *tag in event.tags) {
            if (![allTags containsObject:tag]) {
                [allTags addObject:tag];
            }
        }
    }
}

-(NSMutableArray*)ThisMonthEvents
{
    NSMutableArray * output = [[NSMutableArray alloc]init];
    
    for (NSMutableArray * month in eventsInMonths) {
        Event* firstEvent =[month objectAtIndex:0];
        if ([self MonthFromDate: firstEvent.eventDate] == [self MonthFromDate:[NSDate date]]) {
            return month;
        }
    }
    
    
    return output;
}

-(float)ThisMonthExpenditure
{
    return [self CalculateMonthExpenditure:[self ThisMonthEvents]];
}






//encoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:events forKey:@"events"];
    [aCoder encodeObject:eventsInMonths forKey:@"eventsInMonths"];
    //[aCoder encodeObject:favEvents forKey:@"favEvents"];
   // [aCoder encodeObject:favEvents forKey:@"recEvents"];


}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [Bank Singleton])){
        events = [aDecoder decodeObjectForKey:@"events"];
        eventsInMonths = [aDecoder decodeObjectForKey:@"eventsInMonths"];
       // favEvents = [aDecoder decodeObjectForKey:@"favEvents"];
      //  recEvents = [aDecoder decodeObjectForKey:@"recEvents"];

    }
    return self;
}
@end
