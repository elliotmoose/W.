//
//  WidgetViewController.h
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Widget.h"
@interface WidgetViewController : UIViewController

@property UIScreen *screen;
@property float hundredRelativePts;

@property Widget *headerWidget;
@property NSMutableArray *allWidgets;

-(void)UpdateAllWidgets;

@end
