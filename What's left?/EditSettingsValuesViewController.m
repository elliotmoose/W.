//
//  EditSettingsValuesViewController.m
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "EditSettingsValuesViewController.h"
static EditSettingsValuesViewController *singleton;
@interface EditSettingsValuesViewController ()

@end

@implementation EditSettingsValuesViewController
@synthesize mainTextField;
@synthesize settingInEdit;
@synthesize  thisSettings;
@synthesize moneyManager;
-(instancetype)init
{
    if (singleton == nil) {
        moneyManager = [[MoneyManager alloc]init];
        thisSettings = [[Settings alloc]init];
        self.view.frame = [[UIScreen mainScreen] bounds];
        singleton = self;
    }
    return singleton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mainTextField.delegate = self;
    mainTextField.text = @"$0.00";
    mainTextField.textAlignment = NSTextAlignmentCenter;
    [self addDoneAndCancelBar];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == mainTextField) {
        
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
    [self doneWithNumberPad];
    return NO; // We do not want UITextField to insert line-breaks.
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
    mainTextField.inputAccessoryView = numberToolbar;
 
    
    
}

-(void)doneWithNumberPad
{
    float outputAmount;
    NSArray *components = [[mainTextField.text substringFromIndex:1] componentsSeparatedByString:@","];
    NSString *outputAmtString = [components componentsJoinedByString:@""];
    outputAmount = [outputAmtString floatValue];
    mainTextField.text = @"";
    
    switch (settingInEdit) {
        case PayAmount:
            moneyManager.payAmount = outputAmount;
            break;
        case ExpLimGoal:
            moneyManager.expenditureLimitGoal = outputAmount;
            break;
        case SavingsGoal:
            moneyManager.savingsGoal = outputAmount;
            break;
        default:
            break;
    }
    
    [self.delegate CloseEditSettCon];
    [self.delegate SaveAndUpdateDisolay];
    [mainTextField resignFirstResponder];
    settingInEdit =None;
}

-(void)cancelNumberPad
{
    [mainTextField resignFirstResponder];
    [self.delegate CloseEditSettCon];
    settingInEdit =None;

}
@end
