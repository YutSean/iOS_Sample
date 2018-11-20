//
//  imageHelper.m
//  Sample_Code
//
//  Created by Yutong on 2018/11/18.
//  Copyright © 2018 Yutong. All rights reserved.
//

#import "imageHelper.h"

@implementation imageHelper
+ (UIImage *)cropSquareImage:(UIImage *)image{
    
    CGImageRef sourceImageRef = [image CGImage];
    
    CGFloat _imageWidth = image.size.width * image.scale;
    CGFloat _imageHeight = image.size.height * image.scale;
    CGFloat _width = _imageWidth > _imageHeight ? _imageHeight : _imageWidth;
    CGFloat _offsetX = (_imageWidth - _width) / 2;
    CGFloat _offsetY = (_imageHeight - _width) / 2;
    
    CGRect rect = CGRectMake(_offsetX, _offsetY, _width, _width);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}
@end
