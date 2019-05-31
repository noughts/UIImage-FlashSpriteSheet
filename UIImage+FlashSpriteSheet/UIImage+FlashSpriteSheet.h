//
//  UIImage+FlashSpriteSheet.h
//  UIImage+FlashSpriteSheetExample
//
//  Created by noughts on 2014/10/05.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FlashSpriteSheet)

+(void)loadAnimatedImageFromSpriteSheetNamed:(NSString*)name completion:(void (^)(UIImage* image))completion;
+(instancetype)animatedImageFromSpriteSheetNamed:(NSString*)name;

+(void)createImageArrayFromSpriteSheetNamed:(NSString*)name completion:(void (^)(NSArray<UIImage*>* imageArray))completion;

@end
