//
//  tableHeadController.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/17.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "tableHeadController.h"
#define SUPPORTED_COUNTRIES @"ae ar at au be bg br ca ch cn co cu cz de eg fr gb gr hk hu id ie il in it jp kr lt lv ma mx my ng nl no nz ph pl pt ro rs ru sa se sg si sk th tr tw ua us ve za"

@interface tableHeadController ()

@end

@implementation tableHeadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadPickerData];
//    NSLocale *currentLocale = [NSLocale currentLocale];
//    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
//    [[NetworkHelper getInstance].parmDic setValue:[countryCode lowercaseString] forKey:@"country"];
//    self.countrySelect.titleLabel.text = [currentLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
//
    CGRect screen = [UIScreen mainScreen].bounds;
    
    self.view.frame = CGRectMake(0, 0, screen.size.width, screen.size.height / 8);
    
    [self.newsCategory addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventValueChanged];
    [self.countrySelect addTarget:self action:@selector(selectCountry:) forControlEvents:UIControlEventTouchUpInside];
    
}

//  action of category selection
- (void) selectCategory: (id)sender {
    UISegmentedControl* control = (UISegmentedControl *)sender;
    NSInteger selected = [control selectedSegmentIndex];
    
    [[NetworkHelper getInstance].parmDic setValue:[control titleForSegmentAtIndex:selected] forKey:@"category"];
    [[NetworkHelper getInstance] getNewsDataFromNet];
}

//  action of click country selection button
- (void) selectCountry: (id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [self addPickerView];
    btn.titleLabel.text = [[NetworkHelper getInstance].parmDic valueForKey:@"country"];
}

- (void) addPickerView {
    CGRect screen = [UIScreen mainScreen].bounds;
    if (self.pickerView == nil) {
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,screen.size.height-49, screen.size.width, screen.size.height)];
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
    }
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self showPickerView];
}

- (void)showPickerView{
    
    CGRect screen = [UIScreen mainScreen].bounds;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    _bgView = [[UIView alloc]init];
    _bgView.frame = window.bounds;
    
    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
    [window addSubview:_bgView];
    
    // add toolbar for pickerview
    NSMutableArray *barItems = [NSMutableArray array];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                  initWithTitle:@"\tCancel"
                                          style:UIBarButtonItemStylePlain target:self
                                         action:@selector(toolBarCanelClick)];
    [barItems addObject:cancelBtn];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Confirm\t"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(finishBtnClick)];
    
    [barItems addObject:doneBtn];
    UIToolbar *pickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, screen.size.height / 2 - 60, self.pickerView.frame.size.width, 60)];
    
    [pickerToolBar layoutIfNeeded];
    pickerToolBar.items = barItems;
    
    [self.bgView addSubview:pickerToolBar];//   if direct add the toolbar as the subview of picker view, the touch action will not be detected
    
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.alpha = 0.9;
    [window addSubview:_pickerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self->_pickerView.frame = CGRectMake(0, screen.size.height / 2, screen.size.width, screen.size.height / 2);
    }];
}

- (void) toolBarCanelClick {
    [UIView animateWithDuration:0.3 animations:^(void) {
        NSString *countryCode = [[[NetworkHelper getInstance].parmDic valueForKey:@"country"] uppercaseString];
        NSLocale *local = [NSLocale currentLocale];
        self.countrySelect.titleLabel.text = [local displayNameForKey:NSLocaleCountryCode value:countryCode];
        self.pickerView.frame = CGRectMake(0, self.pickerView.bounds.size.height, self.pickerView.bounds.size.width, self.pickerView.frame.size.height);
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.bgView.frame = CGRectMake(0, self.bgView.bounds.size.height, self.bgView.bounds.size.width, self.pickerView.frame.size.height);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.bgView removeFromSuperview];
                    [self.pickerView removeFromSuperview];
                }
            }];
        }
    }];
}

//  action to confirm selection of picker view
- (void) finishBtnClick {
    NSString *selectedCountry = [[SUPPORTED_COUNTRIES componentsSeparatedByString:@" "] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    
    [[NetworkHelper getInstance].parmDic setValue:selectedCountry forKey:@"country"];
    [[NetworkHelper getInstance] getNewsDataFromNet];
    self.countrySelect.titleLabel.text = [_countryData objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    [self toolBarCanelClick];
}

- (void) loadPickerData {
    
    NSArray *countryCodes = [SUPPORTED_COUNTRIES componentsSeparatedByString:@" "];
    
    NSMutableArray *countryNames = [[NSMutableArray alloc]init];
    NSLocale *local = [NSLocale currentLocale];
    for (NSString *countryCode in countryCodes) {
        NSString *displayNameString = [local displayNameForKey:NSLocaleCountryCode value:countryCode];
        [countryNames addObject:displayNameString];
    }
    _countryData = [countryNames copy];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_countryData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return _countryData[row];
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
