//
//  Event.m
//  What's left?
//
//  Created by Swee Har Ng on 13/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "Event.h"

@implementation Event
@synthesize eventName;
@synthesize eventType;
@synthesize eventValue;
@synthesize eventDate;
@synthesize tags;
@synthesize isViewMore;
@synthesize isByMonth;
-(id)init
{
    eventName = @"";
    eventValue = 0;
    eventType = 1;
    eventDate = [NSDate date];
    isViewMore = NO;
    tags = [[NSMutableArray alloc]init];
    return self;
}

-(void)AddTag:(NSString*)TagName
{
    if ([tags containsObject:TagName]) {
        return;
    }
    
    [tags addObject:TagName];
}

-(void)RemoveTag:(NSString*)TagName
{
    //check if mutabke
    if (![tags respondsToSelector:@selector(addObject:)]) {
        tags = [tags mutableCopy];
    }
    
    
    if ([tags containsObject:TagName]) {
        [tags removeObject: TagName];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:eventDate forKey:@"eventDate"];
    [aCoder encodeObject:tags forKey:@"tags"];
    [aCoder encodeObject:eventName forKey:@"eventName"];
    
    NSNumber *tempValue = [NSNumber numberWithFloat:eventValue];
    NSNumber *tempType = [NSNumber numberWithFloat:eventType];
    
    [aCoder encodeObject:tempValue forKey:@"tempValue"];
    [aCoder encodeObject:tempType forKey:@"tempType"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        eventDate = [aDecoder decodeObjectForKey:@"eventDate"];
        tags = [[aDecoder decodeObjectForKey:@"tags"] mutableCopy];
        eventName = [aDecoder decodeObjectForKey:@"eventName"];
        
        
        NSNumber *tempValue = [aDecoder decodeObjectForKey:@"tempValue"];
        NSNumber *tempType = [aDecoder decodeObjectForKey:@"tempType"];
        
        eventType = [tempType floatValue];
        eventValue = [tempValue floatValue];

    }
    return self;
}
@end
