//
//  NNSpriteSheetFrameData.h
//  UIImage+FlashSpriteSheetExample
//
//  Created by noughts on 2014/11/07.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NNSpriteSheetFrameData : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(BOOL)trimmed;
-(CGRect)frame;
-(CGRect)spriteSourceSize;
-(CGSize)sourceSize;




@end
