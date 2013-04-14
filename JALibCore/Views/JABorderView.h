//
//  JABorderView.h
//  JALib
//
//  Created by Jay Abbott on 2012-06-02.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JABorderView : UIView

@property (strong, nonatomic)			UIImage*		image;
@property (assign, nonatomic)			CGPoint			offset;
@property (strong, nonatomic, readonly)	UIImageView*	imageView;

@end
