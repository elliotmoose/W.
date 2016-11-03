//
//  MonthReviewController.m
//  What's left?
//
//  Created by Swee Har Ng on 22/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#import "MonthReviewController.h"

@interface MonthReviewController ()
{
    UIColor *bgColor;
}
@end

@implementation MonthReviewController
@synthesize hundredRelativePts;
@synthesize screen;
@synthesize allTagsInMonth;
@synthesize arrayOfEventsToReview;
@synthesize thisBarChartView;
@synthesize barChartScrollView;
@synthesize DisplayMode;
@synthesize valuePickControl;
@synthesize tagsToDisplay;
//@synthesize tagPieChart;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self InitViews];
    [self SizingMisc];
    [self InitArrays];
    [self PrepBarChart];
    

    //coloring
    bgColor = Rgb2UIColor(0, 150, 137);
    thisBarChartView.backgroundColor = bgColor;
    self.view.backgroundColor = bgColor;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self BuildBarChart];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ToShow: (NSMutableArray*)array withTitle: (NSString*)title
{
    arrayOfEventsToReview = array;
    self.navigationItem.title = title;
}

 -(void)InitViews
 {
     barChartScrollView = [[UIScrollView alloc]init];
     barChartScrollView.backgroundColor = bgColor;
     barChartScrollView.directionalLockEnabled = YES;
     barChartScrollView.showsHorizontalScrollIndicator = YES;
     self.automaticallyAdjustsScrollViewInsets = NO;
     barChartScrollView.contentInset = UIEdgeInsetsZero;
     barChartScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
     barChartScrollView.contentOffset = CGPointMake(0.0, 0.0);
     
     DisplayMode = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"$", @"%",nil]];
     DisplayMode.selectedSegmentIndex = 0;
     [DisplayMode addTarget:self action:@selector(DisplayModeValueChanged) forControlEvents:UIControlEventValueChanged];
     
     valuePickControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Expenditure", @"Income",@"Balance",nil]];
     valuePickControl.selectedSegmentIndex = 0;
     [valuePickControl addTarget:self action:@selector(ValuePickControlValueChanged) forControlEvents:UIControlEventValueChanged];
     
     DisplayMode.tintColor = UIColorFromRGB(0xB2DFDB);
     valuePickControl.tintColor = UIColorFromRGB(0xB2DFDB);
     [self.view addSubview:barChartScrollView];
     [self.view addSubview: DisplayMode];
     [self.view addSubview: valuePickControl];
 }
-(void)InitArrays
{
    arrayOfEventsToReview = [[NSMutableArray alloc]init];
    allTagsInMonth = [[NSMutableArray alloc]init];
    tagsToDisplay = [[NSMutableArray alloc]init];

}

-(void)setAllTagsInMonth
{
    [allTagsInMonth removeAllObjects];
    for (Event *event in arrayOfEventsToReview) {
        for (NSString *tag in event.tags) {
            if (![allTagsInMonth containsObject:tag]) {
                [allTagsInMonth addObject:tag];
            }
        }
        
        if (event.tags.count == 0) {
            if (![allTagsInMonth containsObject:@"tagless"]) {
                [allTagsInMonth addObject:@"tagless"];
            }
        }
    }
    
    [self SetTagsToDisplay];
}

