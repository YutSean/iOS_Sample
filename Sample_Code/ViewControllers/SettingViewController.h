//
//  SettingViewController.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/18.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileHelper.h"
#import "NewsDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *favorList;


@end

NS_ASSUME_NONNULL_END
