//
//  newsSearchController.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/20.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileHelper.h"
#import "NetworkHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface newsSearchController : UISearchController <UISearchBarDelegate>
@property (nonatomic, weak) NetworkHelper *nh;
@end

NS_ASSUME_NONNULL_END
