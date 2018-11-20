//
//  SettingViewController.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/18.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screen = [UIScreen mainScreen].bounds;
    if (self.tableView == nil) {
        
        self.tableView = [[UITableView alloc] initWithFrame:screen style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    [self addObserver:self forKeyPath:@"favorList" options:NSKeyValueObservingOptionNew context:nil];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove all" style:UIBarButtonItemStylePlain target:self action:@selector(removeAll:)];
    self.navigationItem.title = @"My Favorite news";
    [self.navigationItem  setRightBarButtonItem:rightButton];

    [fileHelper readDicFromFile:@"favorList.txt"
                        success:^(NSDictionary *responseDict) {
                            self.favorList = [NSMutableDictionary dictionaryWithDictionary:responseDict];
                            [self.tableView reloadData];
                            
                        }
                        failure:^(NSError *error) {
                            NSLog(@"%@", error);
                        }];
    [self.view addSubview:self.tableView];
}

- (void) viewWillAppear:(BOOL)animated {
    [fileHelper readDicFromFile:@"favorList.txt"
                        success:^(NSDictionary *responseDict) {
                            self.favorList = [NSMutableDictionary dictionaryWithDictionary:responseDict];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"%@", error);
                        }];
    if ([self.tableView isEditing]) {
        self.tableView.editing = false;
    }
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SettingTableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingTableCell"];
    }
    
    if (self.favorList.count == 0) {
        cell.textLabel.text = @"There is no news in your favourite list.";
        cell.userInteractionEnabled = NO;

    } else {
        
        cell.userInteractionEnabled = YES;
        
        NSArray *array = [self.favorList allKeys];
    
        NSString *cellData = [self.favorList objectForKey:[array objectAtIndex:indexPath.row]];
    
        cell.textLabel.text = cellData;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.favorList.count == 0) {
        return 1;
    }
    return [self.favorList count];
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.favorList.count > 0) {
        
        NewsDetailViewController *nextView = [[NewsDetailViewController alloc]init];
        nextView.newsData = @{ @"url" : [[self.favorList allKeys]objectAtIndex:indexPath.row] };
    
        UINavigationController *navController = [self navigationController];
        [navController pushViewController:nextView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)removeAll: (id) sender {
    [fileHelper removeFile:@"favorList.txt" success:^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                       message:@"All items have been deleted."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [self.navigationController presentViewController:alert animated:NO completion:^{
            self.favorList = [NSMutableDictionary dictionaryWithDictionary:@{}];
        }];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"action = %@", action);
                                                              }];
        [alert addAction:defaultAction];
    }failure: ^(NSError *error){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[error.userInfo valueForKey:@"ErrorMessage"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"action = %@", action);
                                                              }];
        [self.navigationController presentViewController:alert animated:NO completion:^{}];
        [alert addAction:defaultAction];
    }];
}

//  observer function
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath  isEqual: @"favorList"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView reloadInputViews];
        });
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *keys = [self.favorList allKeys];
        [fileHelper removeDictFromFile:@"favorList.txt" dictKey:[keys objectAtIndex:indexPath.row] success:^{
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.favorList removeObjectForKey:[keys objectAtIndex:indexPath.row]];
            [self.tableView reloadData];
        } failure: ^(NSError *error) {
        
    }];
        [self.tableView setEditing:NO animated:YES];
    }
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.favorList.count > 0) {
        return YES;
    }
    return NO;
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
