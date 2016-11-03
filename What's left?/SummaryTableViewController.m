//
//  SummaryTableViewController.m
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#import "SummaryTableViewController.h"
static SummaryTableViewController *singleton;
@interface SummaryTableViewController ()

@end

@implementation SummaryTableViewController
{
    int maxSummaryCells;
}
@synthesize noOfRows;
@synthesize screen;
@synthesize hundredRelativePts;
@synthesize allSummaryCells;
@synthesize allSummaryCellsData;
@synthesize editCellCont;
@synthesize thisSettings;

-(instancetype)init
{
    if (singleton == nil) {
        singleton = self;
    }
    self = singleton;

    return singleton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self init];
    maxSummaryCells = 6;
    allSummaryCells = [[NSMutableArray alloc]init];
    allSummaryCellsData = [[NSMutableArray alloc]init];
    editCellCont = [[EditSummaryCellController alloc]init];
    editCellCont.delegate = self;
    thisSettings = [[Settings alloc]init];
    [self LoadCells];
    [self reloadData];

    self.tableView.backgroundColor = UIColorFromRGB(0xF4F3F4);
}
-(void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)reloadData
{
    [allSummaryCells removeAllObjects];
    //reload data background first
    //set all summary cells based on all summary data
    for (int i = 0; i < allSummaryCellsData.count; i ++) {
        SummaryCellData *thisData = allSummaryCellsData[i];
        DisplayMode displayMode = thisData.displayMode;
        TimeFrame timeframe = thisData.timeFrame;
        
        SummaryCell *sumCell;
        
        
        //if its not default view
        if (displayMode == Balance || (displayMode == Spent && timeframe == AllTime) || displayMode == LeftToSpendPerDay || displayMode == DaysToEndOfMonth || displayMode == Claimable || timeframe == EachDayAverage) {
            sumCell = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCell2" owner:self options:nil] objectAtIndex:0];
            
        }
        else
        {
            sumCell = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil] objectAtIndex:0];
        }
        
        sumCell.displayMode = displayMode;
        sumCell.timeFrame = timeframe;
        
        [allSummaryCells addObject: sumCell];

    }
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (allSummaryCellsData.count <=maxSummaryCells -1 ) {
        return allSummaryCellsData.count + 1;
    }
    else
    {
        return  maxSummaryCells;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= allSummaryCellsData.count) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]init];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"+";
            [cell.textLabel setFont:[[cell.textLabel font] fontWithSize:cell.bounds.size.height]];
        }
        

        cell.backgroundColor = UIColorFromRGB(0xF4F3F4);

        return cell;
    }

    SummaryCell *sumCell = allSummaryCells[indexPath.row];
    
    [sumCell UpdateDisplay];

    return sumCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == allSummaryCells.count) {
        if (allSummaryCells.count <= maxSummaryCells -1) {
            [self AddSummaryCell];
        }
        
        //trigger intro
        if (!thisSettings.hasDoneIntro) {
            IntroController *introCont = [[IntroController alloc]init];
            [introCont IntroTrigger: 2];
        }
        
    }
    else{
    editCellCont.cellDataInEdit = allSummaryCellsData[indexPath.row];
    editCellCont.indexOfCellInEdit = (int)indexPath.row;
    [self.navigationController pushViewController:editCellCont animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == allSummaryCells.count) {
        return  NO;
    }
    
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        [allSummaryCellsData removeObjectAtIndex:indexPath.row];
        [self reloadData];
        [self SaveCells];
    }
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    tableView.rowHeight = hundredRelativePts * 0.4;
//    return hundredRelativePts*0.4;
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)AddSummaryCell
{
    SummaryCellData *cellData = [[SummaryCellData alloc] init];
    cellData.displayMode = Spent;
    cellData.timeFrame = ThisMonth;
    
  
    [allSummaryCellsData addObject:cellData];
    [self SaveCells];
    [self reloadData];
}
-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
}

-(void)ReplaceCell: (SummaryCellData*) newCellData withreplacementIndex: (int) replacementIndex
{
    [allSummaryCellsData setObject: newCellData atIndexedSubscript:replacementIndex];
    [self SaveCells];
    [self reloadData];
}

-(void)SaveCells
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
   
    NSData *archivedArray = [NSKeyedArchiver archivedDataWithRootObject:allSummaryCellsData];
    [save setObject:archivedArray forKey:@"allSunmaryCellsData"];
    [save synchronize];
}

-(void)LoadCells
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    NSData *archivedArray = [save objectForKey:@"allSunmaryCellsData"];
    if (archivedArray != nil) {
        allSummaryCellsData = [NSKeyedUnarchiver unarchiveObjectWithData:archivedArray];
        
    }
    if (allSummaryCellsData == nil) {
        allSummaryCellsData = [[NSMutableArray alloc]init];
    }
    
    }
@end
