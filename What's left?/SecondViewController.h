//
//  SecondViewController.h
//  What's left?
//
//  Created by Swee Har Ng on 13/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ManageUserPreferredEvents.h"
#import "ViewControllersLink.h"
#import "EditSettingsValuesViewController.h"

@interface SecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,secondViewContDelegate,editSettingsValuesDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MainSettingsDisplay;
@property CGFloat hundredRelativePts;
@property UIScreen *screen;
//@property (strong, nonatomic, retain)Settings *thisSettings;

///controllers
@property ManageUserPreferredEvents* UserPrefEventsCont;
@property Settings* thisSettings;

@property ViewControllersLink* viewContLink;
@property EditSettingsValuesViewController *editSettingsCont;
@property MoneyManager *moneyManager;
//methods
-(void)InitWithSettings;
-(void)initialize;
@end

