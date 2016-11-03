//
//  Settings.m
//  What's left?
//
//  Created by Swee Har Ng on 23/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "Settings.h"
static Settings *mainSettings;

@implementation Settings
@synthesize thisBank;
@synthesize ShowByTagGroups;

@synthesize favEvents;
@synthesize recEvents;
@synthesize favTags;
@synthesize recTags;
@synthesize hasDoneIntro;
@synthesize lastBackupDate;
@synthesize moneyManager;
-(id)init
{

    if (mainSettings == nil) {
        favEvents = [[NSMutableArray alloc]init];
        recEvents = [[NSMutableArray alloc]init];
        favTags = [[NSMutableArray alloc]init];
        recTags = [[NSMutableArray alloc]init];
        mainSettings = self;
        moneyManager = [[MoneyManager alloc]init];
        thisBank = [Bank Singleton];
    }

    return mainSettings;
}

-(void)initFromLoad
{
    if (favTags == nil) {
        favTags = [[NSMutableArray alloc]init];
    }
    
    if (recTags == nil) {
        recTags = [[NSMutableArray alloc]init];
    }
    if (favEvents == nil) {
        favEvents = [[NSMutableArray alloc]init];
    }
    
    if (recEvents == nil) {
        recEvents = [[NSMutableArray alloc]init];
    }
    if (favEvents.count == 0 ) {
        for (int x = 0; x <4; x++) {
            Event* newEvent = [[Event alloc]init];
            newEvent.eventName = [NSString stringWithFormat:@"Fav %ld",(long)x];
            [favEvents addObject:newEvent];
        }
        
        [self SaveFavorites];
    }
    if (recEvents.count == 0) {
        for (int x = 0; x <4; x++) {
            Event* newEventTwo = [[Event alloc]init];
            newEventTwo.eventName = [NSString stringWithFormat:@"Rec %ld",(long)x];
            [recEvents addObject:newEventTwo];
        }
        
        [self SaveRecents];
    }
    if ([self.displayMode isEqualToString: @""] || self
        .displayMode == nil) {
        self.displayMode = @"ByTag";
        [self SaveMisc];
    }
}

-(void)SaveSettings
{
    [self SaveBank];
    [self SaveFavorites];
    [self SaveRecents];
    [self SaveTags];
    [self SaveMisc];
}

-(void)LoadSettings
{
    [self LoadFavorites];
    [self LoadRecents];
    [self LoadTags];
    [self LoadMisc];
    [self initFromLoad];
    


}

-(void)LoadBankInitial
{
    //load
    NSData *archivedBank = [[NSData alloc]init];
    archivedBank = [[NSUserDefaults standardUserDefaults]objectForKey:@"mainBank"];
    Bank* tempBank;
    if (archivedBank != nil) {
        thisBank = [NSKeyedUnarchiver unarchiveObjectWithData:archivedBank];
        
    }
    
    if (tempBank== nil) {
        tempBank = [[Bank alloc] init];
        
        [self SaveBank];
    }
    
    [self SetBank:thisBank];
    
    
}
-(void)SetBank:(Bank*) thisBankToSet
{
    thisBank = [Bank Singleton];
    thisBank.events = thisBankToSet.events;
    thisBank.eventsInMonths = thisBankToSet.eventsInMonths;
    [thisBank initFromLoad];
    
}
-(void)SaveBank
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    NSData *archivedBank = [[NSData alloc]init];
    Bank *tempBank = [Bank Singleton];
    archivedBank = [NSKeyedArchiver archivedDataWithRootObject:tempBank];
    
    
    [save setObject:archivedBank forKey:@"mainBank"];
    [save synchronize];
}

-(void)ResetBank
{
    id obj1 = [[NSUserDefaults standardUserDefaults] objectForKey: @"Backup"];
    id obj2 = [[NSUserDefaults standardUserDefaults] objectForKey: @"lastBackupDate"];

    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    thisBank = [[Bank alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:obj1 forKey:@"Backup"];
    [[NSUserDefaults standardUserDefaults] setObject:obj2 forKey:@"lastBackupDate"];

    [self SaveBank];
}

-(void)SaveBackup
{
    //saving bank backup
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    NSData *archivedBank = [[NSData alloc]init];
    archivedBank = [NSKeyedArchiver archivedDataWithRootObject:thisBank];
    
    
    [save setObject:archivedBank forKey:@"Backup"];
    [save synchronize];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
    NSDate *dte = [NSDate date];
    
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    lastBackupDate = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:dte]];
    [save setObject: lastBackupDate forKey:@"lastBackupDate"];
    //saving tags backup
}

-(void)LoadBackup
{
    NSData *archivedBank = [[NSData alloc]init];
    archivedBank = [[NSUserDefaults standardUserDefaults]objectForKey:@"Backup"];
    if (archivedBank != nil) {
        thisBank = [[Bank alloc]init];
        thisBank = [NSKeyedUnarchiver unarchiveObjectWithData:archivedBank];
        
        
    }
    
    if (thisBank == nil) {
        thisBank = [Bank Singleton];
        
        [self SaveBank];
    }

}

