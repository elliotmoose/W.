//
//  IntroController.h
//  What's left?
//
//  Created by Swee Har Ng on 22/9/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import <UIKit/UIKit.h>
@interface IntroController : NSObject
@property int introStage;
@property Settings *thisSettings;
@property UIButton *introMainOverlay;
@property UILabel *mainLabel;
@property UIScreen *screen;
@property float hundredRelativePts;

@property UIButton *skipIntroButton;

-(void)BeginIntro;
-(void)IntroTrigger: (int)stage;

@end
