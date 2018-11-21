//
//  StringHelper.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/21.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper
+ (void) removeSpecialCharacters:(NSString *) str {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    
    str = [str stringByTrimmingCharactersInSet:charSet];
}
+ (void) removeWhiteSpaceAndNewline:(NSString *) str {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    str = [str stringByTrimmingCharactersInSet:charSet];
}
@end