-(void)SetTagsToDisplay
{
    //set tags to display
    [tagsToDisplay removeAllObjects];
    for (NSString *tag in allTagsInMonth) {
        
        BOOL toAdd = NO;
        
        switch (valuePickControl.selectedSegmentIndex) {
            case 0:
                //display expenditure
                //must check if expenditure > 0
                
                if([self SumOfTagExpenditureInArray:arrayOfEventsToReview withtag:tag] > 0)
                {
                    toAdd = YES;
                }
                break;
                
            case 1:
                if([self SumOfTagIncomeInArray:arrayOfEventsToReview withtag:tag] > 0)
                {
                    toAdd = YES;
                }
                break;
                
            case 2:
                if([self SumOfTagBalanceInArray:arrayOfEventsToReview withtag:tag] != 0)
                {
                    toAdd = YES;
                }
                break;
            default:
                break;
        }
        
        if (toAdd) {
            [tagsToDisplay addObject: tag];
        }
    }

}
//-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
//{
//    return allTagsInMonth.count;
//}
//
//-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
//{
//    //index is the index of the tag in all tags
//    NSString *thisTag = [allTagsInMonth objectAtIndex:index];
//    CGFloat percentage =[self PercentageExpenditureForTagInArray:arrayOfEventsToReview withtag: thisTag];
//    return percentage;
//}
//
//-(NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
//{
//    NSString *thisTag = [allTagsInMonth objectAtIndex:index];
//    return thisTag;
//}
-(float)SumOfTagExpenditureInArray: (NSMutableArray*)array withtag: (NSString*) tag
{
    float sumOfTagExpenditure = 0;
    for (Event *event in array) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == -1) {
                sumOfTagExpenditure += event.eventValue;
            }
        }
        
        if ([tag isEqualToString: @"tagless"]  && event.tags.count == 0 && event.eventType == -1) {
            sumOfTagExpenditure += event.eventValue;
        }
    }
    
    return sumOfTagExpenditure;
}

-(float)SumOfTagIncomeInArray: (NSMutableArray*)array withtag: (NSString*) tag
{
    float sumOfTagIncome = 0;
    for (Event *event in array) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == 1) {
                sumOfTagIncome += event.eventValue;
            }
        }
        
        if ([tag isEqualToString: @"tagless"]  && event.tags.count == 0 && event.eventType == 1) {
            sumOfTagIncome += event.eventValue;
        }
    }
    
    return sumOfTagIncome;
}

-(float)SumOfTagBalanceInArray: (NSMutableArray*)array withtag: (NSString*) tag
{
    float sumOfTagBalance = 0;
    for (Event *event in array) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == 1 || event.eventType == -1) {
                sumOfTagBalance += event.eventValue*event.eventType;
            }
        }
        
        if ([tag isEqualToString: @"tagless"] && event.tags.count == 0 && (event.eventType == -1 || event.eventType == 1)) {
            sumOfTagBalance += event.eventValue*event.eventType;
        }
    }
    
    return sumOfTagBalance;
}


-(float)SumOfArrayExpenditure: (NSMutableArray*) array
{
    float sum = 0;
    for (Event *event in array) {
        //not including claimable
        if (event.eventType == -1) {
            sum += event.eventValue;
        }
    }
    return sum;
}
-(float)SumOfArrayIncome: (NSMutableArray*) array
{
    float sum = 0;
    for (Event *event in array) {
        //not including claimable
        if (event.eventType == 1) {
            sum += event.eventValue;
        }
    }
    return sum;
}

-(float)SumOfArrayBalance: (NSMutableArray*) array
{
    float sum = 0;
    for (Event *event in array) {
        //not including claimable
        if (event.eventType == 1 || event.eventType == -1) {
            sum += event.eventValue * event.eventValue;
        }
    }
    return sum;
}

-(float)PercentageExpenditureForTagInArray: (NSMutableArray*)array withtag: (NSString*) tag
{
    float percentage = 0;
    float sumOfTagExpenditure = 0;
    for (Event *event in array) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == -1) {
                sumOfTagExpenditure += event.eventValue;
            }
        }
        
        if ([tag isEqualToString: @"tagless"]  && event.tags.count == 0 && event.eventType == -1) {
            sumOfTagExpenditure += event.eventValue;
        }
    }
    
    if (sumOfTagExpenditure == 0) {
        return 0;
    }
    percentage = sumOfTagExpenditure/[self SumOfArrayExpenditure: arrayOfEventsToReview] *100;
    return percentage;
}

