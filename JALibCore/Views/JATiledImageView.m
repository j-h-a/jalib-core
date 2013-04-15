//
//  JATiledImageView.m
//  JALib
//
//  Created by Jay on 2012-12-02.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import "JATiledImageView.h"



#pragma mark -
#pragma mark Internal interface

@interface JATiledImageView ()

@property (strong, nonatomic)	UIView*		tiledView;

@end



#pragma mark -
#pragma mark Main class implementation

@implementation JATiledImageView



#pragma mark -
#pragma mark Property accessors

- (UIView*)tiledView
{
	if(_tiledView == nil)
	{
		_tiledView = [[UIView alloc] initWithFrame:self.bounds];
		[self addSubview:_tiledView];
		[self sendSubviewToBack:_tiledView];
		self.clipsToBounds = YES;
	}
	return _tiledView;
}

- (void)setImage:(UIImage*)image
{
	_image = image;
	self.tiledView.backgroundColor = [UIColor colorWithPatternImage:image];
	[self setOffset:_offset];
}

- (void)setOffset:(CGPoint)offset
{
	_offset = offset;
	CGRect		tvFrame;
	CGSize		imgSz = _image.size;
	CGRect		bounds = self.bounds;
	NSInteger	xRepeats = ((int)offset.x / (int)imgSz.width) + 1;
	NSInteger	yRepeats = ((int)offset.y / (int)imgSz.height) + 1;
	tvFrame.origin.x = bounds.origin.x + offset.x - (imgSz.width * xRepeats);
	tvFrame.origin.y = bounds.origin.y + offset.y - (imgSz.height * yRepeats);
	tvFrame.size.width = bounds.size.width + imgSz.width;
	tvFrame.size.height = bounds.size.height + imgSz.height;
	_tiledView.frame = tvFrame;
}

@end
