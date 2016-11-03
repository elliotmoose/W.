//
//  SecondViewController.m
//  What's left?
//
//  Created by Swee Har Ng on 13/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end
@implementation SecondViewController
@synthesize hundredRelativePts;
@synthesize screen;
@synthesize UserPrefEventsCont;
@synthesize thisSettings;
@synthesize MainSettingsDisplay;
@synthesize viewContLink;
@synthesize editSettingsCont;
@synthesize moneyManager;
- (void)viewDidLoad {
    [super viewDidLoad];

    thisSettings = [[Settings alloc]init];
    
    MainSettingsDisplay.delegate = self;
    MainSettingsDisplay.dataSource = self;
    // Do any additional setup after loading the view, typically from a nib.
    [self SizingMisc];
    [self initialize];
    
    viewContLink = [[ViewControllersLink alloc]init];
    viewContLink.secondDelegate = self;

    editSettingsCont = [[EditSettingsValuesViewController alloc]init];
    editSettingsCont.delegate = self;
    [self addChildViewController:editSettingsCont];
    [self.view addSubview:editSettingsCont.view];
    editSettingsCont.view.userInteractionEnabled = NO;
    editSettingsCont.view.alpha = 0;
    moneyManager = [[MoneyManager alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [UserPrefEventsCont.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row)
        {
                
            case 0:
                cell.textLabel.text = @"Manage Favorite Events";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            case 1:
                cell.textLabel.text = @"Group Entries By Tag";
                if ([thisSettings.displayMode isEqualToString: @"ByTag"])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
                
                
            case 2:
                cell.textLabel.text = @"Show Introduction";
                


                
                break;
                
                
                
        }
            break;
            
        case 1:
            
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Backup Data";
                    // add last backed up date
                    
                    break;
                    
                case 1:
                    cell.textLabel.text = @"Revert to last backup";

                    break;
                    
                case 2:
                    cell.textLabel.text = @"Delete Displayed Data";
                    
                    
                    break;

                    
                default:
                    break;
            }
            
            break;
            
            //third section
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AmountCell"];

                    if (moneyManager.payAmount == 0) {
                        cell.detailTextLabel.text = @"Touch to Set";


                    }
                    else
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", moneyManager.payAmount];
                        
                        
                    }
                    
                    cell.textLabel.text = @"Pay Amount";
                    break;
                    
//                case 1:
//                {
//                    
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DateCell"];
//
//                    
//                    if (moneyManager.payDate == nil) {
//                        cell.detailTextLabel.text = @"Touch to Set";
//                    }
//                    else
//                    {
//                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                        NSString *stringFromDate = [formatter stringFromDate: [moneyManager payDate]];
//                        
//                        cell.detailTextLabel.text =  stringFromDate;
//
//                    }
//                    cell.textLabel.text = @"Pay Date:";
//
//                    
//                    break;
//                }

                    
                case 1:
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AmountCell"];
                    
                    if (moneyManager.expenditureLimitGoal == 0) {
                        cell.detailTextLabel.text = @"Touch to Set";
                    }
                    else
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", moneyManager.expenditureLimitGoal];
                        
                    }
                    
                    cell.textLabel.text = @"Budget";
                    break;
