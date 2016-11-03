//
//  TagReviewController.m
//  What's left?
//
//  Created by Swee Har Ng on 22/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "TagReviewController.h"

@interface TagReviewController ()

@end

@implementation TagReviewController
@synthesize hundredRelativePts;
@synthesize screen;
@synthesize arrayOfEventsToReview;
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SizingMisc];
    [self BuildTableView];
    
    arrayOfEventsToReview = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //[tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
}

-(void)BuildTableView
{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil] objectAtIndex:0];
    if (cell == nil) {
        cell = [[EventCell alloc] init];
    }
    
    cell.thisEvent = [arrayOfEventsToReview objectAtIndex: indexPath.row];
    [cell UpdateCell:@"ByEvent"];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate PushEditEventController: [arrayOfEventsToReview objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfEventsToReview.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Delete"
                                      message:@"Are you sure you want to delete?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Confirm"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        
                                        [self.delegate DeleteEvent:[arrayOfEventsToReview objectAtIndex:indexPath.row]];
                                        [arrayOfEventsToReview removeObjectAtIndex:indexPath.row];
                                        [self.delegate UpdateBankAndSettings];
                                        
                                        // tell table to refresh now
                                        
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

@end
