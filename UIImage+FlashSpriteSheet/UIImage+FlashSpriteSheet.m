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

+(instancetype)animatedImageFromSpriteSheetNamed:(NSString*)name{
	NSURL* url = [[NSBundle mainBundle] URLForResource:name withExtension:@"json"];
	NSError* error;
	NSData* data = [NSData dataWithContentsOfURL:url];
	
	NSString* imageName = [NSString stringWithFormat:@"%@.png", name];
	UIImage* spriteSheet_img = [UIImage imageNamed:imageName];
	
	NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	NSMutableArray* images = [NSMutableArray new];
	for (NSDictionary* dic in jsonDictionary[@"frames"]) {
		NNSpriteSheetFrameData* frameData = [[NNSpriteSheetFrameData alloc] initWithDictionary:dic];
		UIImage* img = [self frameImageFromSpriteSheet:spriteSheet_img withFrameData:frameData];
		[images addObject:img];
	}

	NSTimeInterval duration = images.count * (1.0/60);
	return [self animatedImageWithImages:images duration:duration];
}








+(UIImage*)frameImageFromSpriteSheet:(UIImage*)source withFrameData:(NNSpriteSheetFrameData*)frameData{
	CGImageRef clip = CGImageCreateWithImageInRect( source.CGImage, frameData.frame );
	UIImage* clipped_img = [UIImage imageWithCGImage:clip scale:1 orientation:UIImageOrientationUp];
	UIImage* result_img;
	if( frameData.trimmed ){
		UIGraphicsBeginImageContext( frameData.sourceSize );
		[clipped_img drawAtPoint:frameData.spriteSourceSize.origin];
		result_img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	} else {
		result_img = clipped_img;
	}
	CGImageRelease(clip);
	return result_img;
}








@end
