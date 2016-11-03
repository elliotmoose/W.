//
//  EventCell.m
//  What's left?
//
//  Created by Swee Har Ng on 14/6/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell
@synthesize NameDisplay;
@synthesize AmountDisplay;
@synthesize DateDisplay;
@synthesize thisEvent;

@synthesize hundredRelativePts;
@synthesize screen;
@synthesize isViewMore;
- (void)awakeFromNib {
    // Initialization code
    [self SizingMisc];
    [self UpdateCell: @"ByTag"];
}

-(void)UpdateCell: (NSString*) displayMode
{
    if ([displayMode isEqualToString:@"ViewMore"]) {
        [DateDisplay removeFromSuperview];
        [AmountDisplay removeFromSuperview];
        [NameDisplay setText:thisEvent.eventName];
        NameDisplay.frame = CGRectMake(0, 0, screen.bounds.size.width, hundredRelativePts*0.4);
        NameDisplay.textAlignment = NSTextAlignmentCenter;
        return;
    }
    
    AmountDisplay.font = [UIFont boldSystemFontOfSize:17.0];
    DateDisplay.font = [UIFont boldSystemFontOfSize:17.0];
    NameDisplay.font = [UIFont boldSystemFontOfSize:17.0];
    
    if ([displayMode isEqualToString:@"ByEvent"]) {
        if (thisEvent != nil) {
            AmountDisplay.text = [NSString stringWithFormat: @"%.2f",thisEvent.eventValue];
            NameDisplay.text = thisEvent.eventName;
            
            if (thisEvent.eventDate == nil) {
                thisEvent.eventDate = [NSDate date];
            }
            DateDisplay.text = [[thisEvent.eventDate description] substringToIndex:10];
            
            self.textLabel.backgroundColor = [UIColor  clearColor];
            if (thisEvent.eventType == -1) {
                AmountDisplay.textColor = [UIColor colorWithHue:0 saturation:0.86 brightness:0.63 alpha:1];
                NameDisplay.textColor = [UIColor colorWithHue:0 saturation:0.86 brightness:0.63 alpha:1];
            }
            else if(thisEvent.eventType == 1)
            {
                AmountDisplay.textColor = [UIColor colorWithHue:0.3  saturation:0.86 brightness:0.40 alpha:1];
                NameDisplay.textColor = [UIColor colorWithHue:0.3  saturation:0.86 brightness:0.40 alpha:1];
            }
            else if (thisEvent.eventType == 0)
            {
                AmountDisplay.textColor = [UIColor colorWithHue:0.1 saturation:1 brightness:0.65 alpha:1];
                NameDisplay.textColor = [UIColor colorWithHue:0.1 saturation:1 brightness:0.65 alpha:1];
            }
            
        }
        

    }
    
    if ([displayMode isEqualToString:@"ByTag"]) {
        NameDisplay.text = self.tagTitle;
        AmountDisplay.text =[NSString stringWithFormat: @"%.2f",self.tagValue];
        DateDisplay.text = @"";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.tagValue > 0 ) {
            AmountDisplay.textColor = [UIColor colorWithHue:0.3  saturation:0.86 brightness:0.40 alpha:1];
            NameDisplay.textColor = [UIColor colorWithHue:0.3  saturation:0.86 brightness:0.40 alpha:1];
        }
        else
        {
            AmountDisplay.textColor = [UIColor colorWithHue:0 saturation:0.86 brightness:0.63 alpha:1];
            NameDisplay.textColor = [UIColor colorWithHue:0 saturation:0.86 brightness:0.63 alpha:1];
        }
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;

    }

}

-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
    
    NameDisplay.frame = CGRectMake(hundredRelativePts*0.1, self.frame.size.height*0.5 - hundredRelativePts*0.2, hundredRelativePts*1.4, hundredRelativePts*0.4);
    AmountDisplay.frame = CGRectMake(hundredRelativePts*1.5, self.frame.size.height*0.5 - hundredRelativePts*0.2, hundredRelativePts, hundredRelativePts*0.4);
    
    DateDisplay.frame = CGRectMake(screen.bounds.size.width - hundredRelativePts*1.3,  self.frame.size.height*0.5 - hundredRelativePts*0.2, hundredRelativePts*1.2, hundredRelativePts*0.4);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
