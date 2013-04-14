//
//  JABorderView.m
//  JALib
//
//  Created by Jay Abbott on 2012-06-02.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import "JABorderView.h"



#pragma mark -
#pragma mark Private interface

@interface JABorderView ()

@property (strong, nonatomic, readwrite)	UIImageView*	borderView;

@end



#pragma mark -
#pragma mark Main class implementation

@implementation JABorderView



#pragma mark -
#pragma mark Public property accessors

- (UIImage*)image
{
	return self.borderView.image;
}
- (void)setImage:(UIImage*)img
{
	self.borderView.image = img;
	[self setNeedsLayout];
}

- (void)setOffset:(CGPoint)off
{
	_offset = off;
	[self setNeedsLayout];
}

- (UIImageView*)imageView
{
	return _borderView;
}



#pragma mark -
#pragma mark Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self == nil)
	{
		return nil;
	}

	// Add an image view
	self.borderView = [[UIImageView alloc] initWithFrame:frame];
	[self addSubview:_borderView];

	return self;
}



#pragma mark -
#pragma mark Overridden view methods

- (void)layoutSubviews
{
	[super layoutSubviews];
	// Extend the edges of the border image view outside the view area
	CGRect			borderFrame = self.frame;
	UIEdgeInsets	insets = _borderView.image.capInsets;
	borderFrame.origin.x = -insets.left + _offset.x;
	borderFrame.origin.y = -insets.top + _offset.y;
	borderFrame.size.width += insets.left + insets.right;
	borderFrame.size.height += insets.top + insets.bottom;
	self.borderView.frame = borderFrame;
}

@end
