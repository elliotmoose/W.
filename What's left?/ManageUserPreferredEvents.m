//
//  ManageUserPreferredEvents.m
//  What's left?
//
//  Created by Swee Har Ng on 21/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "ManageUserPreferredEvents.h"

@interface ManageUserPreferredEvents ()

@end

@implementation ManageUserPreferredEvents
@synthesize addEventViewCont;
@synthesize thisSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArrays];

    thisSetting = [[Settings alloc]init];
    addEventViewCont = [[AddEventViewController alloc]init];
    
    UIBarButtonItem *addFavButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddNewFavButton)];
    self.navigationItem.rightBarButtonItem = addFavButton;
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initArrays
{
    
}
#pragma mark - Table view data source

-(void)AddNewFavButton
{
    addEventViewCont.AddFavMode = YES;
    [self.navigationController pushViewController:addEventViewCont animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return thisSetting.favEvents.count;
}


- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil] objectAtIndex:0];
    if (cell == nil) {
        cell = [[EventCell alloc] init];
    }
    
    // Configure the cell...
    
    //if it is the search tableview
    
    
    Event *thisEvent = [thisSetting.favEvents objectAtIndex:indexPath.row];
    cell.thisEvent = thisEvent;
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld , %ld", (long)indexPath.section,(long)indexPath.row];
    [cell UpdateCell: @"ByEvent"];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    addEventViewCont.editMode = true;
    addEventViewCont.AddFavMode = YES;
    [addEventViewCont EditEventMode: [thisSetting.favEvents objectAtIndex: indexPath.row]];
    [self.navigationController pushViewController:addEventViewCont animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
@end
