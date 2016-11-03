//
//  AddEventViewController.m
//  What's left?
//
//  Created by Swee Har Ng on 14/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#import "AddEventViewController.h"

static AddEventViewController *singleton;
@interface AddEventViewController ()

@end

@implementation AddEventViewController
@synthesize ModeControl;
@synthesize NameField;
@synthesize AmountField;
@synthesize datePicker;
@synthesize AddTagField;
@synthesize thisSettings;
@synthesize AddTagButton;
@synthesize hundredRelativePts;
@synthesize screen;
@synthesize TagsTableView;
@synthesize editMode;
@synthesize tagsToDisplay;
@synthesize eventType;
@synthesize AddFavMode;
@synthesize  tabBarHeight;
-(id)init{
    if (singleton == nil) {
        singleton = self;
        
        
        [self SizingMisc];
        thisSettings = [[Settings alloc]init];
        
        eventType = 1;
        ModeControl.selectedSegmentIndex = 0;
        ModeControl.layer.cornerRadius = 4.0;
        ModeControl.clipsToBounds = true;
        containedTags = [[NSMutableArray alloc]init];
        tagsToDisplay = [[NSMutableArray alloc]init];
        editMode = false;
        [TagsTableView setDelegate:self];
        [TagsTableView setDataSource: self];
        
        [NameField setDelegate: self];
        [AmountField setDelegate:self];
        [AddTagField setDelegate: self];
        
        [self addDoneAndCancelBar];
        
        
        //UIColor *color = [UIColor colorWithHue:0.55 saturation:0.44 brightness:0.76 alpha:1];
        UIColor *color = [UIColor blackColor];
        if ([NameField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            NameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color,
                NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0]
                                                                                                              }];
            
            AmountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"$0.00" attributes:@{NSForegroundColorAttributeName: color,
                NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0]
                                                                                                                 }];
            
            AddTagField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add Tag" attributes:@{NSForegroundColorAttributeName: color,
                NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0]
                                                                                                                   }];
        }
        
        UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [ModeControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
    
        [datePicker setValue:color forKey:@"textColor"];
        [datePicker sendAction:NSSelectorFromString( @"setHighlightsToday:" ) to:nil forEvent:nil];
    }
     return singleton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (AddFavMode) {
        datePicker.enabled = NO;
    }
    else
    {
        datePicker.enabled = YES;
    }
    
    //select name text field
    if (!editMode && !AddFavMode) {
        [NameField becomeFirstResponder];

    }
    
    //reset tags table scroll
    TagsTableView.contentOffset = CGPointMake(0, 0 - TagsTableView.contentInset.top);
    [self SegmentContChange: ModeControl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SegmentContChange:(id)sender {
    
    switch (ModeControl.selectedSegmentIndex) {
        case 0:


            
            eventType = 1;
            break;
        case 1:


            
            eventType = -1;
            break;
        case 2:

            
            eventType = 0;
            break;
        default:
            break;
    }
    
    
   
}

- (IBAction)AddTag:(id)sender {

    if (![AddTagField.text isEqualToString: @""]) {
        if ([thisSettings.recTags containsObject:AddTagField.text]) {
            [containedTags insertObject:AddTagField.text atIndex:0];
            AddTagField.text = @"";
            
            [self LoadDisplayTags];
            [TagsTableView reloadData];
        }
        else
        {
            
            if ([containedTags containsObject:AddTagField.text]) {
                //select
            }
            else
            {
                [containedTags insertObject:AddTagField.text atIndex:0];
                [thisSettings.recTags addObject:AddTagField.text];
                [thisSettings SaveTags];
            }
            AddTagField.text = @"";
            
            [self LoadDisplayTags];
            [TagsTableView reloadData];
        }

    }
    

}

- (IBAction)AddEventToBank:(id)sender {

    [self EditOrAdd];
    
    
    NameField.text = @"";
    AmountField.text = @"$0.00";
    AddTagField.text = @"";
    [containedTags removeAllObjects];
    [TagsTableView reloadData];
    

                                  

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [NameField resignFirstResponder];
    [AmountField resignFirstResponder];
    [AddTagField resignFirstResponder];
}

-(void)EditOrAdd
{
    NSDate *date = [datePicker date];

    if ([NameField.text isEqualToString: @""]) {
        NameField.text = @"Untitled";
    }
    
    float outputAmount;
    NSArray *components = [[AmountField.text substringFromIndex:1] componentsSeparatedByString:@","];
    NSString *outputAmtString = [components componentsJoinedByString:@""];
    outputAmount = [outputAmtString floatValue];
    
    if (AddFavMode) {
        

        if (editMode == false) {
            [thisSettings AddFavEvent:NameField.text withAmount:outputAmount withDate:date witheventType:eventType withTags:[containedTags copy]];
            
            datePicker.enabled = NO;
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate UpdateSettingsData];
            [self.delegate UpdateFavouriteEventsTable];
            AddFavMode = false;
            return;
        }
        else
        {
            //edit favs
            [thisSettings EditFavEvent:EventInEdit withName:NameField.text withAmount:outputAmount withDate:date witheventType:eventType withTags:[containedTags copy]];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate UpdateSettingsData];
            [self.delegate UpdateFavouriteEventsTable];
            AddFavMode = false;
            editMode = false;
            return;
        }


    }
    else
    {
        datePicker.enabled = YES;
    }
    if (editMode == false) {
        [thisSettings.thisBank AddEvent:NameField.text withAmount: outputAmount withDate: date witheventType:eventType withTags:[containedTags copy]];
        [thisSettings AddRecEvent :NameField.text withAmount: [[AmountField.text substringFromIndex: 1] floatValue] withDate: date witheventType:eventType withTags:[containedTags copy]];
        
    }
    else
    {
        if (EventInEdit != nil) {
            [thisSettings.thisBank EditEvent:EventInEdit withName:NameField.text withAmount: outputAmount withDate: date witheventType:eventType withTags:[containedTags copy]];
            
            editMode = false;
            }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate UpdateBankAndSettings];
}

