//
//  EditSettingsValuesViewController.h
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
typedef enum
{
    None,
    PayAmount,
    PayDate,
    ExpLimGoal,
    SavingsGoal
}SettinginEdit;
#import <UIKit/UIKit.h>
#import "Settings.h"
@protocol editSettingsValuesDelegate <NSObject>

-(void)CloseEditSettCon;
-(void)SaveAndUpdateDisolay;


@end

@interface EditSettingsValuesViewController :UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *mainTextField;
@property SettinginEdit settingInEdit;
@property (weak,nonatomic) id<editSettingsValuesDelegate> delegate;
@property MoneyManager *moneyManager;
@property Settings *thisSettings;
@end
