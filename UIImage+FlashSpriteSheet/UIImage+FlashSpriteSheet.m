//
//  UIImage+FlashSpriteSheet.m
//  UIImage+FlashSpriteSheetExample
//
//  Created by noughts on 2014/10/05.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "UIImage+FlashSpriteSheet.h"

@implementation UIImage (FlashSpriteSheet)

+(instancetype)animatedImageFromSpriteSheetNamed:(NSString*)name{
	NSURL* url = [[NSBundle mainBundle] URLForResource:name withExtension:@"json"];
	NSError* error;
	NSData* data = [NSData dataWithContentsOfURL:url];
	NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	NSArray* framesData = jsonDictionary[@"frames"];
//	CGSize sourceSize = [self sourceSizeFromFrameData:framesData];
	BOOL trimmed = [self spriteSheetIsTrimmed:framesData];

	NSString* imageName = [NSString stringWithFormat:@"%@.png", name];
	UIImage* spriteSheet_img = [UIImage imageNamed:imageName];
	
	NSMutableArray* images = [NSMutableArray new];
	if( trimmed ){
		for (NSDictionary* frameData in framesData) {
			UIImage* img = [self frameImageFromSpriteSheet:spriteSheet_img withFrameData:frameData];
			[images addObject:img];
		}
	} else {
		for (NSDictionary* frameData in framesData) {
			CGRect rect = [self makeRectFromFrameData:frameData];
			UIImage* img = [self clipImageRect:rect source:spriteSheet_img];
			[images addObject:img];
		}
	}
	
	NSTimeInterval duration = images.count * (1.0/60);
	return [self animatedImageWithImages:images duration:duration];
}



+(UIImage *)imageWithSize:(CGSize)size{
	UIImage *image = nil;
	// ビットマップ形式のグラフィックスコンテキストの生成
	UIGraphicsBeginImageContextWithOptions(size, NO, 0 );
	// 現在のグラフィックスコンテキストの画像を取得する
	image = UIGraphicsGetImageFromCurrentImageContext();
	// 現在のグラフィックスコンテキストへの編集を終了
	// (スタックの先頭から削除する)
	UIGraphicsEndImageContext();
	return image;
}




+(CGRect)spriteSourceSizeFromFrameData:(NSDictionary*)frameData{
	return [self rectFromDictionary:frameData[@"spriteSourceSize"]];
}

/// フレームのrectを取得
+(CGRect)makeRectFromFrameData:(NSDictionary*)frameData{
	return [self rectFromDictionary:frameData[@"frame"]];
}

/// {x,y,w,h}が入っているDictionaryからCGRectを返す
+(CGRect)rectFromDictionary:(NSDictionary*)dictionary{
	NSNumber* x = dictionary[@"x"];
	NSNumber* y = dictionary[@"y"];
	NSNumber* width = dictionary[@"w"];
	NSNumber* height = dictionary[@"h"];
	return CGRectMake(x.intValue, y.intValue, width.intValue, height.intValue);

}


/// カット処理されたスプライトシートか？
+(BOOL)spriteSheetIsTrimmed:(NSArray*)framesData{
	NSDictionary* frameData = framesData[0];
	NSNumber* trimmed = frameData[@"trimmed"];
	return trimmed.boolValue;
}



/// アニメーション画像のソース寸法
+(CGSize)sourceSizeFromFramesData:(NSArray*)framesData{
	return [self sourceSizeFromFrameData:framesData[0]];
}
+(CGSize)sourceSizeFromFrameData:(NSDictionary*)frameData{
	NSDictionary* sourceSize = frameData[@"sourceSize"];
	NSNumber* w = sourceSize[@"w"];
	NSNumber* h = sourceSize[@"h"];
	return CGSizeMake( w.intValue, h.intValue );
}


+(UIImage*)frameImageFromSpriteSheet:(UIImage*)source withFrameData:(NSDictionary*)frameData{
	CGRect rect = [self makeRectFromFrameData:frameData];
	CGRect spriteSourceSize = [self spriteSourceSizeFromFrameData:frameData];
	CGSize sourceSize = [self sourceSizeFromFrameData:frameData];
	
	CGImageRef clip = CGImageCreateWithImageInRect( source.CGImage, rect );
	UIImage *clippedImage = [UIImage imageWithCGImage:clip scale:1 orientation:UIImageOrientationUp];

	UIGraphicsBeginImageContext( sourceSize );
	[clippedImage drawAtPoint:spriteSourceSize.origin];
	UIImage* result_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	CGImageRelease(clip);
	return result_img;
}



+(UIImage*)clipImageRect:(CGRect)rect source:(UIImage*)source{
//	float scale = [[UIScreen mainScreen] scale];
	CGImageRef clip = CGImageCreateWithImageInRect( source.CGImage, rect );
	UIImage *clipedImage = [UIImage imageWithCGImage:clip scale:1 orientation:UIImageOrientationUp];
	CGImageRelease(clip);
	return clipedImage;
}







@end
