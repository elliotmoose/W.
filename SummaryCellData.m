//
//  SummaryCellData.m
//  What's left?
//
//  Created by Swee Har Ng on 8/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import "SummaryCellData.h"

@implementation SummaryCellData

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:self.displayMode forKey:@"displayMode"];
    [coder encodeInt:self.timeFrame forKey:@"timeFrame"];

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.displayMode = [coder decodeIntForKey:@"displayMode"];
        self.timeFrame = [coder decodeIntForKey:@"timeFrame"];

    }
    return self;
}
@end
