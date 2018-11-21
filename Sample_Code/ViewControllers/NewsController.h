//
//  NewsController.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/13.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "newsCell.h"
#import "NewsDetailViewController.h"
#import "tableHeadController.h"
#import "newsSearchController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableDataArray;
@property (nonatomic, strong) NSArray *newsList;
@property (strong, nonatomic) NetworkHelper *nh;
@property (strong, nonatomic) tableHeadController *header;

@end

NS_ASSUME_NONNULL_END
