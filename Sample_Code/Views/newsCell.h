//
//  newsCell.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/14.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsDetailViewController.h"
#import "NetworkHelper.h"
#import "imageHelper.h"
#import "fileHelper.h"
#import "NewsController.h"

NS_ASSUME_NONNULL_BEGIN

@interface newsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *title;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *dateAndAuthor;
@property (strong, nonatomic) NSDictionary *cellInfo;
@property (weak, nonatomic) IBOutlet UITextView *newsContent;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
- (void) makeCell;
- (NSString *) getTextContent:(NSString *) key;

@end

NS_ASSUME_NONNULL_END