-(void)AddEventMode
{
    editMode = false;
    
    NameField.text = @"";
    AmountField.text = @"$0.00";
    AddTagField.text = @"";
    [containedTags removeAllObjects];
    
    [datePicker setDate: [NSDate date]];
    
    [self LoadDisplayTags];
    [TagsTableView reloadData];

}

-(void)EditEventMode:(Event *)event
{
    
    EventInEdit = event;
    eventType = event.eventType;

    
    switch ((int)event.eventType) {
        case -1:
            ModeControl.selectedSegmentIndex = 1;

            eventType = 1;
            break;
        case 0:
            ModeControl.selectedSegmentIndex = 2;

            eventType = -1;
            break;
        case 1:
            ModeControl.selectedSegmentIndex = 0;

            eventType = 0;
            break;
        default:
            break;
    }
    NameField.text = event.eventName;
    datePicker.date = event.eventDate;
    
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    AmountField.text = [_currencyFormatter stringFromNumber:[NSNumber numberWithFloat: event.eventValue]];
    
    containedTags = [event.tags mutableCopy];
    if (containedTags == nil && event.tags == nil) {
        containedTags = [[NSMutableArray alloc]init];
        event.tags = [[NSMutableArray alloc]init];
    }
    
    [self LoadDisplayTags];

    [TagsTableView reloadData];
    
    
}
-(void)AddSpecifiedEvent:(Event*)event
{
    eventType = event.eventType;
    if (event.eventType == 1) {
        ModeControl.selectedSegmentIndex = 0;
        
    }
    else if (event.eventType == -1)
    {
        ModeControl.selectedSegmentIndex = 1;
    }
    else if(event.eventType == 0)
    {
        ModeControl.selectedSegmentIndex = 2;
    }
    NameField.text = event.eventName;
    datePicker.date = [NSDate date];
    AmountField.text = [NSString stringWithFormat:@"$%.2f", event.eventValue];
    containedTags = [event.tags mutableCopy];
    if (containedTags == nil && event.tags == nil) {
        containedTags = [[NSMutableArray alloc]init];
        event.tags = [[NSMutableArray alloc]init];
    }
    [TagsTableView reloadData];

}



-(void)LoadDisplayTags
{
    [tagsToDisplay removeAllObjects];
    //1. current tags
    if (containedTags!= nil) {
        [tagsToDisplay addObjectsFromArray: containedTags];
    }
    
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    //2.favourite tags
    temp = [thisSettings.favTags mutableCopy];
    for (NSString *string in containedTags) {
        if ([temp containsObject:string]) {
            [temp removeObject: string];
        }
    }
    [tagsToDisplay addObjectsFromArray:temp];
    //3.recent tags
    
    [temp removeAllObjects];
    
    temp = [thisSettings.recTags mutableCopy];
    for (NSString *string in tagsToDisplay) {
        if ([temp containsObject:string]) {
            [temp removeObject: string];
        }
    }
    [tagsToDisplay addObjectsFromArray:temp];
    
    
}

