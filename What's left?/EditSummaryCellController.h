//
//  EditSummaryCellController.h
//  What's left?
//
//  Created by Swee Har Ng on 3/10/16.
//  Copyright © 2016 Kohbroco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryCellData.h"
#import "IntroController.h"
#import "Settings.h"
@protocol cellEdtContDelegate <NSObject>

-(void)ReplaceCell: (SummaryCellData*) newCellData withreplacementIndex: (int) replacementIndex;

@end
@interface EditSummaryCellController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *cellModePicker;

@property SummaryCellData *cellDataInEdit;
@property int indexOfCellInEdit;
@property id<cellEdtContDelegate> delegate;
@property Settings *thisSettings;

@end
