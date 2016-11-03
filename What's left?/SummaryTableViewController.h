//
//  SummaryTableViewController.h
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSummaryCellController.h"
#import "SummaryCellData.h"
#import "IntroController.h"
#import "Settings.h"
@interface SummaryTableViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate,cellEdtContDelegate>
@property NSInteger noOfRows;
@property UIScreen *screen;
@property float hundredRelativePts;
@property (strong, nonatomic) IBOutlet UITableView *displayTableView;

@property NSMutableArray *allSummaryCells;
@property NSMutableArray *allSummaryCellsData;
@property EditSummaryCellController *editCellCont;

@property Settings *thisSettings;
@end
