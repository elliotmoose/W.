//
//  WidgetViewController.m
//  What's left?
//
//  Created by Swee Har Ng on 1/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "WidgetViewController.h"
static WidgetViewController *singleton;
@interface WidgetViewController ()

@end

@implementation WidgetViewController
@synthesize screen;
@synthesize hundredRelativePts;
@synthesize headerWidget;
@synthesize allWidgets;

-(id)init
{
    if (singleton == nil) {
        singleton = self;
    }
    self = singleton;
    return singleton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init];
    [self SizingMisc];
    
    allWidgets = [[NSMutableArray alloc]init];
    
    [self InitWidgets];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self UpdateAllWidgets];
}

-(void)viewDidAppear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SizingMisc
{
    screen = [UIScreen mainScreen];
    hundredRelativePts = screen.bounds.size.width/375 * 100;
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    //headerWidget = [[Widget alloc]initWithFrame:CGRectMake(hundredRelativePts*0.1, 0,(screen.bounds.size.width - hundredRelativePts*0.6)/2,(screen.bounds.size.width - hundredRelativePts*0.6)/2 )];
    headerWidget = [[Widget alloc]initWithFrame:CGRectMake(hundredRelativePts*0.1, hundredRelativePts * 0.1,screen.bounds.size.width - hundredRelativePts*0.2,hundredRelativePts*0.9 )];
    headerWidget.tag = 0;
    [self.view addSubview: headerWidget];

}

-(void)InitWidgets{
    
    [allWidgets addObject: headerWidget];
    
    
    CGFloat widgetWidth = (screen.bounds.size.width - hundredRelativePts*0.3)/2;
   
    for (int x = 0; x < 2; x ++) {
        for (int y = 0; y < 2; y ++) {
            
            
        Widget *widget = [[Widget alloc]initWithFrame:CGRectMake(hundredRelativePts*0.1 +(hundredRelativePts*0.1 + widgetWidth)*x, /*head widg h*/hundredRelativePts * 0.9 + hundredRelativePts* 0.25 + (hundredRelativePts*0.1 + widgetWidth)*y, widgetWidth, widgetWidth)];
            
            widget.tag = allWidgets.count;
            
            [self.view addSubview:widget];
            [allWidgets addObject:widget];
            

        }
    }

    for (Widget *widget in allWidgets) {

        [widget setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [widget addTarget:self action:@selector(WidgetPressed:) forControlEvents:UIControlEventTouchUpInside];


    }
}

-(void)UpdateAllWidgets
{
    for (Widget *widget in allWidgets) {
        [widget UpdateDisplay];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(IBAction)WidgetPressed:(id)sender
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