-(float)PercentageIncomeForTagInArray: (NSMutableArray*)array withtag: (NSString*) tag
{
    float percentage = 0;
    float sumOfTagIncome = 0;
    for (Event *event in array) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == 1) {
                sumOfTagIncome += event.eventValue;
            }
        }
        
        if ([tag isEqualToString: @"tagless"] && event.tags.count == 0  && event.eventType == 1) {
            sumOfTagIncome += event.eventValue;
        }
    }
    
    if (sumOfTagIncome == 0) {
        return 0;
    }
    percentage = sumOfTagIncome/[self SumOfArrayIncome: arrayOfEventsToReview] *100;
    return percentage;
}

-(float)PercentageBalanceForTagInArray: (NSMutableArray*)array withtag: (NSString*) tag
{
    float percentage = 0;
    float sumOfTagBalance = 0;
    for (Event *event in array) {
        if ([event.tags containsObject:tag]) {
            if (event.eventType == 1 || event.eventType == -1) {
                sumOfTagBalance += event.eventValue*event.eventType;
            }
        }
        
        if ([tag isEqualToString: @"tagless"] && event.tags.count == 0 && (event.eventType == -1 || event.eventType == 1)) {
            sumOfTagBalance += event.eventValue;
        }
    }
    
    if (sumOfTagBalance == 0) {
        return 0;
    }
    percentage = sumOfTagBalance/[self SumOfArrayBalance: arrayOfEventsToReview] *100;
    return percentage;
}

-(void)BuildTagStatDisplays
{
    [self setAllTagsInMonth];
    
    [[self.view subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSString* tag in allTagsInMonth) {
        //create a new tag display
        //for each tag display:
        //1.name
        //2.exp/inc/bal in month
        //3.% of exp/inc/bal
        NSInteger index = [allTagsInMonth indexOfObject:tag];
        
        UIView *tagDisplay = [[UIView alloc]initWithFrame:CGRectZero];
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        UILabel * percentageLabel = [[UILabel alloc]initWithFrame:CGRectZero];

        nameLabel.text = tag;
        valueLabel.text = [NSString stringWithFormat:@"D:%.2f/W:%.2f/B:%.2f",[self SumOfTagIncomeInArray:arrayOfEventsToReview withtag:tag],[self SumOfTagExpenditureInArray:arrayOfEventsToReview withtag:tag],[self SumOfTagBalanceInArray:arrayOfEventsToReview withtag:tag]];
        percentageLabel.text = [NSString stringWithFormat:@"D:%.1f%%/W:%.1f%%/B:%.1f%%",[self PercentageIncomeForTagInArray:arrayOfEventsToReview withtag:tag],[self PercentageExpenditureForTagInArray:arrayOfEventsToReview withtag:tag],[self PercentageBalanceForTagInArray:arrayOfEventsToReview withtag:tag]];
        
        
        [tagDisplay addSubview:nameLabel];
        [tagDisplay addSubview:valueLabel];
        [tagDisplay addSubview:percentageLabel];
        
        tagDisplay.frame = CGRectMake(0, hundredRelativePts + (hundredRelativePts*0.64)*index, screen.bounds.size.width, hundredRelativePts*0.3);
        nameLabel.frame = CGRectMake(0, 0, screen.bounds.size.width/3, hundredRelativePts*0.3);
        valueLabel.frame = CGRectMake(screen.bounds.size.width/3, 0, screen.bounds.size.width, hundredRelativePts*0.3);
        percentageLabel.frame = CGRectMake(screen.bounds.size.width/3, hundredRelativePts * 0.32, screen.bounds.size.width, hundredRelativePts*0.3);

        
        [self.view addSubview:tagDisplay];
    }
}


- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return tagsToDisplay.count; // number of bars in chart
}
- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    CGFloat maxBarHeight = barChartView.frame.size.height - hundredRelativePts*1.3;
    
    CGFloat barHeight = 0;
    
    float lowestToHighestValue = ([self GetMaxEventValueFromArray:arrayOfEventsToReview] - [self GetMinEventValueFromArray:arrayOfEventsToReview]);
    
    switch (DisplayMode.selectedSegmentIndex) {
        case 0:
            

            
            switch (valuePickControl.selectedSegmentIndex) {

                    
                case 0:
                    barHeight = [self SumOfTagExpenditureInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]/lowestToHighestValue * maxBarHeight;
                    break;
                case 1:
                    barHeight = [self SumOfTagIncomeInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]/lowestToHighestValue * maxBarHeight;
                    break;
                case 2:
                    barHeight = [self SumOfTagBalanceInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]/lowestToHighestValue * maxBarHeight;
                    break;
                default:
                    break;
            }
            
            break;
        case 1:

            switch (valuePickControl.selectedSegmentIndex) {
                case 0:
                    barHeight = [self PercentageExpenditureForTagInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]] / 100 * maxBarHeight;
                    break;
                case 1:
                    barHeight = [self PercentageIncomeForTagInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]] / 100 * maxBarHeight;
                    break;
                case 2:
                    barHeight = [self PercentageBalanceForTagInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]] / 100 * maxBarHeight;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    
    if (barHeight <= 0) {
        return fabsf((float)barHeight);
    }
    return barHeight; // height of bar at index
}

