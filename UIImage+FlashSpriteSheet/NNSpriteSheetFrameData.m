//
//  NNSpriteSheetFrameData.m
//  UIImage+FlashSpriteSheetExample
//
//  Created by noughts on 2014/11/07.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "NNSpriteSheetFrameData.h"

@implementation NNSpriteSheetFrameData{
	NSDictionary* _data;
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary{
	if( self = [super init] ){
		_data = dictionary;
	}
	return self;
}


-(BOOL)trimmed{
	NSNumber* trimmed = _data[@"trimmed"];
	return trimmed.boolValue;
}
-(CGRect)frame{
	return [self rectFromDictionary:_data[@"frame"]];
}
-(CGRect)spriteSourceSize{
	return [self rectFromDictionary:_data[@"spriteSourceSize"]];
}
-(CGSize)sourceSize{
	NSDictionary* sourceSize = _data[@"sourceSize"];
	NSNumber* width = sourceSize[@"w"];
	NSNumber* height = sourceSize[@"h"];
	return CGSizeMake( width.integerValue, height.integerValue );
}





/// {x,y,w,h}が入っているDictionaryからCGRectを返す
-(CGRect)rectFromDictionary:(NSDictionary*)dictionary{
	NSNumber* x = dictionary[@"x"];
	NSNumber* y = dictionary[@"y"];
	NSNumber* width = dictionary[@"w"];
	NSNumber* height = dictionary[@"h"];
	return CGRectMake(x.intValue, y.intValue, width.intValue, height.intValue);
}



@end
