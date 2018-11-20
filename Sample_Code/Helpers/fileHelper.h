//
//  fileHelper.h
//  Sample_Code
//
//  Created by Yutong on 2018/11/18.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface fileHelper : NSObject

+ (void) writeDicToFile: (NSDictionary *)dict filename:(NSString *)filename success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
+ (void) readDicFromFile: (NSString *)filename success:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
+ (void) removeFile: (NSString *)filename success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
+ (void) removeDictFromFile: (NSString *)filename dictKey:(NSString *)key success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
+ (void) writeArrayToFile: (NSArray *)array filename:(NSString *)filename success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
