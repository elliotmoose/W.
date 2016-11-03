//
//  EditSummaryCellController.m
//  What's left?
//
//  Created by Swee Har Ng on 3/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "EditSummaryCellController.h"
static EditSummaryCellController *singleton;
@interface EditSummaryCellController ()
{
    NSArray *summaryCellModes;
}
@end

@implementation EditSummaryCellController
{
    DisplayMode selectedsDisp;
}
@synthesize cellDataInEdit;
@synthesize cellModePicker;
@synthesize indexOfCellInEdit;
@synthesize thisSettings;
-(instancetype)init
{
    if (singleton == nil) {
        singleton = self;
    }
    return  singleton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(SaveChanges)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    cellModePicker.dataSource = self;
    cellModePicker.delegate = self;
    summaryCellModes = [NSArray arrayWithObjects:@"Balance",
                        @"Spent",
                        @"Left To Spend",
                        @"Left To Spend/Day",
                        @"Claimable",
                        @"Days To Next Month", nil];
    
    thisSettings = [[Settings alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self LoadEditCellData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)LoadEditCellData
{

    [cellModePicker selectRow: (int)cellDataInEdit.displayMode inComponent:0 animated:NO];
    [cellModePicker selectRow:(int)cellDataInEdit.timeFrame inComponent:1 animated:NO];
    selectedsDisp = cellDataInEdit.displayMode;
    [cellModePicker reloadComponent:1];
}

-(void)SaveChanges
{

    
    DisplayMode temp = (DisplayMode)[cellModePicker selectedRowInComponent:0];
    TimeFrame tempTimeFrame = (TimeFrame)[cellModePicker selectedRowInComponent:1];
    SummaryCellData* newCellData = [[SummaryCellData alloc]init];
    newCellData.displayMode = temp;
    newCellData.timeFrame = tempTimeFrame;

    [self.delegate ReplaceCell:newCellData withreplacementIndex:indexOfCellInEdit];
    //weite to userdefaults
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1) {
        if (selectedsDisp == DaysToEndOfMonth) {
            return 0;
        }
        if (selectedsDisp == LeftToSpendPerDay || selectedsDisp == LeftToSpend) {
            return 1;
        }
        if (selectedsDisp == Spent) {
            return 3;
        }
        return 2;
    }
    return summaryCellModes.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 1) {
        if (selectedsDisp == LeftToSpendPerDay) {
            return @"This Month";
        }
        switch (row) {
            case 1:
                return @"All Time";
                break;
            case 0:
                return @"This Month";
                break;
            case 2:
                return @"Each Day Average";
                break;
//            case 2:
//                return @"This Pay Cycle";
//                break;
                
            default:
                break;
        }
    }
    return summaryCellModes[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        selectedsDisp = (DisplayMode)[cellModePicker selectedRowInComponent:0];
    }
    
    [pickerView reloadComponent:1];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    UIScreen *screen = [UIScreen mainScreen];
    
    switch (component){
        case 0:
            return screen.bounds.size.width*8/15;
        case 1:
            return screen.bounds.size.width*1/3;
    }
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        
        tView.textAlignment = NSTextAlignmentCenter;
        
        tView.adjustsFontSizeToFitWidth = YES;
        // Setup label properties - frame, font, colors etc
    }
    
    tView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    //Add any logic you want here
    
    return tView;
}
@end
