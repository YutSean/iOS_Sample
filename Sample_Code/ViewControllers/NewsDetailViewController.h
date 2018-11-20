//
//  NewsDetailViewController.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/15.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NetworkHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailViewController : UIViewController <WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) NSDictionary *newsData;

@property (strong, nonatomic) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
