//
//  NetworkHelper.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/13.
//  Copyright © 2018 Yutong. All rights reserved.
//
#import "NetworkHelper.h"
#define NewsAPI @"apiKey=6a1fb0e9c2d64cc0886fcfb0a8bfaacc"
#define NewsServer @"https://newsapi.org/v2/top-headlines?"

@implementation NetworkHelper

static id _instance;

//  Singleton
+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (id) allocWithZone:(struct _NSZone*)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id) init {
    if ([super init]) {
        self.parmDic = [NSMutableDictionary new];
        self.cachedImage = [NSMutableDictionary new];
        [self resetParameters];
    }
    return self;
}

- (void) resetParameters {
    [self.parmDic setValue:@"" forKey:@"country"];
    [self.parmDic setValue:@"" forKey:@"category"];
    [self.parmDic setValue:@"" forKey:@"q"];
    [self.parmDic setValue:@"" forKey:@"sources"];
    [self.parmDic setValue:@"" forKey:@"page"];
}

//  asynchronous get JSON from news API
- (void) getJsonResponse:(NSString *)urlStr success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    NSURL *newsUrl = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:newsUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(dict);
        } else {
            failure(error);
        }
    }];
    [dataTask resume];
}

//  aquire news data
- (void) getNewsDataFromNet{

    if (_newsData != nil) {
        _newsData = nil;
    }
    //  construct the request URL
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString:NewsServer];
    for (NSString *key in self.parmDic) {
        NSString *temp = [self.parmDic valueForKey:key];
        if (![temp  isEqual: @""]) {
            [url appendString:key];
            [url appendString:@"="];
            [url appendString:temp];
            [url appendString:@"&"];
        }
    }
    [url appendString:NewsAPI];
    
    [self getJsonResponse:url success:^(NSDictionary *responseDict) {
        [self setNewsData:responseDict];
    } failure:^(NSError* error) {
        [self setNetErrors:error];
    }];
}
- (void) getNewsDataFromNetWithKeyWord: (NSString *)keyword {
    [self.parmDic setObject:keyword forKey:@"q"];
    [self getNewsDataFromNet];
    [self.parmDic setObject:@"" forKey:@"q"];
}

//  check if the image has been cached first
- (void) getImageData:(NSString *)imgUrl success:(void (^)(NSData *responseData))success failure:(void(^)(NSError* error))failure {
    if (self.cache == nil) {
        self.cache = [NSCache new];
    }
    NSData *data = [_cache objectForKey:imgUrl];
    if (data) {
        success(data);
    } else {
        NSURL *dataUrl = [NSURL URLWithString:imgUrl];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:dataUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                [self.cache setObject:data forKey:imgUrl];
                success(data);
            } else {
                failure(error);
            }
        }];
        [dataTask resume];
    }
}

@end
