//
//  ExportImportManager.m
//  What's left?
//
//  Created by Swee Har Ng on 25/9/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "ExportImportManager.h"
static ExportImportManager *singleton;
@implementation ExportImportManager

-(id)init
{
    if(singleton == nil)
    {
        singleton = self;
    }
    
    return singleton;
}
@end
