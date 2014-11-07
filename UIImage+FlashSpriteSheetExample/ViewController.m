//
//  ViewController.m
//  UIImage+FlashSpriteSheetExample
//
//  Created by noughts on 2014/10/05.
//  Copyright (c) 2014年 noughts. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+FlashSpriteSheet.h"


@implementation ViewController{
	__weak IBOutlet UIImageView* _iv;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	

}


-(IBAction)onLoadButtonTap:(id)sender{
	NSDate* s = [NSDate date];
	UIImage* anime_img = [UIImage animatedImageFromSpriteSheetNamed:@"guideAnimations_cut_stack"];
	NSLog( @"load complete %fms.", [[NSDate date] timeIntervalSinceDate:s]*1000 );
	_iv.image = anime_img;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
