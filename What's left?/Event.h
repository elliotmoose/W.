//
//  Event.h
//  What's left?
//
//  Created by Swee Har Ng on 13/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
{

}
@property float eventValue;
@property float eventType;
@property NSString *eventName;
@property NSDate *eventDate;
@property NSMutableArray *tags;
@property BOOL isViewMore;
@property BOOL isByMonth;

-(void)RemoveTag:(NSString*)TagName;
@end
