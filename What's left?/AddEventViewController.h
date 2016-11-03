//
//  AddEventViewController.h
//  What's left?
//
//  Created by Swee Har Ng on 14/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "TagCell.h"
#import "IntroController.h"
@protocol addEventContDelegate <NSObject>
-(void)UpdateBankDisplay;
-(void)UpdateBank;
-(void)UpdateBankAndSettings;
-(void)UpdateSettingsData;
-(void)UpdateFavouriteEventsTable;
@end

@interface AddEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *containedTags;
    Event *EventInEdit;
}

@property NSMutableArray *tagsToDisplay;

@property float eventType;
@property Settings *thisSettings;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ModeControl;
@property (weak, nonatomic) IBOutlet UITextField *NameField;
@property (weak, nonatomic) IBOutlet UITextField *AmountField;
@property (weak, nonatomic) IBOutlet UITextField *AddTagField;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (weak, nonatomic) IBOutlet UIButton *AddTagButton;

@property (weak, nonatomic) IBOutlet UITableView *TagsTableView;
@property CGFloat tabBarHeight;



@property BOOL AddFavMode;
- (IBAction)SegmentContChange:(id)sender;
- (IBAction)AddTag:(id)sender;

- (IBAction)AddEventToBank:(id)sender;
-(void)SizingMisc;
-(void)EditEventMode: (Event*) event;
-(void)AddEventMode;
-(void)AddSpecifiedEvent:(Event*)event;
@property CGFloat hundredRelativePts;
@property UIScreen *screen;
@property BOOL editMode;

//delegates
@property (weak,nonatomic) id<addEventContDelegate> delegate;
@end
