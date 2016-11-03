//
//  IntroController.m
//  What's left?
//
//  Created by Swee Har Ng on 22/9/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#import "IntroController.h"
static IntroController *singleton;
@implementation IntroController
@synthesize screen;
@synthesize hundredRelativePts;
@synthesize mainLabel;
@synthesize introMainOverlay;
@synthesize introStage;
@synthesize thisSettings;
@synthesize skipIntroButton;
-(id)init
{

    if(singleton == nil)
    {
        [self SizingMisc];

        

        introMainOverlay = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, screen.bounds.size.width, screen.bounds.size.height)];
        
        [introMainOverlay addTarget:self action:@selector(IntroButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *touchToContinue = [[UILabel alloc]initWithFrame:CGRectMake(screen.bounds.size.width/2 - hundredRelativePts, screen.bounds.size.height - hundredRelativePts * 0.3, hundredRelativePts*2, hundredRelativePts*0.2)];
        touchToContinue.text = @"Touch Screen To Continue";
        touchToContinue.textAlignment = NSTextAlignmentCenter;
        touchToContinue.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15.0];
        

        
        mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen.bounds.size.width/2 - hundredRelativePts*1.3, hundredRelativePts * 2.5, hundredRelativePts*2.6, hundredRelativePts*0.6)];


        skipIntroButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, screen.bounds.size.width -10, hundredRelativePts*0.3)];
        
        skipIntroButton.backgroundColor = Rgb2UIColor(0, 150, 137);
        
        [skipIntroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        skipIntroButton.alpha = 1;
        
        [skipIntroButton setTitle:@"Skip" forState:UIControlStateNormal];
        
        [skipIntroButton addTarget:self action:@selector(SkipIntro) forControlEvents:UIControlEventTouchUpInside];

        
        [introMainOverlay addSubview:skipIntroButton];
        //
//        for (NSString* family in [UIFont familyNames])
//        {
//            NSLog(@"%@", family);
//            
//            for (NSString* name in [UIFont fontNamesForFamilyName: family])
//            {
//                NSLog(@"  %@", name);
//            }
//        }
        
        touchToContinue.textColor = [UIColor whiteColor];
        [introMainOverlay addSubview: touchToContinue];
        if (!thisSettings.hasDoneIntro) {
            introMainOverlay.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.65];
        }
        else
        {
            introMainOverlay.backgroundColor = [UIColor clearColor];
            introMainOverlay.enabled = false;
        }
        
        singleton = self;

    }
    
    
    
    return singleton;
}

-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;

}

-(IBAction)IntroButtonPressed:(id)sender
{
    introStage ++;
    [self LoadStage];
    
}

-(void)SkipIntro
{
    introStage = 8;
    [self LoadStage];
}



-(void)BeginIntro
{

    mainLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:35.0];
    mainLabel.numberOfLines = 2;
    mainLabel.adjustsFontSizeToFitWidth = YES;
    mainLabel.text = @"Welcome";
    mainLabel.textColor = [UIColor whiteColor];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.alpha = 0;
    introMainOverlay.alpha = 1;

    thisSettings.hasDoneIntro = false;
    introStage = 1;

    [self LoadStage];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:nil];
//    });
    
    
}

-(void)LoadStage
{
    switch (introStage) {
        case 1:
        {
            [UIView animateWithDuration:1 animations:^{mainLabel.alpha = 1;}];
            break;
        }
        
            
        case 2:
        {
            
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:nil];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{introMainOverlay.alpha = 0;} completion:^(BOOL finished)
             {
                 introStage = 2;
                 mainLabel.textColor = Rgb2UIColor(0, 150, 137);

                 mainLabel.text = @"This is your summary view. \n Press \"+\" to create a new summary";
                 
                 [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 1;} completion: nil];
             }];

            break;
        }
            
        case 3:
        {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:nil];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{introMainOverlay.alpha = 1;} completion:^(BOOL finished)
             {
                 introStage = 3;
                 mainLabel.textColor = [UIColor whiteColor];
                 mainLabel.text = @"Tap a summary to edit its settings \n swipe left to delete it";
                 
                 [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 1;} completion: nil];
             }];
            break;
        }

            
        case 4:
        {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:nil];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{introMainOverlay.alpha = 0;} completion:^(BOOL finished)
             {
                 introStage = 4;
                 mainLabel.textColor = Rgb2UIColor(0, 150, 137);

                 mainLabel.text = @"Tap the wallet icon at the bottom left to the List View";
                 
                 [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 1;} completion: nil];

             }];
            break;
        }

            
        case 5:
        {
             
             [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:^(BOOL finished)
              {
                  introStage = 5;
                  mainLabel.numberOfLines = 4;
                  [mainLabel setFrame:CGRectMake(0, hundredRelativePts * 3, screen.bounds.size.width, hundredRelativePts*0.8)];
                  
                  
                  
                  mainLabel.text = @"This is your List View. \n To Add a new entry, press and hold the semi circle. Slide over \"In\" and release";
                  [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 1;} completion: nil];

              }];
            break;
        }

        case 6:
        {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:nil];
            break;
        }
        case 7:
        {
            
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:nil];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{introMainOverlay.alpha = 1;} completion:^(BOOL finished)
             {
                 introStage = 7;
                 mainLabel.textColor = [UIColor whiteColor];
                 mainLabel.numberOfLines = 8;
                 [mainLabel setFrame:CGRectMake(0, hundredRelativePts * 1, screen.bounds.size.width, hundredRelativePts*4)];
                 
                 mainLabel.text = @"That's it! Things to note: \n -Delete entries by swiping left \n -\"S:\" stands for Spent \n -\"B:\" stands for Balance \n- Set Favorites in Settings \n- Set budget in Settings";
                 [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 1;} completion: nil];
                 
             }];
            break;
        }
        case 8:
        {
                //finished intro
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 0;} completion: nil];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{introMainOverlay.alpha = 0;} completion: nil];
            [mainLabel setFrame:CGRectMake(screen.bounds.size.width/2 - hundredRelativePts*1.3, hundredRelativePts * 2.5, hundredRelativePts*2.6, hundredRelativePts*0.6)];
            thisSettings.hasDoneIntro = true;
            [thisSettings SaveDoneIntro];

        }
//        case 15:
//        {
//            
//            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{mainLabel.alpha = 0;} completion:^(BOOL finished)
//             {
//                 introStage = 15;
//              
//
//                 
//                 mainLabel.numberOfLines = 1;
//                 
//                 
//                 mainLabel.text = @"Select \"In\" to make a deposit";
//                 [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{mainLabel.alpha = 1;} completion: nil];
//                 
//             }];
//            break;
//        }
        default:
            break;
    }
}


-(void)IntroTrigger: (int)stage
{
    if (introStage == stage) {
        introStage ++;
        [self LoadStage];
    }
}
@end
