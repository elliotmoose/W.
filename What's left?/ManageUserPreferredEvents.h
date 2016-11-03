//
//  ManageUserPreferredEvents.h
//  What's left?
//
//  Created by Swee Har Ng on 21/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"
#import "EventCell.h"
@protocol SaveBankDelegate <NSObject>

-(void)UpdateBank;

@end
@interface ManageUserPreferredEvents : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property AddEventViewController *addEventViewCont;
@property (strong) Settings *thisSetting;
@property (weak,nonatomic) id<SaveBankDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
