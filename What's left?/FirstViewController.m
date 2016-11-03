//
//  FirstViewController.m
//  What's left?
//
//  Created by Swee Har Ng on 13/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize FavoritesButton;
@synthesize WithdrawalButton;
@synthesize RecentsButton;
@synthesize DepositButton;
@synthesize ControlButton;
@synthesize hundredRelativePts;
@synthesize screen;
@synthesize MainBankDisplay;
@synthesize thisSettings;
@synthesize FavoriteButtonIsOpen;
@synthesize WithdrawalButtonIsOpen;
@synthesize RecentsButtonIsOpen;
@synthesize DepositButtonIsOpen;
@synthesize RecentsButtonsAreOpen;
@synthesize RecentsButtons;
@synthesize FavButtons;
@synthesize FavButtonsAreOpen;
@synthesize searchResultsController;
@synthesize FilteredItemsBySection;
@synthesize months;
@synthesize SearchSectionTitles;
@synthesize secondViewCont;
@synthesize exportImportManager;
//view cont for reviews
@synthesize nameRevCont;
@synthesize tagRevCont;
//@synthesize monthRevCont;
@synthesize viewContLink;
@synthesize introCont;

@synthesize summaryCont;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tabBarController setSelectedIndex:1];
    [self SizingMisc];
    [self PrepSearchBar];
    [self LoadReviewControllers];
    [self initArrays];
    
    thisSettings = [[Settings alloc]init];
    summaryCont = [[SummaryTableViewController alloc]init];
    summaryCont.tableView = [[UITableView alloc]initWithFrame:screen.bounds];
    addEventViewCont = [[AddEventViewController alloc]init];
    [addEventViewCont setDelegate: self];
    addEventViewCont.delegate = self;
    addEventViewCont.tabBarHeight = [[[self tabBarController] tabBar] bounds].size.height;
    [addEventViewCont SizingMisc];
    
    //colors
    MainBankDisplay.backgroundColor = [UIColor lightGrayColor];
    self.searchController.searchBar.barTintColor = UIColorFromRGB(0x009688);
    [self.tabBarController.tabBar setTintColor:UIColorFromRGB(0XC0FEF7)];

    


    //[self ResetBank];
    [self LoadSettingsInitial];
    [self UpdateBank];
    
    [self SetSecondViewLink];
    
    [secondViewCont InitWithSettings];
    
    viewContLink = [[ViewControllersLink alloc]init];
    viewContLink.delegate = self;
    
    exportImportManager = [[ExportImportManager alloc]init];
    //check for intro
    [self InitIntroCont];
    if (!thisSettings.hasDoneIntro) {
        [self ShowIntro];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [NSTimer scheduledTimerWithTimeInterval:0
                                     target:self
                                   selector:@selector(UpdateNavBarTitle)
                                   userInfo:nil
                                    repeats:NO];
    
    //[self UpdateNavBarTitle];
    [self UpdateFavRecButtonTitles];
    MainBankDisplay.contentOffset = CGPointMake(0, 0 - (MainBankDisplay.contentInset.top - self.searchController.searchBar.bounds.size.height ));
    
    if (!thisSettings.hasDoneIntro) {
        [introCont IntroTrigger:6];
    }
    if (!thisSettings.hasDoneIntro) {
        [introCont IntroTrigger:4];
    }
    


}


