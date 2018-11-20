//
//  nTableViewCell.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/14.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "newsCell.h"

@implementation newsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.frame = CGRectMake(0, 0, screen.size.width, screen.size.width * 0.618);
//    _titleStack.frame = CGRectMake(0, 0, screen.size.width, self.frame.size.height);
//    _imageSteck.frame = CGRectMake(0, 0, screen.size.width, self.frame.size.height *0.66);
//    _textStack.frame = CGRectMake(0, 0, screen.size.width * 0.5, self.frame.size.height *0.66);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//  make the appearance of a single newscell
- (void) makeCell {
    self.dateAndAuthor.numberOfLines = 0;
    self.title.text = [self getTextContent:@"title"];
    self.title.userInteractionEnabled = NO;
    
//    [self.titleStack addArrangedSubview:self.title];
//    [self.titleStack addArrangedSubview:self.imageSteck];
//    [self.imageSteck addArrangedSubview:self.textStack];
    
    NSString *temp = [NSString stringWithFormat:@"   %@,\n   %@",[self getTextContent:@"publishedAt"], [self getTextContent:@"author"]];
    self.dateAndAuthor.text = temp;
    self.dateAndAuthor.adjustsFontSizeToFitWidth = YES;
    self.newsContent.text = [self getTextContent:@"description"];
    if ([self.newsContent.text  isEqual: @""]) {
        self.newsContent.text = @"No description for this news.";
    }
//    self.newsContent.userInteractionEnabled = NO;
    self.newsContent.scrollEnabled = YES;
    
//    [self.textStack addArrangedSubview:self.newsContent];
//    [self.textStack addArrangedSubview:self.dateAndAuthor];
//    self.newsImage.frame = CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height *0.66);
//    [self.imageSteck addArrangedSubview:self.newsImage];

    NSString *imageUrl = [self getTextContent:@"urlToImage"];
    //[self.newsImage setFrame:CGRectMake(0, 0, thisCell.size.width / 2, thisCell.size.height / 2)];
//    [self.newsImage.heightAnchor constraintEqualToConstant:100].active = true;
//    [self.title.heightAnchor constraintEqualToConstant:100].active = true;
    [self.newsImage setImage: [UIImage imageNamed:@"News_icon"]];
    if (![imageUrl isEqual:@""]) {
        NetworkHelper *helper = [NetworkHelper getInstance];
        [helper getImageData:imageUrl success:^(NSData *imageData){
            UIImage *tp = [UIImage imageWithData:imageData];
            tp = [imageHelper cropSquareImage:tp];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.newsImage setImage:tp];
            });
        } failure:^(NSError *errors){
            
        }];
    }
    
    [self.favorBtn addTarget:self action:@selector(storeNews:) forControlEvents:(UIControlEventTouchUpInside)];
}

//  do the NSNull check after get text object from dictionary
- (NSString *) getTextContent:(NSString *) key {
    NSString *value = [self.cellInfo valueForKey:key];
    if ([value class] == [NSNull class]) {
        return @"";
    }
    return value;
}

- (void) storeNews: (id) sender {
    
    [fileHelper writeDicToFile:self.cellInfo filename:@"favorList.txt" success:^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                       message:@"The new has added to your favor list."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"action = %@", action);
                                                              }];
        [alert addAction:defaultAction];
        NewsController *view = [self getViewController];
        if (view) {
            [view.navigationController presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[error.userInfo valueForKey:@"ErrorMessage"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"action = %@", action);
                                                              }];
        [alert addAction:defaultAction];
        NewsController *view = [self getViewController];
        if (view) {
            [view.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (NewsController *)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (NewsController *)nextResponder;
        }
    }
    return nil;
}




@end
