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
	
	NSString* imageName = [NSString stringWithFormat:@"%@.png", name];
	UIImage* spriteSheet_img = [UIImage imageNamed:imageName];
	
	NSMutableArray* images = [NSMutableArray new];
	for (NSDictionary* frameData in framesData) {
		CGRect rect = [self makeRectFromFrameData:frameData[@"frame"]];
		UIImage* img = [self clipImageRect:rect source:spriteSheet_img];
		[images addObject:img];
	}
	
	
	NSTimeInterval duration = images.count * (1.0/60);
	return [self animatedImageWithImages:images duration:duration];
}

+(CGRect)makeRectFromFrameData:(NSDictionary*)frameData{
	NSNumber* x = frameData[@"x"];
	NSNumber* y = frameData[@"y"];
	NSNumber* width = frameData[@"w"];
	NSNumber* height = frameData[@"h"];
	return CGRectMake(x.floatValue, y.floatValue, width.floatValue, height.floatValue);
}


+(UIImage*)clipImageRect:(CGRect)rect source:(UIImage*)source{
	float scale = [[UIScreen mainScreen] scale];
	CGImageRef clip = CGImageCreateWithImageInRect( source.CGImage, rect );
	UIImage *clipedImage = [UIImage imageWithCGImage:clip scale:scale orientation:UIImageOrientationUp];
	CGImageRelease(clip);
	return clipedImage;
}







@end
