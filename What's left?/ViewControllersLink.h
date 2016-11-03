//
//  ViewControllersLink.h
//  What's left?
//
//  Created by Swee Har Ng on 14/7/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol firstViewContDelegate <NSObject>
-(void)UpdateBankDisplay;
-(void)UpdateBank;
-(void)UpdateBankAndSettings;
-(void)ShowIntro;
@end

@protocol secondViewContDelegate <NSObject>

@end
@interface ViewControllersLink : NSObject


@property (weak,nonatomic) id <firstViewContDelegate> delegate;
@property (weak,nonatomic) id <secondViewContDelegate> secondDelegate;

@end