-(void)initArrays
{
    months = [[NSArray alloc] initWithObjects:@"January",@"Febuary",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    FilteredItemsBySection = [[NSMutableArray alloc]init];
    SearchSectionTitles = [[NSMutableArray alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenControls:(id)sender {
    
//    [FavoritesButton setTranslatesAutoresizingMaskIntoConstraints:YES];


    [UIView beginAnimations:@"openControls" context:NULL];
    
    [self OpenDeposit];
    [self OpenFavs];
    [self OpenRecents];
    [self OpenWithdraw];

    [UIView commitAnimations];
    
    
    

}

- (IBAction)CloseControlsWithoutEvent:(id)sender {

   
    [UIView beginAnimations:@"openControls" context:NULL];
    
    [self CloseDeposit];
    [self CloseWithdraw];
    [self CloseRecents];
    [self CloseFavs];
    
    [UIView commitAnimations];

}


- (IBAction)CloseControlsWithEvent:(id)sender forEvent:(UIEvent *)event {
    
    NSArray *theTouches = [[event allTouches] allObjects];
    
    if([FavoritesButton pointInside:[[theTouches objectAtIndex:0] locationInView:FavoritesButton] withEvent:event]){
        [self FavButtonAction];
    }
    
    if([RecentsButton pointInside:[[theTouches objectAtIndex:0] locationInView:RecentsButton] withEvent:event]){
        [self RecentsButtonAction];
    }
    
    if([DepositButton pointInside:[[theTouches objectAtIndex:0] locationInView:DepositButton] withEvent:event]){
        [self DepositButtonAction];
    }
    
    if([WithdrawalButton pointInside:[[theTouches objectAtIndex:0] locationInView:WithdrawalButton] withEvent:event]){
        [self WithdrawButtonAction];
    }
    
    for (UIButton *button in FavButtons) {
        if([button pointInside:[[theTouches objectAtIndex:0] locationInView:button] withEvent:event]){
            NSInteger buttonIndex = [FavButtons indexOfObject:button];
            [self FavSubAction:buttonIndex];
        }
    }
    
    for (UIButton *button in RecentsButtons) {
        if([button pointInside:[[theTouches objectAtIndex:0] locationInView:button] withEvent:event]){
            NSInteger buttonIndex = [RecentsButtons indexOfObject:button];
            [self RecSubAction:buttonIndex];
        }
    }

    [UIView beginAnimations:@"openControls" context:NULL];
  
    [self CloseDeposit];
    [self CloseWithdraw];
    [self CloseRecents];
    [self CloseFavs];
    
    [UIView commitAnimations];

}

-(void)CloseAllExcept: (UIButton*) button
{
    
    
    [UIView beginAnimations:@"openControls" context:NULL];

    
    if (FavoritesButton == button) {
        [self CloseDeposit];
        [self CloseWithdraw];
        [self CloseRecents];
        //make into methodddd
    }
    
    if (RecentsButton == button) {
        [self CloseDeposit];
        [self CloseWithdraw];
        [self CloseFavs];
    }
    
    
    [UIView commitAnimations];

}


-(void)FavButtonAction
{
//    purchaseViewCont = [[PurchaseViewController alloc] initWithNibName:@"PurchaseViewController" bundle:nil];
//    [purchaseViewCont setDelegate:self];
//    
//    [self.navigationController pushViewController:addEventViewCont animated:YES];
}

-(void)RecentsButtonAction
{
    
}

-(void)DepositButtonAction
{
    [addEventViewCont AddEventMode];
    [self.navigationController pushViewController:addEventViewCont animated:YES];
    addEventViewCont.ModeControl.selectedSegmentIndex = 0;
    addEventViewCont.eventType = 1;

    if (!thisSettings.hasDoneIntro) {
        [introCont IntroTrigger:5];
    }
}

-(void)WithdrawButtonAction
{
    [addEventViewCont AddEventMode];
    [self.navigationController pushViewController:addEventViewCont animated:YES];
    addEventViewCont.ModeControl.selectedSegmentIndex = 1;
    addEventViewCont.eventType = -1;

}
-(void)FavSubAction: (NSInteger) buttonIndex
{
    Event* calledEvent = [thisSettings.favEvents objectAtIndex:buttonIndex];
    [addEventViewCont AddSpecifiedEvent:calledEvent];
    [self.navigationController pushViewController:addEventViewCont animated:YES];
}
-(void)RecSubAction: (NSInteger) buttonIndex
{
    Event* calledEvent = [thisSettings.recEvents objectAtIndex:buttonIndex];
    [addEventViewCont AddSpecifiedEvent:calledEvent];
    [self.navigationController pushViewController:addEventViewCont animated:YES];
}

//-(void)AddShadowToButton: (UIButton*) button
//{
//    button.layer.masksToBounds = NO;
//    button.layer.shadowColor = [UIColor blackColor].CGColor;
//    button.layer.shadowOpacity = 0.8;
//    button.layer.shadowRadius = 2;
//    button.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//}

-(void)HideShadowForButton: (UIButton*) button
{
   //button.layer.shadowOpacity = 0;
}
-(void)ShowShadowForButton: (UIButton*) button
{
    //button.layer.shadowOpacity = 0.8;
}
-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
    
    
    ControlButton.frame = CGRectMake((screen.bounds.size.width - hundredRelativePts)/2, screen.bounds.size.height - hundredRelativePts/2 - [[[self tabBarController] tabBar] bounds].size.height, hundredRelativePts, hundredRelativePts);
    
    [ControlButton setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];
    [FavoritesButton setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];
    [WithdrawalButton setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];
    [RecentsButton setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];
    [DepositButton setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];

    FavoritesButton.frame = ControlButton.frame;
    WithdrawalButton.frame = ControlButton.frame;
    RecentsButton.frame = ControlButton.frame;
    DepositButton.frame = ControlButton.frame;

//    [self AddShadowToButton:FavoritesButton];
//    [self AddShadowToButton:WithdrawalButton];
//    [self AddShadowToButton:RecentsButton];
//    [self AddShadowToButton:DepositButton];
//    
//    for (UIButton *button in FavButtons) {
//        [self AddShadowToButton:button];
//    }
//    for (UIButton *button in RecentsButtons) {
//        [self AddShadowToButton:button];
//    }
    
    
    
    for (UIButton *button in RecentsButtons) {
        [button setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];
        button.frame = ControlButton.frame;
    }
    
    for (UIButton *button in FavButtons) {
        [button setValue: [NSNumber numberWithDouble: hundredRelativePts/2] forKeyPath:@"layer.cornerRadius"];
        button.frame = ControlButton.frame;
    }
    
    [self.view bringSubviewToFront:ControlButton];
    
    //main display setup
    
    MainBankDisplay.frame = CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height/* + [[[self tabBarController] tabBar] bounds].size.height*/);
    
    //buttons text aligntment
    for (UIButton *button in FavButtons) {
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    for (UIButton *button in RecentsButtons) {
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

-(void)PrepSearchBar
{
    // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case
    self.searchResultsController = [[SearchTableViewController alloc] init];
    self.searchResultsController.tableView.frame = CGRectMake(0, hundredRelativePts*0.5 + self.searchController.searchBar.frame.size.height, screen.bounds.size.width, screen.bounds.size.height - [[[self tabBarController] tabBar] bounds].size.height - hundredRelativePts*0.5 - self.searchController.searchBar.frame.size.height);

    // Init UISearchController with the search results controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    // Link the search controller
    self.searchController.searchResultsUpdater = self;
    
    // This is obviously needed because the search bar will be contained in the navigation bar
    self.searchController.hidesNavigationBarDuringPresentation = YES;

    // Required (?) to set place a search bar in a navigation bar
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    
    // This is where you set the search bar in the navigation bar, instead of using table view's header ...
    self.MainBankDisplay.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"Search by name/tag";
    // To ensure search results controller is presented in the current view controller
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
}

//=======================================================================================
//                                         SET SEARCH RESULTS
//=======================================================================================
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    if ([searchString isEqualToString: @""]) {
        return;
    }
    [FilteredItemsBySection removeAllObjects];
    //search by name
    NSMutableArray *thisNameFilteredEvents = [[NSMutableArray alloc]init];
    
    [thisNameFilteredEvents removeAllObjects];
    [SearchSectionTitles removeAllObjects];
    
    //by claimable
    NSMutableArray *claimableEvents = [[NSMutableArray alloc]init];

    if ([@"claimable" containsString:[searchString lowercaseString]]) {
        for (Event *event in thisSettings.thisBank.events) {
            //by name
            if (event.eventType == 0) {
                [claimableEvents addObject:event];
            }
        }
    }
    
    if (claimableEvents.count != 0) {
        [FilteredItemsBySection addObject:claimableEvents];
        [SearchSectionTitles addObject: @"Claimable"];
        
    }
    
    //by event
    for (Event *event in thisSettings.thisBank.events) {
        //by name
        if ([[event.eventName lowercaseString] containsString:[searchString lowercaseString]]) {
            [thisNameFilteredEvents addObject:event];
        }
    }
    
    if (thisNameFilteredEvents.count != 0) {
        [FilteredItemsBySection addObject:thisNameFilteredEvents];
        [SearchSectionTitles addObject: @"Search By Name"];
        
    }
    
    //by tag
    for (NSString *tag in thisSettings.thisBank.allTags)
    {
        NSMutableArray *thisTagFilteredEvents = [[NSMutableArray alloc]init];
        [thisTagFilteredEvents removeAllObjects];

        if ([[tag lowercaseString] containsString:[searchString lowercaseString]]) {
            for (Event *event in thisSettings.thisBank.events) {
                
                
                for (NSString *tagx in event.tags) {
                    if ([tagx isEqualToString: tag]) {
                        [thisTagFilteredEvents addObject:event];
                    }
                }
                
            }
            
            if (thisTagFilteredEvents.count != 0) {
                //insert view more cell
                Event *viewMore = [[Event alloc]init];
                viewMore.isViewMore = YES;
                [thisTagFilteredEvents insertObject:viewMore atIndex:0];
                
                [FilteredItemsBySection addObject:thisTagFilteredEvents];
                [SearchSectionTitles addObject: [NSString stringWithFormat:@"Search By Tag: %@",tag]];
                
                
                //Spent In Last Month
                //if settings is gonna change for it its here. check for what mode -> change the type of calculation
                
                viewMore.eventName = [NSString stringWithFormat: @"Spent This Month: %.2f",[thisSettings.thisBank CalculateSpendingByMonthByTag:tag withMonthAndYear:[thisSettings.thisBank MonthAndYearFromDate:[NSDate date]]]];
                
                
            }        }
        
       
    }


        //by month
        
        //1. get name of months and create one array for each
        for (NSString *MonthAndYear in thisSettings.thisBank.allMonthsDatesString) {
            
            NSString *thisMonthName = [months objectAtIndex: ([[[MonthAndYear substringToIndex:7]substringFromIndex:5] integerValue] -1)];
            
            if ([[thisMonthName lowercaseString] containsString:[searchString lowercaseString]])
            {
                
                NSMutableArray *thisMonthFilteredEvents = [[NSMutableArray alloc]init];
                [thisMonthFilteredEvents removeAllObjects];
                //for each month, search if event is in this month. if so add into month array
                for (Event *event in thisSettings.thisBank.events) {
                    NSString *thisEventMonthAndYear = [thisSettings.thisBank MonthAndYearFromDate:event.eventDate];
                    
                    if ([thisEventMonthAndYear isEqualToString: MonthAndYear]) {
                        [thisMonthFilteredEvents addObject: event];
                    }

                } 
                
                //month collated -> add to overall
                if (thisMonthFilteredEvents.count != 0) {
                    
                    Event *viewMore = [[Event alloc]init];
                    viewMore.isViewMore = YES;
                    
                    Event *firstEvent = [thisMonthFilteredEvents objectAtIndex: 0];
                    viewMore.eventName = [NSString stringWithFormat: @"Spent in %@/%ld: %.2f",thisMonthName,(long)[thisSettings.thisBank YearFromDate:firstEvent.eventDate],[thisSettings.thisBank CalculateSpendingByMonthAndYear:MonthAndYear]];
                    
                    //check event cell not event
                    
                    [thisMonthFilteredEvents insertObject:viewMore atIndex:0];
                    [FilteredItemsBySection addObject:thisMonthFilteredEvents];
                    [SearchSectionTitles addObject: [NSString stringWithFormat:@"Search By Month: %@",[thisMonthName substringToIndex:3]]];
                }
            }
        }
        
    

    [self.searchResultsController.tableView reloadData];
}



- (void)setTitle:(NSString *)title
{
    //[super setTitle:title];
    
    //get index of last number
    //which is index of 3rd space
    NSString* claimableText = [[title componentsSeparatedByString:@" "]objectAtIndex:3];
    NSString* frontText = [[title componentsSeparatedByString:@"+"]objectAtIndex:0];

    NSRange range = [title rangeOfString:claimableText];
    NSRange rangeFront = [title rangeOfString:frontText];
    
    UILabel *titleView = (UILabel *)self.navigationController.navigationBar.topItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        //titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    
    
    [text setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                  range:range];
    [text setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x212121)}
                  range:rangeFront];
    [titleView setAttributedText: text];
    

    self.navigationController.navigationBar.topItem.titleView = titleView;
    [titleView sizeToFit];
    
    [self reloadInputViews];
    
}

-(void)UpdateBankAndSettings{
    
    [self UpdateBank];
    [self UpdateSettingsData];
}


-(void)UpdateBank //not to update the info but to update the info going to display-> not in but out
{
    [thisSettings.thisBank CalculateBalance];
    [thisSettings.thisBank ArrangeAndSplitByMonth:thisSettings.thisBank.events withOutput:thisSettings.thisBank.eventsInMonths];
    [thisSettings.thisBank ArrangeAndSplitByPayCycle:thisSettings.thisBank.events withOutput:thisSettings.thisBank.eventsInPayCycle];
    [thisSettings.thisBank LoadAllTags];
    [thisSettings.thisBank LoadAllMonthsArray];
    
    [self UpdateBankDisplay];

}
-(void)UpdateBankDisplay
{
    [self UpdateFavRecButtonTitles];
    [self UpdateNavBarTitle];
    

    [MainBankDisplay reloadData];
    [tagRevCont.tableView reloadData];

//update widgets
    [summaryCont.tableView reloadData];
}

-(void)UpdateFavRecButtonTitles
{
    //fav and rec display update
    for (UIButton *button in FavButtons) {
        Event *relativeEvent = [thisSettings.favEvents objectAtIndex: [FavButtons indexOfObject: button]];
        [button setTitle:relativeEvent.eventName forState:UIControlStateNormal];
    }
    
    for (UIButton *button in RecentsButtons) {
        Event *relativeEvent = [thisSettings.recEvents objectAtIndex: [RecentsButtons indexOfObject: button]];
        [button setTitle:relativeEvent.eventName forState:UIControlStateNormal];
    }
}

-(void)UpdateNavBarTitle
{
    NSString *navBarTitle = [NSString stringWithFormat: @"Balance : $%.2f +($%.2f)",thisSettings.thisBank.Balance,thisSettings.thisBank.claimableBalance];
    //[self.navigationController.navigationBar.topItem setTitle:navBarTitle];
    [self setTitle:navBarTitle];
}
-(void)LoadSettingsInitial
{
    [thisSettings LoadBankInitial];
    [self LoadSettings];
}
-(void)LoadSettings
{
    [thisSettings LoadSettings];
    [secondViewCont InitWithSettings];
    [secondViewCont.UserPrefEventsCont.tableView reloadData];
}
-(void)UpdateSettingsData
{
    [thisSettings SaveSettings];
    [thisSettings LoadSettings];
    
}



-(void)searchBar: (UISearchBar*)searchBar textDidChange:(nonnull NSString *)searchText
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;

    if (tableView == self.searchResultsController.tableView) {
        NSMutableArray *thisSection = FilteredItemsBySection[section];
        return thisSection.count;
    }
    
    if ([thisSettings.displayMode isEqualToString:@"ByTag"])
    {
        //not by event, but by tag name -> set cell mode then set its title
        NSMutableArray *arrayOfTagsInThisMonth = [[self TitlesByMonthByTag] objectAtIndex:section];
        numberOfRows = arrayOfTagsInThisMonth.count;
    }
    else if( [thisSettings.displayMode isEqualToString:@"ByEvent"])
    {
        if (thisSettings.thisBank.eventsInMonths.count > 0) {
            NSMutableArray *thisMonth = thisSettings.thisBank.eventsInMonths[section];
            numberOfRows = thisMonth.count;
        }
    }
   
    return numberOfRows;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.searchResultsController.tableView) {
        return FilteredItemsBySection.count;
    }
    return thisSettings.thisBank.noOfMonths;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    if (tableView == self.searchResultsController.tableView) {
//
//    }
//   
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return hundredRelativePts*0.4;
}

//=======================================================================================
//                                          CREATE SECTION HEADER VIEW
//=======================================================================================
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeight = hundredRelativePts*0.4;
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.bounds.size.width, sectionHeight)];
    
    [[customView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen.bounds.size.width - hundredRelativePts*1.4,sectionHeight)];
    
    titleView.textAlignment = NSTextAlignmentCenter;
    //titleView.backgroundColor =  UIColorFromRGB(0x009688);
    titleView.backgroundColor = Rgb2UIColor(0, 150, 137);
    titleView.font = [UIFont boldSystemFontOfSize:17.0];

    
    if (tableView == self.searchResultsController.tableView) {
        
        if (SearchSectionTitles != 0) {
            titleView.text = [SearchSectionTitles objectAtIndex:section];
        }
        else
        {
            
        }
        

        // create the parent view that will hold header Label
        
//        
//        // create the button object if its not search by name (From section title)
//        if (![[SearchSectionTitles objectAtIndex:section] isEqualToString: @"Search By Name"] && ![[SearchSectionTitles objectAtIndex:section] isEqualToString: @"Claimable"]) {
//            UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen.bounds.size.width - hundredRelativePts*1.4, 0.0, hundredRelativePts*1.4, sectionHeight)];
//            headerBtn.backgroundColor = [UIColor lightGrayColor];
//            
//            [headerBtn setTitle:@"View More" forState:UIControlStateNormal];
//            [headerBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
//            headerBtn.tag = section;
//            [headerBtn addTarget:self action:@selector(SectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [customView addSubview:headerBtn];
//        }
//        else
//        {
            titleView.frame = CGRectMake(0, 0, screen.bounds.size.width ,sectionHeight);
//        }
        

    }
    else
    {
        titleView.frame = CGRectMake(0, 0, screen.bounds.size.width, sectionHeight);
        if (thisSettings.thisBank.eventsInMonths.count == 0 || thisSettings.thisBank.events.count == 0) {
            titleView.text =  @"No Entries Yet";
        }
        
        
        Event *firstEventInSection = thisSettings.thisBank.eventsInMonths[section][0];
        NSInteger monthInteger = [thisSettings.thisBank MonthFromDate: firstEventInSection.eventDate];
        
        if (monthInteger <1) {
            titleView.text =  @"No Entries Yet";
        }
        
        //calculate month balance
        NSArray *thisMonth = thisSettings.thisBank.eventsInMonths[section];
        
        
        NSString *thisMonthString = [months objectAtIndex:monthInteger -1];
        NSString *SectionTitle = [NSString stringWithFormat:@"%@/%ld S:%.2f B: %.2f", thisMonthString,(long)[thisSettings.thisBank YearFromDate:firstEventInSection.eventDate],-[thisSettings.thisBank CalculateMonthExpenditure:thisMonth],[thisSettings.thisBank CalculateMonthBalance:thisMonth]];
        titleView.text = SectionTitle;
        titleView.textColor = UIColorFromRGB(0xFFFFFF);
        

    }
    
    [customView addSubview:titleView];
    return customView;
}

