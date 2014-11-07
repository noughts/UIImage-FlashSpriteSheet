//
//  UIImage+FlashSpriteSheet.m
//  UIImage+FlashSpriteSheetExample
//
//  Created by noughts on 2014/10/05.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "UIImage+FlashSpriteSheet.h"
#import "NNSpriteSheetFrameData.h"

@implementation UIImage (FlashSpriteSheet)

+(void)loadAnimatedImageFromSpriteSheetNamed:(NSString*)name completion:(void (^)(UIImage* image))completion{
	NSOperationQueue* queue = [NSOperationQueue new];
	[queue addOperationWithBlock:^{
		UIImage* animatedImage = [self animatedImageFromSpriteSheetNamed:name];
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			completion( animatedImage );
		}];
	}];
}


+(instancetype)animatedImageFromSpriteSheetNamed:(NSString*)name{
	NSURL* url = [[NSBundle mainBundle] URLForResource:name withExtension:@"json"];
	NSError* error;
	NSData* data = [NSData dataWithContentsOfURL:url];
	
	BOOL memoryHack = YES;
	UIImage* spriteSheet_img;
	if( memoryHack ){
		NSString* imageName = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
		spriteSheet_img = [UIImage imageWithContentsOfFile:imageName];
		
		// imageNamedで画像をロードすると、永遠にキャッシュが残るが、imageWithContentsOfFileでロードすると、スプライトシートから切り出す際のdrawAtPointに必要な内部描画処理が激遅なので、
		// 一旦描画したものをあとでスプライトシートから切り出すようにすると高速化するというハック
		// http://blog.syuhari.jp/archives/1694
		CGImageRef temp_ref = [spriteSheet_img CGImage];
		UIGraphicsBeginImageContext(CGSizeMake(CGImageGetWidth(temp_ref), CGImageGetHeight(temp_ref)));
		[spriteSheet_img drawAtPoint:CGPointMake(0,0)];
		spriteSheet_img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	} else {
		NSString* imageName = [NSString stringWithFormat:@"%@.png", name];
		spriteSheet_img = [UIImage imageNamed:imageName];
	}
	
	NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	NSMutableArray* images = [NSMutableArray new];
	for (NSDictionary* dic in jsonDictionary[@"frames"]) {
		@autoreleasepool {
			NNSpriteSheetFrameData* frameData = [[NNSpriteSheetFrameData alloc] initWithDictionary:dic];
			UIImage* img = [self frameImageFromSpriteSheet:spriteSheet_img withFrameData:frameData];
			[images addObject:img];
		}
	}
	NSTimeInterval duration = images.count * (1.0/60);
	return [self animatedImageWithImages:images duration:duration];
}









+(UIImage*)frameImageFromSpriteSheet:(UIImage*)source withFrameData:(NNSpriteSheetFrameData*)frameData{
	CGFloat scale = [UIScreen mainScreen].scale;
	
	CGImageRef clip = CGImageCreateWithImageInRect( source.CGImage, frameData.frame );
	UIImage* clipped_img = [UIImage imageWithCGImage:clip scale:scale orientation:UIImageOrientationUp];
	UIImage* result_img;
	if( frameData.trimmed ){
		CGSize size = CGSizeMake( frameData.sourceSize.width/scale, frameData.sourceSize.height/scale );
		UIGraphicsBeginImageContextWithOptions( size, NO, scale );
		CGPoint pt = CGPointMake(frameData.spriteSourceSize.origin.x/scale, frameData.spriteSourceSize.origin.y/scale );
		[clipped_img drawAtPoint:pt];
		result_img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	} else {
		result_img = clipped_img;
	}
	CGImageRelease(clip);
	return result_img;
}








@end
