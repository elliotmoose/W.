//
//  SummaryCell.m
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#import "SummaryCell.h"

@implementation SummaryCell
{
    UIColor *green;
    UIColor *red;
}
@synthesize screen;
@synthesize hundredRelativePts;
@synthesize displayMode;
@synthesize timeFrame;
@synthesize displayValue;
@synthesize displayMaxValue;
@synthesize thisSettings;
@synthesize displayString;
@synthesize progressBar;
@synthesize CellText;
@synthesize type2MainLabel;
@synthesize type2SecLabel;
-(instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil] objectAtIndex:0];
    return self;
}
-(void)initFromLoad
{

    
    if (thisSettings == nil) {
        thisSettings = [[Settings alloc]init];
    }
    
    
}
- (void)awakeFromNib {
    // Initialization code
    [self SizingMisc];
    thisSettings = [[Settings alloc]init];
    displayMode = Spent;
    timeFrame = ThisMonth;
    
    type2MainLabel.adjustsFontSizeToFitWidth = YES;
    
    type2MainLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    type2MainLabel.numberOfLines = 1;
    
    [type2MainLabel setFont:[[type2MainLabel font] fontWithSize:self.bounds.size.height*2/3]];
    //self.backgroundColor = Rgb2UIColor(116, 145, 143);
    self.backgroundColor = UIColorFromRGB(0xF4F3F4);

    //self.backgroundColor = [UIColor whiteColor];
    type2SecLabel.textColor = [UIColor blackColor];
    
    //self.backgroundColor = Rgb2UIColor(177, 222, 189); //lime green
    //self.backgroundColor = Rgb2UIColor(116,145,124); //dirty green

   //green = Rgb2UIColor(177, 222, 189);
    green = UIColorFromRGB(0x00796B);
    //red = UIColorFromRGB(0xFC7B84);
    
    //red = UIColorFromRGB(0x00796B);

    red = green;
    
    
    
    
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    progressBar.clipsToBounds = true;
    progressBar.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SizingMisc
{
    
}

-(void)UpdateDisplay
{
    switch (displayMode) {
        case Balance:
            switch (timeFrame) {
                case ThisMonth:
                    displayValue = [thisSettings.moneyManager CalculateBalance: thisSettings.thisBank.ThisMonthEvents];
                    displayString = @"balance (this Month)";
                    break;
                case ThisPayCycle:
                    
                    break;
                    
                case AllTime:
                    displayValue = thisSettings.thisBank.Balance;
                    displayString = @"balance";
                    break;
                default:
                    break;
            }            
            type2MainLabel.text = [NSString stringWithFormat:@"$%.2f",displayValue];
            type2SecLabel.text = displayString;
            
            if (displayValue < 0) {
                type2MainLabel.textColor = red;
            }
            else
            {
                type2MainLabel.textColor = green;
            }
            
            break;
        case Spent:
        {
            switch (timeFrame) {
                case ThisMonth:
                    displayValue = fabsf([thisSettings.moneyManager CalculateExpenditure:thisSettings.thisBank.ThisMonthEvents]);
                    displayMaxValue = thisSettings.moneyManager.expenditureLimitGoal;
                    CellText.attributedText = [self HalfBoldStringWithValues:displayValue withsecondValue:displayMaxValue withextension:@"spent this month"];
                    break;
                case ThisPayCycle:
                    
                    break;
                    
                case AllTime:
                    displayValue = fabsf([thisSettings.moneyManager CalculateExpenditure:thisSettings.thisBank.events]);
                    displayString = @"spent (all time)";
                    
                    type2MainLabel.text = [NSString stringWithFormat:@"$%.2f",displayValue];
                    type2SecLabel.text = displayString;
                    break;
                case EachDayAverage:
                    displayValue = fabsf([thisSettings.moneyManager SpentEachDayAverage]);
                    displayString = @"spent/day average";
                    
                    type2MainLabel.text = [NSString stringWithFormat:@"$%.2f",displayValue];
                    type2SecLabel.text = displayString;
                    break;
                default:
                    break;
            }

            if (displayMaxValue > displayValue) {
                [progressBar setProgress: (displayValue/displayMaxValue) animated:NO];
            }
            else
            {
                //exceeded
                [progressBar setProgress: (1)];
            }
            

            
            //text
            
            
            break;
        }
        
        case Claimable:
        {
            switch (timeFrame) {
                case ThisMonth:
                    displayValue = [thisSettings.moneyManager CalculateClaimable:thisSettings.thisBank.ThisMonthEvents];
                    displayString = @"to claim(this month)";
                    type2MainLabel.text = [NSString stringWithFormat:@"$%.2f",displayValue];
                    type2SecLabel.text = displayString;
                    break;
                case AllTime:
                    displayValue = [thisSettings.moneyManager CalculateClaimable:thisSettings.thisBank.events];
                    displayString = @"to claim(total)";
                    type2MainLabel.text = [NSString stringWithFormat:@"$%.2f",displayValue];
                    type2SecLabel.text = displayString;
                    break;
                default:
                    break;
            }
            break;
        }
        case LeftToSpend:
            
            switch (timeFrame) {
                case ThisMonth:
                    displayValue = [thisSettings.moneyManager LeftToSpendThisMonth];
                    displayMaxValue = thisSettings.moneyManager.expenditureLimitGoal;
                    CellText.attributedText = [self HalfBoldStringWithValues:displayValue withsecondValue:displayMaxValue withextension:@"left to spend this month"];
                    break;
                case ThisPayCycle:
                    
                    break;
                    
                case AllTime:
                    
                    break;
                default:
                    break;
            }
            
            if (displayMaxValue > displayValue) {
                [progressBar setProgress: (displayValue/displayMaxValue)];
            }
            else
            {
                //exceeded
                [progressBar setProgress: (1)];
            }
            break;
            
            
        case LeftToSpendPerDay:
        {
            displayValue = [thisSettings.moneyManager LeftToSpendEachDayAverage];
            displayString = @"avg left to spend/day";
            type2MainLabel.text = [NSString stringWithFormat:@"$%.2f",displayValue];
            type2SecLabel.text = displayString;
            break;
        }
            
        case DaysToEndOfMonth:
        {
            NSInteger dispVal =[thisSettings.moneyManager DaysLeftInMonth];
            
            displayString = @"days to end of month";
            type2MainLabel.text = [NSString stringWithFormat:@"%d", (int)dispVal];
            type2SecLabel.text = displayString;
            break;
        }
        default:
            break;
    }
}

-(NSMutableAttributedString*)HalfBoldStringWithValues:(float) firstValue withsecondValue: (float) secondValue withextension: (NSString*) extension
{
    
    NSString *firstString = [NSString stringWithFormat:@"$%.2f/",firstValue];
    NSString *secondString = [NSString stringWithFormat:@"$%.2f %@",secondValue,extension];

    NSMutableAttributedString *firstText = [[NSMutableAttributedString alloc] initWithString:firstString];
    [firstText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Black" size:19.0] range:NSMakeRange(0, firstText.length)];
    //            [firstText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, firstText.length)];
    
    NSMutableAttributedString *secondText = [[NSMutableAttributedString alloc] initWithString:secondString];
    [secondText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Medium" size:13.0] range:NSMakeRange(0, secondText.length)];
    
    [firstText appendAttributedString:secondText];
    return firstText;
}

//encoding

@end