//=======================================================================================
//                                          CREATE CELLS CONTENT
//=======================================================================================
- (EventCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil] objectAtIndex:0];
    if (cell == nil) {
        cell = [[EventCell alloc] init];
    }
    
    // Configure the cell...
    
    //if it is the search tableview
    if (tableView == self.searchResultsController.tableView) {
        
        cell.thisEvent = [[FilteredItemsBySection objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
        
        if (cell.thisEvent.isViewMore) {
            cell.isViewMore = true;
        }
        [cell UpdateCell:@"ViewMore"];
        return cell;
    }
    NSInteger rowCount = 0;
    
    for (NSInteger i = 0; i < indexPath.section; i++) {
        //for all the sectiongs before this section
        //add up the number of their rows
        rowCount += [tableView numberOfRowsInSection:i];
        
    }
    //row number is now the number of rows in all other sections
    //to get index of this row within the section. indexpath row - all other rows
    
    if ([thisSettings.displayMode isEqualToString:@"ByTag"])
    {
        //not by event, but by tag name -> set cell mode then set its title
        cell.tagTitle = [[[self TitlesByMonthByTag] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.tagValue = [[[[self ValuesByMonthByTag]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] floatValue];
    }
    else if( [thisSettings.displayMode isEqualToString:@"ByEvent"])
    {
        Event *thisEvent = [[thisSettings.thisBank.eventsInMonths objectAtIndex:indexPath.section] objectAtIndex:(indexPath.row)];
        cell.thisEvent = thisEvent;
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld , %ld", (long)indexPath.section,(long)indexPath.row];
    [cell UpdateCell:thisSettings.displayMode];
    return cell;
}

//=======================================================================================
//                                          SELECT CELLS
//=======================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchResultsController.tableView) {
        Event *thisEvent = [FilteredItemsBySection[indexPath.section] objectAtIndex:indexPath.row];
        
        if (thisEvent.isViewMore) {
            //load nav cont
        }
        else
        {
            [self.navigationController pushViewController:addEventViewCont animated:YES];
            [addEventViewCont EditEventMode:thisEvent];
            addEventViewCont.editMode = true;
        }
        
        
    }
    else
    {
        if ([thisSettings.displayMode isEqualToString:@"ByEvent"]) {
            [self.navigationController pushViewController:addEventViewCont animated:YES];
            Event *thisEvent = [[thisSettings.thisBank.eventsInMonths objectAtIndex:indexPath.section] objectAtIndex:(indexPath.row)];
            [addEventViewCont EditEventMode:thisEvent];
            addEventViewCont.editMode = true;
        }
        else if([thisSettings.displayMode isEqualToString:@"ByTag"])
        {
            [self.navigationController pushViewController:tagRevCont animated:YES];
            tagRevCont.arrayOfEventsToReview = [[[self DisplayArrayByTagByMonth] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [tagRevCont.tableView reloadData];
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//=======================================================================================
//                                          SELECT VIEW MORE
//=======================================================================================
//- (IBAction) SectionButtonPressed:(id)sender {
//    //view more
//    
//    UIButton *buttonClicked = (UIButton *)sender;
//    NSMutableArray *thisGroupOfEvents = [[NSMutableArray alloc]init];
//    thisGroupOfEvents = [FilteredItemsBySection objectAtIndex:buttonClicked.tag];
//    
//    //find out if its by name/tag/month
//    NSString *firstLetterFromSearchBy = [[[SearchSectionTitles objectAtIndex:buttonClicked.tag] substringWithRange:NSMakeRange(10, 1)] lowercaseString];
//    NSString *keyWord = [SearchSectionTitles objectAtIndex: buttonClicked.tag]; //the name or month or tag
//    NSArray *array = [keyWord componentsSeparatedByString:@": "];
//    
//    if ([firstLetterFromSearchBy isEqualToString:@"n"])
//    {
//        NSString *thisName = [array objectAtIndex:1];
//        [self.navigationController pushViewController:nameRevCont animated:YES];
//    }
//    
//    if ([firstLetterFromSearchBy isEqualToString:@"t"])
//    {
//        NSString *thisTag = [array objectAtIndex:1];
//        [self.navigationController pushViewController:tagRevCont animated:YES];
//        [tagRevCont.arrayOfEventsToReview removeAllObjects];
//        for (Event *event in thisSettings.thisBank.events) {
//            if ([event.tags containsObject:thisTag]) {
//                [tagRevCont.arrayOfEventsToReview addObject:event];
//            }
//        }
//        [tagRevCont.tableView reloadData];
//    }
//    if ([firstLetterFromSearchBy isEqualToString:@"m"])
//    {
//        NSInteger thisMonthNumber = 0;
//        NSString *thisMonthName = @"";
//        for (NSString *monthName in months) {
//            if ([monthName containsString:[array objectAtIndex:1]]) {
//                thisMonthNumber = [months indexOfObject:monthName];
//                thisMonthName = monthName;
//                break;
//            }
//        }
//        NSMutableArray *thisGroupOfEvents = [[NSMutableArray alloc]init];
//        thisGroupOfEvents = thisSettings.thisBank.eventsInMonths[buttonClicked.tag];
////        
//        Event *firstEventInSection = thisSettings.thisBank.eventsInMonths[buttonClicked.tag][0];
//        NSInteger monthInteger = [thisSettings.thisBank MonthFromDate: firstEventInSection.eventDate];
//        NSString *thisMonthString = [months objectAtIndex:monthInteger -1];
//                        thisMonthString = [NSString stringWithFormat: @"%@/%ld",thisMonthName,(long)[thisSettings.thisBank YearFromDate:firstEventInSection.eventDate]];
//        [monthRevCont ToShow:thisGroupOfEvents withTitle:thisMonthString];
//        [self.navigationController pushViewController:monthRevCont animated:YES];
//
//    }
//}


//=======================================================================================
//                                          CREATE SECTION FOOTER VIEW
//=======================================================================================
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    CGFloat sectionHeight = hundredRelativePts*0.28;
//    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.bounds.size.width, sectionHeight)];
//    
//    [[customView subviews]
//     makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//
//    if (tableView != self.searchResultsController.tableView) {
//        Event *firstEventInSection = thisSettings.thisBank.eventsInMonths[section][0];
//        NSInteger monthInteger = [thisSettings.thisBank MonthFromDate: firstEventInSection.eventDate];
//        NSString *thisMonthString = [months objectAtIndex:monthInteger -1];
//        NSString *SectionTitle = [NSString stringWithFormat:@"View More For: %@", thisMonthString];
//
//        UIButton * footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen.bounds.size.width, sectionHeight)];
//        footerBtn.backgroundColor = UIColorFromRGB(0xB2DFDB);
//        [footerBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
//
//        [footerBtn setTitle:SectionTitle forState:UIControlStateNormal];
//        footerBtn.tag = section;
//        [footerBtn addTarget:self action:@selector(FooterViewMorePressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [customView addSubview:footerBtn];
//
//    }
//
//    
//    return customView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    CGFloat sectionHeight = hundredRelativePts*0.28;
//
//    return sectionHeight;
//}

//-(IBAction)FooterViewMorePressed:(id)sender
//{
//    
//    UIButton *buttonClicked = (UIButton *)sender;
//    NSMutableArray *thisGroupOfEvents = [[NSMutableArray alloc]init];
//    thisGroupOfEvents = thisSettings.thisBank.eventsInMonths[buttonClicked.tag];
//    
//    Event *firstEventInSection = thisSettings.thisBank.eventsInMonths[buttonClicked.tag][0];
//    NSInteger monthInteger = [thisSettings.thisBank MonthFromDate: firstEventInSection.eventDate];
//    NSString *thisMonthName = [months objectAtIndex:monthInteger -1];
//
//    NSString *thisMonthString = [months objectAtIndex:monthInteger -1];
//    thisMonthString = [NSString stringWithFormat: @"%@/%ld",thisMonthName,(long)[thisSettings.thisBank YearFromDate:firstEventInSection.eventDate]];
//    [monthRevCont ToShow:thisGroupOfEvents withTitle:thisMonthString];
//    [self.navigationController pushViewController:monthRevCont animated:YES];
//    
//}

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
                                        //get row in events
                                        if (tableView != searchResultsController.tableView) {
                                            
                                            if ([thisSettings.displayMode isEqualToString: @"ByEvent"]) {
                                                NSInteger thisRow = 0;
                                                
                                                for (int i = 0; i < indexPath.section; i ++) {
                                                    thisRow += [tableView numberOfRowsInSection:i];
                                                }
                                                thisRow += indexPath.row;
                                                
                                                [thisSettings.thisBank.events removeObjectAtIndex:thisRow];
                                                [self UpdateBankAndSettings];
                                            }
                                            else if([thisSettings.displayMode isEqualToString:@"ByTag"])
                                            {
                                                [self DeleteEventByTagInMonth:indexPath];
                                                [self UpdateBankAndSettings];
                                            }
                                        }
                                        else
                                        {
                                            NSMutableArray *section = FilteredItemsBySection[indexPath.section];
                                            [self DeleteEvent:[section objectAtIndex:indexPath.row]];
                                            [self UpdateBankAndSettings];
                                            [self updateSearchResultsForSearchController:self.searchController];

                                        }
                                        
                                        
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

-(void)PushEditEventController:(Event *)event{
    [self.navigationController pushViewController:addEventViewCont animated:YES];
    [addEventViewCont EditEventMode:event];
    addEventViewCont.editMode = true;
}
-(NSMutableArray*) DisplayArrayByTagByMonth
{
    NSMutableArray* output = [[NSMutableArray alloc]init];
    
    for (NSMutableArray * monthArray in thisSettings.thisBank.eventsInMonths) {
        NSMutableArray *thisMonth = [[NSMutableArray alloc]init];
        NSMutableArray* tags = [[NSMutableArray alloc]init];
        for (Event* event in monthArray) {
            for (NSString *tag in event.tags) {
                if (![tags containsObject:tag]) {
                    [tags addObject:tag];
                }
            }
        }
        
        for (NSString *tag in tags) {
            NSMutableArray * eventsByTag = [[NSMutableArray alloc]init];
            for (Event* event in monthArray) {
                if ([event.tags containsObject:tag]) {
                    [eventsByTag addObject:event];
                }
            }
            if (eventsByTag.count > 0) {
                [thisMonth addObject:eventsByTag];
            }
        }
        
        NSMutableArray* eventsWithoutTags = [[NSMutableArray alloc]init];
        for (Event *event in monthArray) {
            if (event.tags.count == 0) {
                [eventsWithoutTags addObject:event];
            }
        }
        if (eventsWithoutTags.count != 0) {
            [thisMonth addObject:eventsWithoutTags];

        }
        [output addObject: thisMonth];
    }
    
    return output;
}
-(NSMutableArray*) TitlesByMonthByTag
{
    //un tagged****
    NSMutableArray* output = [[NSMutableArray alloc]init];
    
    for (NSMutableArray * monthArray in thisSettings.thisBank.eventsInMonths) {
        NSMutableArray* tagsInMonth = [[NSMutableArray alloc]init];
        for (Event* event in monthArray) {
            for (NSString *tag in event.tags) {
                if (![tagsInMonth containsObject:tag]) {
                    [tagsInMonth addObject:tag];
                }
            }
        }
        NSMutableArray* eventsWithoutTags = [[NSMutableArray alloc]init];
        for (Event *event in monthArray) {
            if (event.tags.count == 0) {
                [eventsWithoutTags addObject:event];
            }
        }
        if (eventsWithoutTags.count != 0) {
            [tagsInMonth addObject:@"Tagless Entries"];
            
        }
        
        [output addObject: tagsInMonth];
    }
    
    return output;
}

-(NSMutableArray*) ValuesByMonthByTag
{
    NSMutableArray* output = [[NSMutableArray alloc]init];
    
    for (NSMutableArray * monthArray in thisSettings.thisBank.eventsInMonths) {
        NSMutableArray *thisMonth = [[NSMutableArray alloc]init];
        NSMutableArray* tags = [[NSMutableArray alloc]init];
        for (Event* event in monthArray) {
            for (NSString *tag in event.tags) {
                if (![tags containsObject:tag]) {
                    [tags addObject:tag];
                }
            }
        }
        
        for (NSString *tag in tags) {
            float thisTagSum = 0;
            
            for (Event* event in monthArray) {
                if ([event.tags containsObject:tag]) {
                    if (event.eventType == 1) {
                        thisTagSum += event.eventValue;
                    }
                    else
                    {
                        thisTagSum -= event.eventValue;
                    }
                }
            }
            
            [thisMonth addObject:[NSNumber numberWithFloat:thisTagSum]];
        }
        
        float taglessSum = 0;
        for (Event *event in monthArray) {
            if (event.tags.count == 0) {
                if(event.eventType == 1) {
                    taglessSum += event.eventValue;
                }
                else
                {
                    taglessSum -= event.eventValue;
                }
            }
        }
        
        NSMutableArray* eventsWithoutTags = [[NSMutableArray alloc]init];
        for (Event *event in monthArray) {
            if (event.tags.count == 0) {
                [eventsWithoutTags addObject:event];
            }
        }
        if (eventsWithoutTags.count != 0) {
            [thisMonth addObject: [NSNumber numberWithFloat:taglessSum]];
            
        }

        

        [output addObject: thisMonth];
    }
    
    return output;
}
-(void)LoadReviewControllers
{
    nameRevCont = [[NameReviewController alloc]init];
    tagRevCont = [[TagReviewController alloc]init];
    //monthRevCont = [[MonthReviewController alloc]init];
 
    tagRevCont.delegate = self;
    
    nameRevCont.view.backgroundColor = [UIColor whiteColor];
    tagRevCont.view.backgroundColor = [UIColor whiteColor];
    //monthRevCont.view.backgroundColor = Rgb2UIColor(0, 150, 137);
}

-(void)DeleteEvent:(Event *)event
{
    [thisSettings.thisBank.events removeObject:event];
}

-(void)DeleteEventByTagInMonth: (NSIndexPath*) indexPath
{
    NSMutableArray* eventsToDelete = [[[self DisplayArrayByTagByMonth] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    for (Event* event in eventsToDelete) {
        [thisSettings.thisBank.events removeObject:event];
    }
}
//
//-(void)SaveDictionary
//{
//    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
//    [save setObject:productIdIsUnlocked forKey:@"productsPurchased"];
//    [save synchronize];
//
//    [self LoadDictionary];
//}
//
//-(void)LoadDictionary
//{
//    productIdIsUnlocked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"productsPurchased"] mutableCopy];
//
//    if (productIdIsUnlocked == nil) {
//        [self InitDictionary];
//        [self SaveDictionary];
//    }
//
//
//}


//=================================================================================
//                          delegate functions
//=================================================================================

-(void)UpdateFavouriteEventsTable
{
    [secondViewCont.UserPrefEventsCont.tableView reloadData];
}



- (IBAction)WithDrawButtonEnter:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = true;
}

- (IBAction)WithDrawButtonExit:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = false;
}

- (IBAction)RecentsButtonEnter:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = true;
}

- (IBAction)RecentsButtonExit:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = false;
}

- (IBAction)DepositButtonEnter:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = true;
}

- (IBAction)DepositButtonExit:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = false;
}

- (IBAction)FavoritesButtonEnter:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = true;
}

- (IBAction)FavoritesButtonExit:(id)sender forEvent:(UIEvent *)event {
    UIButton *thisButton = sender;
    thisButton.highlighted = false;
}
- (IBAction)TouchDraggedOutsideControl:(id)sender forEvent:(UIEvent *)event {
    
    NSArray *theTouches = [[event allTouches] allObjects];
    
    if([RecentsButton pointInside:[[theTouches objectAtIndex:0] locationInView:RecentsButton] withEvent:event]){
        [self CloseAllExcept:RecentsButton];
        [self OpenRecentSubs];
    }

    
    if([FavoritesButton pointInside:[[theTouches objectAtIndex:0] locationInView:FavoritesButton] withEvent:event]){
        [self CloseAllExcept:FavoritesButton];
        [self OpenFavSubs];
    }
    
}

-(void)OpenRecentSubs
{

    if (RecentsButtonsAreOpen) {
        return;
    }
    
    UIButton* rec1 = RecentsButtons[0];
    UIButton* rec2 = RecentsButtons[1];
    UIButton* rec3 = RecentsButtons[2];
    UIButton* rec4 = RecentsButtons[3];
    
    [UIView beginAnimations:@"openControls" context:NULL];
    
    rec1.frame = CGRectOffset(rec1.frame, 0, -hundredRelativePts*1.3);
    rec2.frame = CGRectOffset(rec2.frame, -hundredRelativePts*1, -hundredRelativePts*1.7);
    rec3.frame = CGRectOffset(rec3.frame, -hundredRelativePts *2, -hundredRelativePts*1.3);
    rec4.frame = CGRectOffset(rec4.frame, -hundredRelativePts*2.2, -hundredRelativePts*0.3);
    
    rec1.titleLabel.textColor = [UIColor whiteColor];
    rec2.titleLabel.textColor = [UIColor whiteColor];
    rec3.titleLabel.textColor = [UIColor whiteColor];
    rec4.titleLabel.textColor = [UIColor whiteColor];
    
    rec1.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    rec2.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    rec3.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    rec4.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    
    [self ShowShadowForButton:rec1];
    [self ShowShadowForButton:rec2];
    [self ShowShadowForButton:rec3];
    [self ShowShadowForButton:rec4];

    [UIView commitAnimations];
    
    RecentsButtonsAreOpen = true;
}

-(void)CloseRecentSubs
{
    if (!RecentsButtonsAreOpen) {
        return;
    }
    
    UIButton* rec1 = RecentsButtons[0];
    UIButton* rec2 = RecentsButtons[1];
    UIButton* rec3 = RecentsButtons[2];
    UIButton* rec4 = RecentsButtons[3];
    
    [UIView beginAnimations:@"openControls" context:NULL];
    
    rec1.frame = CGRectOffset(rec1.frame, 0, hundredRelativePts*1.3);
    rec2.frame = CGRectOffset(rec2.frame, hundredRelativePts*1, hundredRelativePts*1.7);
    rec3.frame = CGRectOffset(rec3.frame, hundredRelativePts *2, hundredRelativePts*1.3);
    rec4.frame = CGRectOffset(rec4.frame, hundredRelativePts*2.2, hundredRelativePts*0.3);

    rec1.titleLabel.textColor = [UIColor clearColor];
    rec2.titleLabel.textColor = [UIColor clearColor];
    rec3.titleLabel.textColor = [UIColor clearColor];
    rec4.titleLabel.textColor = [UIColor clearColor];
    
    rec1.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    rec2.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    rec3.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    rec4.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    
    [self HideShadowForButton:rec1];
    [self HideShadowForButton:rec2];
    [self HideShadowForButton:rec3];
    [self HideShadowForButton:rec4];

    [UIView commitAnimations];
    RecentsButtonsAreOpen = false;
}
-(void)OpenFavSubs
{
    if (FavButtonsAreOpen) {
        return;
    }
    UIButton* fav1 = FavButtons[0];
    UIButton* fav2 = FavButtons[1];
    UIButton* fav3 = FavButtons[2];
    UIButton* fav4 = FavButtons[3];
    
    [UIView beginAnimations:@"openControls" context:NULL];
    
    fav1.frame = CGRectOffset(fav1.frame, hundredRelativePts*0.68, -hundredRelativePts*1.5);
    fav2.frame = CGRectOffset(fav2.frame, -hundredRelativePts*0.35, -hundredRelativePts*1.4);
    fav3.frame = CGRectOffset(fav3.frame, -hundredRelativePts *1.3, -hundredRelativePts*1);
    fav4.frame = CGRectOffset(fav4.frame, -hundredRelativePts*1.5, 0);
    
    fav1.titleLabel.textColor = [UIColor whiteColor];
    fav2.titleLabel.textColor = [UIColor whiteColor];
    fav3.titleLabel.textColor = [UIColor whiteColor];
    fav4.titleLabel.textColor = [UIColor whiteColor];

    fav1.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    fav2.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    fav3.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    fav4.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
    
    [self ShowShadowForButton:fav1];
    [self ShowShadowForButton:fav2];
    [self ShowShadowForButton:fav3];
    [self ShowShadowForButton:fav4];
    
    [UIView commitAnimations];
    
    FavButtonsAreOpen = true;
}
-(void)CloseFavSubs
{
    if (!FavButtonsAreOpen) {
        return;
    }
    UIButton* fav1 = FavButtons[0];
    UIButton* fav2 = FavButtons[1];
    UIButton* fav3 = FavButtons[2];
    UIButton* fav4 = FavButtons[3];
    
    [UIView beginAnimations:@"openControls" context:NULL];
    
    fav1.frame = CGRectOffset(fav1.frame, -hundredRelativePts*0.68, hundredRelativePts*1.5);
    fav2.frame = CGRectOffset(fav2.frame, hundredRelativePts*0.35, hundredRelativePts*1.4);
    fav3.frame = CGRectOffset(fav3.frame, hundredRelativePts *1.3, hundredRelativePts*1);
    fav4.frame = CGRectOffset(fav4.frame, hundredRelativePts*1.5, 0);
    
    fav1.titleLabel.textColor = [UIColor clearColor];
    fav2.titleLabel.textColor = [UIColor clearColor];
    fav3.titleLabel.textColor = [UIColor clearColor];
    fav4.titleLabel.textColor = [UIColor clearColor];
    
    fav1.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    fav2.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    fav3.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    fav4.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
    
    [self HideShadowForButton:fav1];
    [self HideShadowForButton:fav2];
    [self HideShadowForButton:fav3];
    [self HideShadowForButton:fav4];


    [UIView commitAnimations];
    FavButtonsAreOpen = false;
}

-(void)OpenDeposit
{
    if (!DepositButtonIsOpen) {
        DepositButton.frame = CGRectOffset(DepositButton.frame, -hundredRelativePts*1.3, -hundredRelativePts/2);
        DepositButton.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:1];
        DepositButton.titleLabel.textColor = [UIColor whiteColor];

        [self ShowShadowForButton:DepositButton];
        
        DepositButtonIsOpen = true;
    }
    
}
-(void)CloseDeposit
{
    if (DepositButtonIsOpen) {
        DepositButton.frame = CGRectOffset(DepositButton.frame, hundredRelativePts*1.3, hundredRelativePts/2);
        DepositButton.backgroundColor = [DepositButton.backgroundColor colorWithAlphaComponent:0];
        DepositButton.titleLabel.textColor = [UIColor clearColor];
        [self HideShadowForButton:DepositButton];

        DepositButtonIsOpen = false;
    }
    
}
-(void)OpenWithdraw
{
    if (!WithdrawalButtonIsOpen) {
        WithdrawalButton.frame = CGRectOffset(WithdrawalButton.frame, -hundredRelativePts/1.6, -hundredRelativePts*1.5);
        WithdrawalButton.backgroundColor = [WithdrawalButton.backgroundColor colorWithAlphaComponent:1];
        WithdrawalButton.titleLabel.textColor = [UIColor whiteColor];

        [self ShowShadowForButton:WithdrawalButton];
        
        WithdrawalButtonIsOpen = true;
    }
    
}
-(void)CloseWithdraw
{
    if (WithdrawalButtonIsOpen) {
        WithdrawalButton.frame = CGRectOffset(WithdrawalButton.frame, hundredRelativePts/1.6, hundredRelativePts*1.5);
        WithdrawalButton.backgroundColor = [WithdrawalButton.backgroundColor colorWithAlphaComponent:0];
        WithdrawalButton.titleLabel.textColor = [UIColor clearColor];
        [self HideShadowForButton:WithdrawalButton];

        WithdrawalButtonIsOpen = false;
    }
    
}
-(void)OpenRecents
{
    if (!RecentsButtonIsOpen) {
        
        for (UIButton *button in RecentsButtons) {
            button.frame = CGRectOffset(button.frame, hundredRelativePts*1.3,  -hundredRelativePts/2);
        }
        RecentsButton.frame = CGRectOffset(RecentsButton.frame, hundredRelativePts*1.3,  -hundredRelativePts/2);
        RecentsButtonIsOpen = true;
        
                [self ShowShadowForButton:RecentsButton];
        
        RecentsButton.backgroundColor = [RecentsButton.backgroundColor colorWithAlphaComponent:1];
        RecentsButton.titleLabel.textColor = [UIColor whiteColor];

    }
}
-(void)CloseRecents
{
    if (RecentsButtonIsOpen) {
        
        if (RecentsButtonsAreOpen)
        {
            [self CloseRecentSubs];
        }
        
        for (UIButton *button in RecentsButtons) {
            button.frame = CGRectOffset(button.frame, -hundredRelativePts*1.3,  hundredRelativePts/2);
        }
        
        RecentsButton.frame = CGRectOffset(RecentsButton.frame, -hundredRelativePts*1.3,  hundredRelativePts/2);
        RecentsButtonIsOpen = false;
        [self HideShadowForButton:RecentsButton];

        RecentsButton.backgroundColor = [RecentsButton.backgroundColor colorWithAlphaComponent:0];
        RecentsButton.titleLabel.textColor = [UIColor clearColor];

    }
}
-(void)OpenFavs
{
    if (!FavoriteButtonIsOpen) {
        
        for (UIButton *button in FavButtons)
        {
            button.frame = CGRectOffset(button.frame, hundredRelativePts/1.6, -hundredRelativePts*1.5);
        }
        FavoritesButton.frame = CGRectOffset(FavoritesButton.frame, hundredRelativePts/1.6, -hundredRelativePts*1.5);
        FavoriteButtonIsOpen = true;
        
                [self ShowShadowForButton:FavoritesButton];
        
        FavoritesButton.backgroundColor = [FavoritesButton.backgroundColor colorWithAlphaComponent:1];
        FavoritesButton.titleLabel.textColor = [UIColor whiteColor];

    }
}
-(void)CloseFavs
{
    if (FavoriteButtonIsOpen) {
 
        if (FavButtonsAreOpen) {
            [self CloseFavSubs];
        }
        
        for (UIButton *button in FavButtons)
        {
            button.frame = CGRectOffset(button.frame, -hundredRelativePts/1.6, hundredRelativePts*1.5);
        }
        FavoritesButton.frame = CGRectOffset(FavoritesButton.frame, -hundredRelativePts/1.6, hundredRelativePts*1.5);
        FavoriteButtonIsOpen = false;
        
        [self HideShadowForButton:FavoritesButton];
        
        FavoritesButton.backgroundColor = [FavoritesButton.backgroundColor colorWithAlphaComponent:0];
        FavoritesButton.titleLabel.textColor = [UIColor clearColor];

    }
}

-(void)SetSecondViewLink
{
    [self performSegueWithIdentifier:@"FirstToSecondView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FirstToSecondView"]) {
        secondViewCont = [segue destinationViewController];
    }
}

-(void) InitIntroCont
{
    introCont = [[IntroController alloc]init];
    introCont.thisSettings = thisSettings;
    [[UIApplication sharedApplication].keyWindow addSubview: introCont.introMainOverlay];
    [[UIApplication sharedApplication].keyWindow addSubview: introCont.mainLabel];
    
    introCont.introMainOverlay.alpha = 0;
    introCont.mainLabel.alpha = 0;
}

-(void)ShowIntro
{
    [introCont BeginIntro];
}
@end
