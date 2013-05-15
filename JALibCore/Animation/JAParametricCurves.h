//
//  JAParametricCurves.h
//  JALib
//
//  Created by Jay on 2012-12-15.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>



@protocol JAParametric

- (CGFloat)valueForParameter:(CGFloat)input;

@end



extern id<JAParametric>	JACurveLinear;
extern id<JAParametric>	JACurveEaseInEaseOut;
extern id<JAParametric>	JACurveEaseIn;
extern id<JAParametric>	JACurveEaseOut;



@interface JACurveHermite : NSObject <JAParametric>

@property (assign, nonatomic)	CGFloat		gradientIn;
@property (assign, nonatomic)	CGFloat		gradientOut;

@end



@interface JACurveComposite : NSObject <JAParametric>

/**
 The start value of the first curve segment.
 */
@property (assign, nonatomic)	CGFloat		startValue;

/**
 The composite curve is made up from other curve segments. Like other curve
 types a parameterised value from 0-1 is passed in and the value of the curve
 at that point is returned using the JAParametric interface.
 The first curve segment starts at input-parameter value 0.0 and ends at a
 user-defined 'endPoint' where 0 < endPoint <= 1.
 Each subsequent segment starts at the end-point of the previous segment and
 continues until its own end-point (which must be greater than its start-point).
 The end-point of the last curve segment is always 1.0, even if specified otherwise.
 
 Each segment also has a startValue and endValue, these determine the output value
 of the curve. The startValue property of this class specifies the startValue for
 the first curve segment and each segment has its own endValue. This is the value
 of the curve at the end of the curve segment (i.e. when the input parameter is
 equal to the endPoint of this segment). The endValue of the previous segment is
 the startValue for the next. The output value of the curve is calculated between
 the startValue and endValue by interpolating according to the segment type.

 Typically, if the output value of the curve is to be used for interpolation, then
 it should be between 0 and 1. For example if the output value is used as the input
 to another curve or for a linear interpolation (LERP) done outside of the curve
 calculation.

 Linear interpolation is performed between the startValue and endValue of the
 segment using the output value of the curve segment as the interpolator, so values
 outside the 0-1 range are still valid and will result in an extrapolated value,
 outside the range of the startValue and endValue.

 A composite curve is constructed from a format string. Each character in the format
 string represents a segment of the curve, the curve type is determined by the format
 character and its parameters are passed in as an NSArray of objects. So for each
 character in the format string there should be exactly one NSArray passed in.
 The format characters and contents of the corresponding array are as follows:

 Format Character | Array contents
 -----------------+-------------------------------------------------------------
 L (Linear)       | [ endPoint, endValue ]
 E (EaseInEaseOut)| [ endPoint, endValue ]
 I (EaseIn)       | [ endPoint, endValue ]
 O (EaseOut)      | [ endPoint, endValue ]
 H (Hermite)      | [ endPoint, endValue, gradientIn, gradientOut ]
 C (Composite)    | [ endPoint, endValue, compositeCurve ]

 The endPoint and endValue array elements should be NSNumber objects with a
 floating-point value for the end-point and end-value parameters.

 gradientIn and gradientOut array elements should be NSNumber objects with a
 floating-point value for the corresponding properties of the hermite curve.

 The compositeCurve element should be an other JACurveComposite object.
*/
+ (JACurveComposite*)curveWithFormat:(NSString*)fmt, ...;

@end

