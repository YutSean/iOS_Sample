//
//  newsSearchController.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/20.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "newsSearchController.h"

@implementation newsSearchController



-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *text = self.searchBar.text;
    if (![text isEqual:@""]) {
        self.nh = [NetworkHelper getInstance];
        [StringHelper removeWhiteSpaceAndNewline:text];
        [StringHelper removeSpecialCharacters:text];
        [self.nh getNewsDataFromNetWithKeyWord:text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.nh = [NetworkHelper getInstance];
    [self.nh getNewsDataFromNet];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}
@end
