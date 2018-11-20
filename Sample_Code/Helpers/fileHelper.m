//
//  fileHelper.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/18.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "fileHelper.h"
#define MAX_FAVOR_COUNT 20

@implementation fileHelper

+ (void) writeDicToFile: (NSDictionary *)dict filename:(NSString *)filename success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileDicPath]) {
        NSDictionary *fileDict = @{[dict valueForKey:@"url"] : [dict valueForKey:@"title"]};
        if ([fileDict writeToFile:fileDicPath atomically:YES]) {
            NSLog(@"write success");
            success();
        } else {
            NSError *error = [[NSError alloc]initWithDomain:@"cacheInSandbox" code:3 userInfo:@{ @"ErrorMessage" : @"write into cache failed."}];
            failure(error);
        }
    } else {
        NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicPath];
        if (fileDict.count >= MAX_FAVOR_COUNT) {
            NSError *error = [[NSError alloc]initWithDomain:@"cacheInSandbox" code:4 userInfo:@{ @"ErrorMessage" : @"Cache is full, please clean it first."}];
            failure(error);
        } else {
            [fileDict setObject:[dict valueForKey:@"title"]
                         forKey:[dict valueForKey:@"url"]];
            [fileDict writeToFile:fileDicPath atomically:YES];
            success();
        }
        
//        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileDicPath];
//        [fileHandle seekToEndOfFile];
//        [fileHandle writeData:[NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:NO error:nil]];
//        NSAssert(fileHandle, @"write to file fail");
//        [fileHandle closeFile];
    }
}

+ (void) readDicFromFile: (NSString *)filename success:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure {
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileDicPath]) {
        NSError *error = [[NSError alloc]initWithDomain:@"cacheInSandbox" code:1 userInfo:@{ @"ErrorMessage" : @"The cache File doesn't exist."}];
        failure(error);
    } else {
        NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:fileDicPath];
        if (dataDict) {
            success(dataDict);
        } else {
            NSError *error = [[NSError alloc]initWithDomain:@"cacheInSandbox" code:2 userInfo:@{ @"ErrorMessage" : @"The Cahce File is empty."}];
            failure(error);
        }
    }
}

+ (void) removeFile: (NSString *)filename success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileDicPath]) {
        NSError *error = [[NSError alloc]initWithDomain:@"cacheInSandbox" code:1 userInfo:@{ @"ErrorMessage" : @"The cache File doesn't exist."}];
        failure(error);
    } else {
        [fileManager removeItemAtPath:fileDicPath error:nil];
        success();
    }
}

+ (void) removeDictFromFile: (NSString *)filename dictKey:(NSString *)key success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileDicPath = [docPath stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileDicPath]) {
        NSError *error = [[NSError alloc]initWithDomain:@"cacheInSandbox" code:1 userInfo:@{ @"ErrorMessage" : @"The cache File doesn't exist."}];
        failure(error);
    } else {
        NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicPath];
        [fileDict removeObjectForKey:key];
        [fileDict writeToFile:fileDicPath atomically:YES];
        success();
    }
}

@end
