//
//  NewsController.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/13.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "NewsController.h"
#define SUPPORTED_COUNTRIES @"ae ar at au be bg br ca ch cn co cu cz de eg fr gb gr hk hu id ie il in it jp kr lt lv ma mx my ng nl no nz ph pl pt ro rs ru sa se sg si sk th tr tw ua us ve za"

@interface NewsController () {
    NSArray *countryData;
}

- (void) addPickerView;
- (void) handleRefresh;
- (void) setHeaderView;
- (void) selectCategory: (id) sender;
- (void) loadPickerData;

@end

@implementation NewsController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  initialize the data of tableview
    self.nh = [NetworkHelper getInstance];
    self.tableDataArray = [[NSMutableArray alloc] init];
    
    
    [self.nh.parmDic setValue:@"5" forKey:@"pageSize"];
    [self.nh addObserver:self forKeyPath:@"newsData" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    CGRect r = [[ UIScreen mainScreen ] bounds];
    [self.tableView setFrame:CGRectMake(0, 40, r.size.width, r.size.height)];
    //  register newscell
    UINib *nib = [UINib nibWithNibName:@"newsCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"newsCell"];
    [self loadPickerData];
    [self setHeaderView];
    [self.nh getNewsDataFromNet];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = [UIScreen mainScreen].bounds.size.height / 3.0;
    
    self.navigationItem.title = @"Top hotline news";
    self.definesPresentationContext = YES;
    self.navigationItem.searchController = [[newsSearchController alloc]initWithSearchResultsController:nil];
    self.navigationItem.hidesSearchBarWhenScrolling = YES;
    [self.navigationItem.searchController.searchBar setShowsCancelButton:NO animated:YES];
    self.navigationItem.searchController.searchBar.delegate = self.navigationItem.searchController;
    
//    self.navigationItem.searchController = [[UISearchController alloc]initWithSearchResultsController:self];
//    self.navigationItem.searchController.searchResultsUpdater = self;
//    self.navigationItem.searchController.delegate = self;
//    self.navigationItem.searchController.searchBar.delegate = self;
//    self.navigationItem.searchController.hidesNavigationBarDuringPresentation = YES;
//    self.navigationItem.titleView = self.navigationItem.searchController.searchBar;
//    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 60, 300)];
//    self.navigationItem.titleView = searchBar;
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"loading..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor grayColor]}];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    newsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    if (cell == nil) {
        cell = [[newsCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"newsCell"];
    }
    
    cell.cellInfo = [self.tableDataArray objectAtIndex:indexPath.row];
    [cell makeCell];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataArray count];
}

//  Observer function for data from network
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.nh && [keyPath  isEqual: @"newsData"]) {
        [self.tableDataArray removeAllObjects];
        [self.tableDataArray addObjectsFromArray:[self.nh.newsData valueForKey:@"articles"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.refreshControl endRefreshing];
            [self.tableView reloadData];
        }); 
    }
}

//  height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.width *0.6;
}

