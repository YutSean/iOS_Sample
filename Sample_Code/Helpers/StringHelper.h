//
//  StringHelper.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/21.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringHelper : NSObject
+ (void) removeSpecialCharacters:(NSString *) str;
+ (void) removeWhiteSpaceAndNewline:(NSString *) str;
@end

NS_ASSUME_NONNULL_END
