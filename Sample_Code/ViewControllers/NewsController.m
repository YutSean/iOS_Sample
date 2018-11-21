//
//  NewsController.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/13.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "NewsController.h"

@interface NewsController () 

- (void) handleRefresh;
- (void) setHeaderView;

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

    [self setHeaderView];
    [self.nh getNewsDataFromNet];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.title = @"Top hotline news";
    self.definesPresentationContext = YES;
    self.navigationItem.searchController = [[newsSearchController alloc]initWithSearchResultsController:nil];
    self.navigationItem.hidesSearchBarWhenScrolling = YES;
    [self.navigationItem.searchController.searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationItem.searchController.searchBar setPlaceholder:@"News with keywords"];
    self.navigationItem.searchController.searchBar.delegate = self.navigationItem.searchController;
    
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

    self.header = [[tableHeadController alloc] initWithNibName:@"header" bundle:[NSBundle mainBundle]];

    [self.tableView setTableHeaderView:self.header.view];
}


@end
