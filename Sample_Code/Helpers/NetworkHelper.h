//
//  NetworkHelper.h
//  Sample_Code
//
//  do some Network relative work
//
//  Created by Yutong on 2018/11/13.
//  Copyright © 2018 Yutong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkHelper : NSObject <NSCacheDelegate>

@property (nonatomic, retain) NSMutableDictionary *parmDic;
@property (nonatomic, retain) NSDictionary *newsData;
@property (nonatomic, retain) NSError *netErrors;
@property (nonatomic, retain) NSMutableDictionary *cachedImage;
@property (nonatomic, strong) NSCache *cache;

- (void) getNewsDataFromNet;
- (void) getNewsDataFromNetWithKeyWord: (NSString *)keyword;
- (void) resetParameters;
- (void) getJsonResponse:(NSString *)urlStr success:(void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

- (void) getImageData:(NSString *)imgUrl success:(void (^)(NSData *responseData))success failure:(void(^)(NSError* error))failure;

+ (instancetype)getInstance;
+ (id) allocWithZone:(struct _NSZone*)zone;

@end
 /* NetworkHelper_h */