//                case 2:
//                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AmountCell"];
//                    
//                    if (moneyManager.savingsGoal == 0) {
//                        cell.detailTextLabel.text = @"Touch to Set";
//                    }
//                    else
//                    {
//                        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", moneyManager.savingsGoal];
//                        
//                    }
//                    
//                    cell.textLabel.text = @"Savings Goal";
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    


    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Settings";
            break;
        case 1:
            return  [NSString stringWithFormat:@"Last Backup: %@", thisSettings.lastBackupDate];
            break;
        case 2:
            return @"Money Management";
            break;
        default:
            break;
    }
    
    return @"Settings";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row)
        {
            case 0:
                [self.navigationController pushViewController:UserPrefEventsCont animated:YES];
                break;
                
            case 1:
                if ([thisSettings.displayMode isEqualToString: @"ByTag"]) {
                    thisSettings.displayMode = @"ByEvent";
                }
                else
                {
                    thisSettings.displayMode = @"ByTag";
                }
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
                
                [viewContLink.delegate UpdateBankDisplay];
                [thisSettings SaveMisc];
                break;
            case 2:
            {
                [self.tabBarController setSelectedIndex:1];
                [viewContLink.delegate ShowIntro];
                break;
            }
            default:
                break;
        }

            break;
            
        //second section
        case 1:
        {

            switch (indexPath.row) {
                case 0:
                {

                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Replace last Backup"
                                                  message:@"Backing up will replace the last backup"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                                                {
                                                    //backup data
                                                    [thisSettings SaveBackup];
                                                    [MainSettingsDisplay reloadData];

                                                    
                                                    
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
                    
                    break;
                }
                case 1:
                {
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Load from Backup"
                                                  message:@"All current data will be replaced with Backup data. This action cannot be undone"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                                                {
                                                    
                                                    
                                                    [thisSettings LoadBackup];
                                                    [viewContLink.delegate UpdateBankAndSettings];
                                                    
                                                    
                                                    
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

                    
                    break;
                }
                case 2:
                {
                    //delete all data
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Delete"
                                                  message:@"Are you sure you want to delete ALL data?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"Confirm"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                                                {
                                                    [thisSettings ResetBank];
                                                    [viewContLink.delegate UpdateBankDisplay];
                                                    
                                                    
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
                    break;
                }
                default:
                    break;
            }
        }
            break;
            
        //third section
        case 2:
            
            switch (indexPath.row) {
                case 0:
                    [self PushEditSettCont:@"" withsettingInEdit:PayAmount];
                    break;
                case 1:
                    [self PushEditSettCont:@"" withsettingInEdit:ExpLimGoal];
                    break;
//                case 2:
//                    [self PushEditSettCont:@"" withsettingInEdit:SavingsGoal];
//                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    


    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)PushEditSettCont: (NSString*) placeholderText withsettingInEdit: (SettinginEdit) settingInEdit
{
    editSettingsCont.mainTextField.placeholder = placeholderText;
    editSettingsCont.settingInEdit = settingInEdit;
    [editSettingsCont.mainTextField becomeFirstResponder];
    switch (settingInEdit) {
        case PayAmount:
            editSettingsCont.mainTextField.text = [NSString stringWithFormat:@"$%.2f",moneyManager.payAmount];
            break;
        case ExpLimGoal:
            editSettingsCont.mainTextField.text = [NSString stringWithFormat:@"$%.2f",moneyManager.expenditureLimitGoal];
            break;
        case SavingsGoal:
            editSettingsCont.mainTextField.text = [NSString stringWithFormat:@"$%.2f",moneyManager.savingsGoal];
            break;
        default:
            break;
    }
    editSettingsCont.view.userInteractionEnabled = YES;
    editSettingsCont.view.alpha = 0.8;

    [UIView beginAnimations:@"openEditSettings" context:NULL];
    
    

    [UIView commitAnimations];
}

-(void)CloseEditSettCon
{
    editSettingsCont.mainTextField.placeholder = @"$0.00";
    editSettingsCont.settingInEdit = None;
    
    editSettingsCont.view.userInteractionEnabled = NO;
    
    [UIView beginAnimations:@"closeEditSettings" context:NULL];
    
    
    editSettingsCont.view.alpha = 0;
    
    [UIView commitAnimations];
    
}

-(void)SaveAndUpdateDisolay
{
    [thisSettings SaveMisc];
    //uodate summary
    [MainSettingsDisplay reloadData];
    [viewContLink.delegate UpdateBankDisplay];
}
-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
    
    MainSettingsDisplay.frame = CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height);
    
   
}

-(void)initialize
{

    if (UserPrefEventsCont == nil) {
        UserPrefEventsCont = [[ManageUserPreferredEvents alloc] initWithNibName:@"ManageUserPreferredEvents" bundle:[NSBundle mainBundle]];
    }

    if (thisSettings == nil) {
        
    }
}

-(void)InitWithSettings
{
    if (UserPrefEventsCont == nil) {
            UserPrefEventsCont = [[ManageUserPreferredEvents alloc] initWithNibName:@"ManageUserPreferredEvents" bundle:[NSBundle mainBundle]];
    }

}
@end