-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
    self.view.frame = CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height);
    
    ModeControl.frame = CGRectMake(screen.bounds.size.width/2 -110, hundredRelativePts*0.05, 220, hundredRelativePts*0.28);
    NameField.frame = CGRectMake(screen.bounds.size.width/2 - hundredRelativePts, hundredRelativePts*0.4, hundredRelativePts*2, hundredRelativePts*0.28);
    AmountField.frame = CGRectMake(screen.bounds.size.width/2 - hundredRelativePts, hundredRelativePts*0.75, hundredRelativePts*2, hundredRelativePts*0.28);
    datePicker.frame = CGRectMake(0, hundredRelativePts, screen.bounds.size.width, hundredRelativePts*2);
    AddTagField.frame = CGRectMake(hundredRelativePts*0.5, hundredRelativePts*2.9, hundredRelativePts*2, hundredRelativePts*0.28);
    AddTagButton.frame = CGRectMake(screen.bounds.size.width - hundredRelativePts,  hundredRelativePts*2.9, hundredRelativePts*0.5, hundredRelativePts*0.3);
    TagsTableView.frame = CGRectMake(0, hundredRelativePts*3.25, screen.bounds.size.width, screen.bounds.size.height - hundredRelativePts*3.75 - tabBarHeight);

    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(AddEventToBank:)];
    self.navigationItem.rightBarButtonItem = confirmButton;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tagsToDisplay.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (TagCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TagsCell";
    
    TagCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = tagsToDisplay[indexPath.row];
    
    if ([containedTags containsObject:tagsToDisplay[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tags";
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
                                        NSString *thisTag = [tagsToDisplay objectAtIndex: indexPath.row];
                                        if ([thisSettings.recTags containsObject:thisTag]) {
                                            [thisSettings.recTags removeObject: thisTag];
                                        }
                                        if ([thisSettings.favTags containsObject:thisTag]) {
                                            [thisSettings.favTags removeObject: thisTag];
                                        }
                                        
                                        if ([containedTags containsObject: thisTag]) {
                                            [containedTags removeObject:thisTag];
                                        }
                                        
                                        //delete tags from all events that have that tag
                                        for(int i = 0; i < thisSettings.thisBank.events.count; i++)
                                        {
                                            Event *event = thisSettings.thisBank.events[i];
                                            [event RemoveTag: thisTag];
                                            
                                        }

                                        [thisSettings SaveTags];
                                        [self LoadDisplayTags];
                                        // tell table to refresh now
                                        [TagsTableView reloadData];
                                        
                                        [thisSettings SaveBank];
                                        [self.delegate UpdateBank];
                                        

                                        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //toggle on and off
    if ([containedTags containsObject:[tagsToDisplay objectAtIndex: indexPath.row]]) {
        [containedTags removeObject: [tagsToDisplay objectAtIndex: indexPath.row]];
    }
    else
    {
        [containedTags insertObject:[tagsToDisplay objectAtIndex: indexPath.row] atIndex:containedTags.count];
        [thisSettings.recTags removeObject:[tagsToDisplay objectAtIndex: indexPath.row]];
        [thisSettings.recTags insertObject:[tagsToDisplay objectAtIndex: indexPath.row] atIndex:0];
        [thisSettings SaveTags];

    }
    
    [self LoadDisplayTags];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == AmountField) {
        
        NSString *cleanCentString = [[textField.text componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSInteger centValue = [cleanCentString intValue];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber *myNumber = [f numberFromString:cleanCentString];
        NSNumber *result;
        
        if([textField.text length] < 40){
            if (string.length > 0)
            {
                centValue = centValue * 10 + [string intValue];
                double intermediate = [myNumber doubleValue] * 10 +  [[f numberFromString:string] doubleValue];
                result = [[NSNumber alloc] initWithDouble:intermediate];
            }
            else
            {
                centValue = centValue / 10;
                double intermediate = [myNumber doubleValue]/10;
                result = [[NSNumber alloc] initWithDouble:intermediate];
            }
            
            myNumber = result;
            //NSLog(@"%ld ++++ %@", (long)centValue, myNumber);
            NSNumber *formatedValue;
            formatedValue = [[NSNumber alloc] initWithDouble:[myNumber doubleValue]/ 100.0f];
            NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
            //[_currencyFormatter setUsesGroupingSeparator: false];
            [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            textField.text = [_currencyFormatter stringFromNumber:formatedValue];
            return NO;
        }else{
            
            NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
            [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            textField.text = [_currencyFormatter stringFromNumber:00];
            
            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Deposit Amount Limit"
            //                                                       message: @"You've exceeded the deposit amount limit. Kindly re-input amount"
            //                                                      delegate: self
            //                                             cancelButtonTitle:@"Cancel"
            //                                             otherButtonTitles:@"OK",nil];
            //        
            //        [alert show];
            return NO;
        }
        return YES;
    }

    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)cancelNumberPad{
    [AmountField resignFirstResponder];
    AmountField.text = @"$0.00";
}

-(void)doneWithNumberPad{
    
    if (NameField.isFirstResponder) {
        [NameField resignFirstResponder];
        [AmountField becomeFirstResponder];
    }
    else if (AmountField.isFirstResponder) {
        [AmountField resignFirstResponder];

    }
    else if (AddTagField.isFirstResponder) {
        [AddTagField resignFirstResponder];
    }
}

-(void)addDoneAndCancelBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(cancelNumberPad)];
    [cancelButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                          forState:UIControlStateNormal];
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(doneWithNumberPad)];
    [doneButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                                forState:UIControlStateNormal];
    
    numberToolbar.items = @[cancelButton,
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            doneButton];
    [numberToolbar sizeToFit];
    AmountField.inputAccessoryView = numberToolbar;
    NameField.inputAccessoryView = numberToolbar;
    AddTagField.inputAccessoryView = numberToolbar;


}
@end