-(void)SaveMisc
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    [save setObject:self.displayMode forKey:@"displayMode"];
    [save setFloat:moneyManager.payAmount forKey:@"payAmount"];
    [save setObject:moneyManager.payDate forKey:@"payDate"];
    [save setFloat:moneyManager.savingsGoal forKey:@"savingsGoal"];
    [save setObject:moneyManager.lastExpGoalSetDate forKey:@"lastExpGoalSetDate"];
    [save setFloat:moneyManager.expenditureLimitGoal forKey:@"expenditureLimitGoal"];
    [save setObject:moneyManager.lastSavingsGoalSetDate forKey:@"lastSavingsGoalSetDate"];
    [save synchronize];
}
-(void)LoadMisc
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];

    self.displayMode = [save objectForKey:@"displayMode"];
    self.hasDoneIntro = [save boolForKey:@"hasDoneIntro"];

    lastBackupDate = [save objectForKey:@"lastBackupDate"];
    if ([lastBackupDate isEqualToString: @"" ] || lastBackupDate == nil) {
        lastBackupDate = @"Not Backedup yet";
    }
    
    moneyManager.payAmount = [save floatForKey:@"payAmount"];
    moneyManager.payDate = [save objectForKey:@"payDate"];
    moneyManager.savingsGoal = [save floatForKey:@"savingsGoal"];
    moneyManager.lastSavingsGoalSetDate =[save objectForKey: @"lastSavingsGoalSetDate" ];
    moneyManager.expenditureLimitGoal =[save  floatForKey:@"expenditureLimitGoal"];
    moneyManager.lastExpGoalSetDate = [save objectForKey:@"lastExpGoalSetDate"];
}

-(void)SaveDoneIntro
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    [save setBool:hasDoneIntro forKey:@"hasDoneIntro"];
}

-(void)SaveTags
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    [save setObject:favTags forKey:@"favTags"];
    [save setObject:recTags forKey:@"recTags"];
    [save synchronize];
}

-(void)LoadTags
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    favTags = [[save objectForKey:@"favTags"] mutableCopy];
    recTags = [[save objectForKey:@"recTags"] mutableCopy];
}

-(void)SaveFavorites
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    NSData *archivedEvents = [[NSData alloc]init];
    archivedEvents = [NSKeyedArchiver archivedDataWithRootObject:favEvents];
    [save setObject:archivedEvents forKey:@"mainFavorites"];
    [save synchronize];
}

-(void)LoadFavorites
{
    NSData *archivedEvents = [[NSData alloc]init];
    archivedEvents = [[NSUserDefaults standardUserDefaults]objectForKey:@"mainFavorites"];
    if (archivedEvents != nil) {
        favEvents = [[NSMutableArray alloc]init];
        favEvents = [NSKeyedUnarchiver unarchiveObjectWithData:archivedEvents];
        
    }
}
-(void)SaveRecents
{
    NSUserDefaults *save = [NSUserDefaults standardUserDefaults];
    NSData *archivedEvents = [[NSData alloc]init];
    archivedEvents = [NSKeyedArchiver archivedDataWithRootObject:recEvents];
    [save setObject:archivedEvents forKey:@"mainRecents"];
    [save synchronize];
}
-(void)LoadRecents
{
    NSData *archivedEvents = [[NSData alloc]init];
    archivedEvents = [[NSUserDefaults standardUserDefaults]objectForKey:@"mainRecents"];
    if (archivedEvents != nil) {
        recEvents = [[NSMutableArray alloc]init];
        recEvents = [NSKeyedUnarchiver unarchiveObjectWithData:archivedEvents];
        
    }
}


-(void)AddFavEvent: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags
{
    Event *event = [[Event alloc]init];
    event.eventName = Name;
    event.eventType = eventType;
    event.tags = tags;
    
    if (eventType != 0) {
        event.eventValue = Value;
    }
    else
    {
        event.eventValue = Value;
        
    }
    event.eventDate = Date;
   
    
    [favEvents insertObject: event atIndex:0];
    for(int i = 0 ;favEvents.count > 4; i ++) {
        [favEvents removeLastObject];
    }
    
    [self SaveFavorites];
}
-(void)AddRecEvent: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags
{
    Event *event = [[Event alloc]init];
    event.eventName = Name;
    event.eventType = eventType;
    event.tags = tags;
    
    if (eventType != 0) {
        event.eventValue = Value;
    }
    else
    {
        event.eventValue = Value;
        
    }
    event.eventDate = [NSDate date];
    [recEvents insertObject: event atIndex:0];
    for(int i = 0 ;recEvents.count > 4; i ++) {
        [recEvents removeLastObject];
    }
    [self SaveRecents];
}

-(void)EditFavEvent:(Event *)event withName:(NSString *)Name withAmount:(float)Value withDate:(NSDate *)Date witheventType:(float)eventType withTags:(NSMutableArray *)tags
{
    event.eventName = Name;
    event.eventType = eventType;
    if (eventType != 0) {
        event.eventValue = Value;
    }
    else
    {
        event.eventValue = Value;
        
    }    event.eventDate = Date;
    event.tags = tags;
}
@end
