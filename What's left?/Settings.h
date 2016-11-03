//
//  Settings.h
//  What's left?
//
//  Created by Swee Har Ng on 23/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bank.h"
#import "MoneyManager.h"
@protocol SettingsDelegate<NSObject>

@end
@interface Settings : NSObject

@property NSMutableArray *favEvents;
@property NSMutableArray *recEvents;
@property NSMutableArray *favTags;
@property NSMutableArray *recTags;
@property Bank *thisBank;

@property BOOL ShowByTagGroups;
//methods
-(void)LoadTags;
-(void)SaveTags;
-(void)LoadSettings;
-(void)SaveSettings;
-(void)LoadBankInitial;
-(void)SaveBank;
-(void)SaveMisc;
-(void)LoadMisc;
-(void)ResetBank;
-(void)SaveBackup;
-(void)LoadBackup;
-(void)SaveDoneIntro;
-(void)AddFavEvent: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags;
-(void)AddRecEvent: (NSString*)Name withAmount : (float)Value withDate : (NSDate*) Date witheventType : (float) eventType withTags: (NSMutableArray*) tags;
-(void)EditFavEvent:(Event *)event withName:(NSString *)Name withAmount:(float)Value withDate:(NSDate *)Date witheventType:(float)eventType withTags:(NSMutableArray *)tags;
@property (weak,nonatomic) id<SettingsDelegate> Delegate;
@property MoneyManager *moneyManager;
@property NSString* displayMode;
@property BOOL hasDoneIntro;
@property NSString *lastBackupDate;


@end
