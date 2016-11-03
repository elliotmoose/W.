//
//  FirstViewController.h
//  What's left?
//
//  Created by Swee Har Ng on 13/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"
#import "EventCell.h"
#import "SearchTableViewController.h"
#import "NameReviewController.h"
#import "TagReviewController.h"
#import "MonthReviewController.h"
#import "SecondViewController.h"
#import "ViewControllersLink.h"
#import "IntroController.h"
#import "ExportImportManager.h"
#import "SummaryTableViewController.h"
@interface FirstViewController : UIViewController<addEventContDelegate,bankDelegate, UISearchResultsUpdating,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,TagReviewDelegate,firstViewContDelegate>
{
    AddEventViewController *addEventViewCont;
}
- (IBAction)OpenControls:(id)sender;
- (IBAction)CloseControlsWithoutEvent:(id)sender;
- (IBAction)CloseControlsWithEvent:(id)sender forEvent:(UIEvent *)event;
@property SecondViewController *secondViewCont;
@property  NSArray *months;
@property (strong)Settings *thisSettings;
@property IntroController *introCont;
@property (weak, nonatomic) IBOutlet UIButton *FavoritesButton;
@property (weak, nonatomic) IBOutlet UIButton *WithdrawalButton;
@property (weak, nonatomic) IBOutlet UIButton *RecentsButton;
@property (weak, nonatomic) IBOutlet UIButton *DepositButton;
@property (weak, nonatomic) IBOutlet UIButton *ControlButton;

//arrays
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *FavButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *RecentsButtons;
@property NSMutableArray *FilteredItemsBySection;
@property NSMutableArray *SearchSectionTitles;


@property SummaryTableViewController *summaryCont;
//controllers
@property (strong, nonatomic) UISearchController *searchController;
@property (strong,nonatomic) SearchTableViewController *searchResultsController;
- (IBAction)TouchDraggedOutsideControl:(id)sender forEvent:(UIEvent *)event;

//---------------
//view controllers to push for reviews
//---------------
@property NameReviewController *nameRevCont;
@property TagReviewController *tagRevCont;
@property MonthReviewController *monthRevCont;


@property BOOL FavoriteButtonIsOpen;
@property BOOL FavButtonsAreOpen;
@property BOOL WithdrawalButtonIsOpen;
@property BOOL DepositButtonIsOpen;
@property BOOL RecentsButtonIsOpen;
@property BOOL RecentsButtonsAreOpen;

- (IBAction)WithDrawButtonEnter:(id)sender forEvent:(UIEvent *)event;
- (IBAction)WithDrawButtonExit:(id)sender forEvent:(UIEvent *)event;
- (IBAction)RecentsButtonEnter:(id)sender forEvent:(UIEvent *)event;
- (IBAction)RecentsButtonExit:(id)sender forEvent:(UIEvent *)event;
- (IBAction)DepositButtonEnter:(id)sender forEvent:(UIEvent *)event;
- (IBAction)DepositButtonExit:(id)sender forEvent:(UIEvent *)event;
- (IBAction)FavoritesButtonEnter:(id)sender forEvent:(UIEvent *)event;
- (IBAction)FavoritesButtonExit:(id)sender forEvent:(UIEvent *)event;


@property CGFloat hundredRelativePts;
@property UIScreen *screen;

@property (weak, nonatomic) IBOutlet UITableView *MainBankDisplay;

@property ViewControllersLink* viewContLink;

@property ExportImportManager *exportImportManager;
@end


//to do
//display of data
//saving of data

//greyed out add until filled up
//spending by month