//  when a cell is selected load the original webpage in a new webview
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsDetailViewController *nextView = [[NewsDetailViewController alloc]init];
    nextView.newsData = [self.tableDataArray objectAtIndex:indexPath.row];
    
    UINavigationController *navController = [self navigationController];
    [navController pushViewController:nextView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//  pull down table view to get new data from web
- (void) handleRefresh {
    NSString *currentPage = [self.nh.parmDic valueForKey:@"pageSize"];
    NSString *refreshPage = nil;
    if (![currentPage  isEqual: @""]) {
        int temp = [currentPage intValue];
        if (temp < 100) {
            refreshPage = [NSString stringWithFormat:@"%d", [currentPage intValue] + 5];
        }
    } else {
        refreshPage = @"5";
    }
    [self.nh.parmDic setObject:refreshPage forKey:@"pageSize"];
    [self.nh getNewsDataFromNet];
}

//  Code for header of tableview
- (void) setHeaderView {
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    [self.nh.parmDic setValue:[countryCode lowercaseString] forKey:@"country"];
    
    CGRect screen = [UIScreen mainScreen].bounds;
    
    self.header = [[tableHeadController alloc] initWithNibName:@"header" bundle:nil];

    self.header.view.frame = CGRectMake(0, 0, screen.size.width, screen.size.height / 8);
    
    [self.header.newsCategory addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventValueChanged];
    [self.header.countrySelect addTarget:self action:@selector(selectCountry:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTableHeaderView:self.header.view];
}

//  action of category selection
- (void) selectCategory: (id)sender {
    UISegmentedControl* control = (UISegmentedControl *)sender;
    NSInteger selected = [control selectedSegmentIndex];
    
    [self.nh.parmDic setValue:[control titleForSegmentAtIndex:selected] forKey:@"category"];
    [self.nh getNewsDataFromNet];
}

//  action of click country selection button
- (void) selectCountry: (id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [self addPickerView];
    btn.titleLabel.text = [self.nh.parmDic valueForKey:@"country"];
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

- (void) loadPickerData {
//    NSString *supportedCountries = @"ae ar at au be bg br ca ch cn co cu cz de eg fr gb gr hk hu id ie il in it jp kr lt lv ma mx my ng nl no nz ph pl pt ro rs ru sa se sg si sk th tr tw ua us ve za";
    NSArray *countryCodes = [SUPPORTED_COUNTRIES componentsSeparatedByString:@" "];
    
    NSMutableArray *countryNames = [[NSMutableArray alloc]init];
    NSLocale *local = [NSLocale currentLocale];
    for (NSString *countryCode in countryCodes) {
        NSString *displayNameString = [local displayNameForKey:NSLocaleCountryCode value:countryCode];
        [countryNames addObject:displayNameString];
    }
    countryData = [countryNames copy];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView { 
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { 
    return [countryData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return countryData[row];
}

//  show pickerview with animation
- (void)showPickerView{
    
    CGRect screen = [UIScreen mainScreen].bounds;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    _bgView = [[UIView alloc]init];
    _bgView.frame = window.bounds;

    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];

    [window addSubview:_bgView];
    
    // add toolbar for pickerview
    NSMutableArray *barItems = [NSMutableArray array];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"\tCancel" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarCanelClick)];
    [barItems addObject:cancelBtn];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Confirm\t" style:UIBarButtonItemStylePlain target:self action:@selector(finishBtnClick)];
    
    [barItems addObject:doneBtn];
    UIToolbar *pickerToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, screen.size.height / 2 - 60, self.pickerView.frame.size.width, 60)];
    
    [pickerToolBar layoutIfNeeded];
    pickerToolBar.items = barItems;
    
    [self.bgView addSubview:pickerToolBar];

    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.alpha = 0.9;
    [window addSubview:_pickerView];

    [UIView animateWithDuration:0.3 animations:^{
        self->_pickerView.frame = CGRectMake(0, screen.size.height / 2, screen.size.width, screen.size.height / 2);
    }];
}

- (void) toolBarCanelClick {
    [UIView animateWithDuration:0.3 animations:^(void) {
        
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

- (void) finishBtnClick {
    NSString *selectedCountry = [[SUPPORTED_COUNTRIES componentsSeparatedByString:@" "] objectAtIndex:[self.pickerView selectedRowInComponent:0]];

    [self.nh.parmDic setValue:selectedCountry forKey:@"country"];
    [self.nh getNewsDataFromNet];
    self.header.countrySelect.titleLabel.text = [countryData objectAtIndex:[self.pickerView selectedRowInComponent:0]];
//    for (UIView *next = self.tableView.tableHeaderView; next; next = next.superview) {
//        UIResponder *nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[tableHeadController class]]) {
//            tableHeadController *header = (tableHeadController *)nextResponder;
//            header.countrySelect.titleLabel.text =[self.nh.parmDic valueForKey:@"country"];
//            break;
//        }
//    }
    [self toolBarCanelClick];
}



@end
