//
//  TagReviewController.h
//  What's left?
//
//  Created by Swee Har Ng on 22/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventCell.h"
#import "Event.h"

@protocol TagReviewDelegate <NSObject>

-(void)PushEditEventController: (Event*)event;
-(void)UpdateBankAndSettings;
-(void)DeleteEvent: (Event*) event;
@end

@interface TagReviewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property CGFloat hundredRelativePts;
@property UIScreen *screen;
@property NSMutableArray *arrayOfEventsToReview;


@property UITableView *tableView;
@property (weak,nonatomic) id<TagReviewDelegate> delegate;
@end
