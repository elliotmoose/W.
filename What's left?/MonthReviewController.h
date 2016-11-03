//
//  MonthReviewController.h
//  What's left?
//
//  Created by Swee Har Ng on 22/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "Event.h"
#import "JBBarChartView.h"
@interface MonthReviewController : UIViewController<JBBarChartViewDataSource,JBBarChartViewDelegate>
@property CGFloat hundredRelativePts;
@property UIScreen *screen;
@property NSMutableArray *arrayOfEventsToReview;
@property NSMutableArray *allTagsInMonth;
@property NSMutableArray *tagsToDisplay;


@property UIScrollView *barChartScrollView;
@property UISegmentedControl *DisplayMode
//**percentage or value mode
/*
 0: by value
 1:by percentage
 */;

@property UISegmentedControl *valuePickControl;


@property NSMutableArray *TagStatsDisplays;
//@property XYPieChart *tagPieChart;
@property JBBarChartView *thisBarChartView;
//methods
//-(void)BuildPieChart;
-(void)BuildTagStatDisplays;
-(void)ToShow: (NSMutableArray*)array withTitle: (NSString*)title;
@end
