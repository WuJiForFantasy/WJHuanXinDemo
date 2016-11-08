//
//  UIImage+WJAdditions.h
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 16/8/17.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WJAdditions)

+ (UIImage *)QRencoderImage;

/**
 *  绘制圆角
 *
 *  @param radius 圆角大小
 *
 *  @return 圆角UIImage
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/**
 *  生成透明图片
 *
 *  @param color  颜色
 *  @param height 透明度
 *
 *  @return UIImage
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

/**图像边框默认的2像素*/
- (UIImage *)borderImage;

/**图片拉伸、平铺接口*/
- (UIImage *)resizableImageWithCompatibleCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

/**图片以ScaleToFit方式拉伸后的CGSize*/
- (CGSize)sizeOfScaleToFit:(CGSize)scaledSize;

/**将图片转向调整为向上*/
- (UIImage *)fixOrientation;

/**以ScaleToFit方式压缩图片*/
- (UIImage *)compressedImageWithSize:(CGSize)compressedSize;

/**图片根据宽度缩放*/
- (UIImage *)compressImagetoTargetWidth:(CGFloat)targetWidth;

/**生成二维码*/
+ (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size;

@end
