//
//  ViewControllersLink.m
//  What's left?
//
//  Created by Swee Har Ng on 14/7/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "ViewControllersLink.h"
static ViewControllersLink *singleton;
@implementation ViewControllersLink
-(id)init
{
    if (singleton == nil) {
        singleton = [ViewControllersLink alloc];
    }
    
    return singleton;
}
@end