-(UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView * customView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, [barChartView barWidth], hundredRelativePts * 0.3)] ;
    customView.backgroundColor = bgColor;


    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -hundredRelativePts*0.5, [barChartView barWidth], hundredRelativePts * 0.3)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.adjustsFontSizeToFitWidth = YES;
    
    float barHeight = [self barChartView:thisBarChartView heightForBarViewAtIndex:index];
        UILabel *tagNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -hundredRelativePts*0.3, [barChartView barWidth], hundredRelativePts * 0.3)];
    tagNameLabel.text = [tagsToDisplay objectAtIndex: index];
    tagNameLabel.textColor = [UIColor whiteColor];
    tagNameLabel.adjustsFontSizeToFitWidth = YES;
    tagNameLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *textValueForLabel;
    switch (DisplayMode.selectedSegmentIndex) {
        case 0:
            textLabel.font = [UIFont boldSystemFontOfSize:14.0];

            switch (valuePickControl.selectedSegmentIndex) {
                case 0:
                        textValueForLabel =[NSString stringWithFormat:@"$%.2f",[self SumOfTagExpenditureInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]];
                    break;
                case 1:
                        textValueForLabel =[NSString stringWithFormat:@"$%.2f",[self SumOfTagIncomeInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]];
                    break;
                case 2:
                        textValueForLabel =[NSString stringWithFormat:@"$%.2f",[self SumOfTagBalanceInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]];
                    break;
                default:
                    break;
            }
            
            break;
        case 1:
            textLabel.font = [UIFont boldSystemFontOfSize:17.0];
            switch (valuePickControl.selectedSegmentIndex) {
                case 0:
                    textValueForLabel =[NSString stringWithFormat:@"%.1f%%",[self PercentageExpenditureForTagInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]];
                    break;
                case 1:
                    textValueForLabel =[NSString stringWithFormat:@"%.1f%%",[self PercentageIncomeForTagInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]];
                    break;
                case 2:
                    textValueForLabel =[NSString stringWithFormat:@"%.1f%%",[self PercentageBalanceForTagInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    textLabel.text = textValueForLabel;
    textLabel.backgroundColor = [UIColor clearColor];
    [customView addSubview:tagNameLabel];
    [customView addSubview:textLabel];
    
    
    //color of bar
    UIColor *green =Rgb2UIColor(177, 222, 189);
    UIColor * red = UIColorFromRGB(0xFC7B84);

    switch (valuePickControl.selectedSegmentIndex) {
        case 0:
            customView.backgroundColor = red;
            
            break;
        case 1:
            customView.backgroundColor = green;
            
            break;
        case 2:
            if ([self SumOfTagBalanceInArray:arrayOfEventsToReview withtag:[tagsToDisplay objectAtIndex: index]] < 0) {
                customView.backgroundColor = red;
            }
            else
            {
                customView.backgroundColor = green;
            }
            break;
        default:
            break;
    }
    
    
    return customView;
}
-(UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{


    return [UIColor lightGrayColor];
}

-(void)PrepBarChart
{
    
    thisBarChartView.delegate = self;
    thisBarChartView.dataSource = self;
    thisBarChartView.backgroundColor = bgColor;
    thisBarChartView.CustomBarWidth = hundredRelativePts * 0.6;
    
    //depends on mode
    thisBarChartView.minimumValue = 0;
    thisBarChartView.maximumValue = 100;
    
    [thisBarChartView reloadData];
    [thisBarChartView setState:JBChartViewStateCollapsed animated:NO];
    
    [barChartScrollView addSubview:thisBarChartView];
}

-(void)BuildBarChart
{
    
    [self setAllTagsInMonth];
    
    [self UpdateBarChartFrame];
    
    [thisBarChartView reloadData];
    
    [thisBarChartView setState:JBChartViewStateExpanded animated:YES];

}

-(void)UpdateBarChartFrame
{
    
    CGFloat minWidthOfBarChart = screen.bounds.size.width - hundredRelativePts*0.3;
    CGFloat currentWidth = allTagsInMonth.count * hundredRelativePts*0.4 + (allTagsInMonth.count - 1)*[thisBarChartView getBarSpacingWidth];
    if (currentWidth > minWidthOfBarChart) {
        
        [thisBarChartView setFrame: CGRectMake(0,0, currentWidth, hundredRelativePts*2)];
    }
    else
    {
        [thisBarChartView setFrame: CGRectMake(0, 0, minWidthOfBarChart, hundredRelativePts*2)];
    }
    
    
    [barChartScrollView setContentSize: CGSizeMake(currentWidth, thisBarChartView.frame.size.height)];
}
-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
    
    thisBarChartView = [[JBBarChartView alloc]initWithFrame:CGRectZero];
    
    thisBarChartView.barSpacingWidth = hundredRelativePts*0.3;
    

    [barChartScrollView setFrame: CGRectMake(hundredRelativePts*0.15, hundredRelativePts*0.8, screen.bounds.size.width - hundredRelativePts*0.3, hundredRelativePts*2)];
    [barChartScrollView setContentSize: barChartScrollView.frame.size];
    
    
    valuePickControl.frame = CGRectMake(screen.bounds.size.width/2 - hundredRelativePts*1.5, hundredRelativePts*3, hundredRelativePts*3, 30);
    DisplayMode.frame = CGRectMake(screen.bounds.size.width/2 - hundredRelativePts*0.7, hundredRelativePts*3 + 45, hundredRelativePts*1.4, 30);


}

-(void)DisplayModeValueChanged
{

    [self SetTagsToDisplay];
    [thisBarChartView reloadDataAnimated:YES];
    
    //set max and min values
}

-(void)ValuePickControlValueChanged
{
    //when selecting balance disable percentage
    if (valuePickControl.selectedSegmentIndex == 2) {
        DisplayMode.selectedSegmentIndex = 0;
        [self DisplayModeValueChanged];
        DisplayMode.enabled = NO;
    }
    else
    {
        DisplayMode.enabled = YES;
    }
    
    
    [self SetTagsToDisplay];
    [thisBarChartView reloadDataAnimated:YES];
}

-(void)IsValueMode: (BOOL)isValueMode
{
    if (isValueMode) {
        //change max and min
        thisBarChartView.maximumValue = [self GetMaxEventValueFromArray:arrayOfEventsToReview];
        thisBarChartView.minimumValue = [self GetMinEventValueFromArray:arrayOfEventsToReview];
    }
    else
    {
        thisBarChartView.maximumValue = 100;
        thisBarChartView.minimumValue = 0;
    }
}

-(float)GetMaxEventValueFromArray: (NSMutableArray*)array
{
    float output = 0;
    
    for (Event *event in array) {
        if (event.eventValue > output) {
            output = event.eventValue;
        }
    }
    
    
    return  output;
}

-(float)GetMinEventValueFromArray: (NSMutableArray*)array
{
    float output = 0;
    
    for (Event *event in array) {
        if (event.eventValue < output) {
            output = event.eventValue;
        }
    }
    
    return  output;
}
@end
