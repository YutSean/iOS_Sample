//
//  tableHeadController.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/17.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface tableHeadController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *newsCategory;
@property (weak, nonatomic) IBOutlet UIStackView *baseStack;
@property (weak, nonatomic) IBOutlet UIStackView *secondStack;
@property (weak, nonatomic) IBOutlet UIButton *countrySelect;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) NSArray *countryData;

@end

NS_ASSUME_NONNULL_END
