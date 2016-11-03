//
//  Widget.m
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "Widget.h"

@implementation Widget
@synthesize screen;
@synthesize hundredRelativePts;
@synthesize displayMode;
@synthesize displayValue;
@synthesize thisSettings;
@synthesize displayString;
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self SizingMisc];
    thisSettings = [[Settings alloc]init];
    self.layer.opacity = 1;
    self.backgroundColor = [UIColor whiteColor];
    
    //shadow
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = hundredRelativePts/100;
    self.layer.shadowOffset = CGSizeMake(+.5f,+.5f);
    self.layer.shadowRadius = hundredRelativePts/50;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOpacity = 0.2;
    
    //text
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.titleLabel setFont:[[self.titleLabel font] fontWithSize:self.bounds.size.height]];
    
    
    [self UpdateDisplay];
    
    return self;
    
}


-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
}

-(void)UpdateDisplay
{
    switch (displayMode) {
        case Balance:
            
            displayValue = thisSettings.thisBank.Balance;
            displayString = [NSString stringWithFormat:@"$%.2f",displayValue];

            [self setTitle:displayString forState:UIControlStateNormal];

            
            break;
            
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

