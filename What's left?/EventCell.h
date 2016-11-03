//
//  EventCell.h
//  What's left?
//
//  Created by Swee Har Ng on 14/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameDisplay;

@property (weak, nonatomic) IBOutlet UILabel *AmountDisplay;
@property (weak, nonatomic) IBOutlet UILabel *DateDisplay;
@property Event *thisEvent;
@property NSString* tagTitle;
@property float tagValue;
-(void)UpdateCell: (NSString*) displayMode;

@property CGFloat hundredRelativePts;
@property UIScreen *screen;

@property BOOL isViewMore;
@end
