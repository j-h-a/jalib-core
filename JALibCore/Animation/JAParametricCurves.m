//
//  JAParametricCurves.m
//  JALib
//
//  Created by Jay on 2012-12-15.
//  Copyright (c) 2012 Jay Abbott. All rights reserved.
//

#import "JAParametricCurves.h"



#ifndef LERP
#define LERP(_a, _b, _alpha) ( ((_b) * (_alpha)) + ((_a) * (1.0f - (_alpha))) )
#endif



#pragma mark -
#pragma mark Private classes

@interface _constCurve_JACurveLinear : NSObject<JAParametric>
@end
@implementation _constCurve_JACurveLinear
- (CGFloat)valueForParameter:(CGFloat)s
{
	return s;
}
@end

@interface _constCurve_JACurveEaseInEaseOut : NSObject<JAParametric>
@end
@implementation _constCurve_JACurveEaseInEaseOut
- (CGFloat)valueForParameter:(CGFloat)s
{
	if(s <= 0.0f) return 0.0f;
	if(s >= 1.0f) return 1.0f;
	// Equivalent to hermite curve with gradientIn and gradientOut both equal to zero
	// This is exactly the same as the internal 'h2' value from the hermite curve
	float	s2	=  s * s;
	float	s3	= s2 * s;
	return	(3 * s2) - (2 * s3);
}
@end

@interface _constCurve_JACurveEaseIn : NSObject<JAParametric>
@end
@implementation _constCurve_JACurveEaseIn
- (CGFloat)valueForParameter:(CGFloat)s
{
	if(s <= 0.0f) return 0.0f;
	if(s >= 1.0f) return s;
	// Equivalent to hermite curve with gradientIn = 0 and gradientOut = 1
	// That is: h2 + h4
	float	s2	=  s * s;
	float	s3	= s2 * s;
	return	((3 * s2) - (2 * s3)) + (s3 - s2);
}
@end

@interface _constCurve_JACurveEaseOut : NSObject<JAParametric>
@end
@implementation _constCurve_JACurveEaseOut
- (CGFloat)valueForParameter:(CGFloat)s
{
	if(s <= 0.0f) return s;
	if(s >= 1.0f) return 1.0f;
	// Equivalent to hermite curve with gradientIn = 1 and gradientOut = 0
	// That is: h2 + h3
	float	s2	=  s * s;
	float	s3	= s2 * s;
	return	((3 * s2) - (2 * s3)) + (s3 - (2 * s2) + s);
}
@end

@interface JACurveComposite_curveSegment : NSObject
@property (assign, nonatomic)	CGFloat				endPoint;
@property (assign, nonatomic)	CGFloat				endValue;
@property (strong, nonatomic)	id<JAParametric>	curve;
@end
@implementation JACurveComposite_curveSegment
@end



#pragma mark -
#pragma mark Constant curves

id<JAParametric>	JACurveLinear;
id<JAParametric>	JACurveEaseInEaseOut;
id<JAParametric>	JACurveEaseIn;
id<JAParametric>	JACurveEaseOut;

__attribute__((constructor)) void JACurve_createConstantCurveClasses(void);
__attribute__((constructor)) void JACurve_createConstantCurveClasses(void)
{
	JACurveLinear			= [_constCurve_JACurveLinear new];
	JACurveEaseInEaseOut	= [_constCurve_JACurveEaseInEaseOut new];
	JACurveEaseIn			= [_constCurve_JACurveEaseIn new];
	JACurveEaseOut			= [_constCurve_JACurveEaseOut new];
}



#pragma mark -
#pragma mark Curve: Hermite

@implementation JACurveHermite



#pragma mark -
#pragma mark JAParametric implementation

- (CGFloat)valueForParameter:(CGFloat)s
{
	if(s <= 0.0f) return s * _gradientIn;
	if(s >= 1.0f) return ((s - 1.0f) * _gradientOut) + 1.0f;
	// Calculate the hermite functions h1-h4.
	// h1 is multiplied by zero so is ommitted, but left in comments for clarity.
	float	_s2		=    s * s;
	float	_s3		=  _s2 * s;
	float	_3s2	=    3 * _s2;
	float	_2s3	=    2 * _s3;
	//float	h1		= _2s3 - _3s2      + 1;
	float	h2		= _3s2 - _2s3;
	float	h3		=  _s3 - (2 * _s2) + s;
	float	h4		=  _s3 - _s2;
	return	//(h1 * 0) +
			(h2 * 1) +
			(h3 * _gradientIn) +
			(h4 * _gradientOut);
}

@end



#pragma mark -
#pragma mark Curve: Composite

@interface JACurveComposite ()

@property (strong, nonatomic)	NSMutableArray*		segments;

@end



@implementation JACurveComposite

#pragma mark -
#pragma mark Object lifecycle

- (id)init
{
	self = [super init];
	if(self == nil)
	{
		return nil;
	}

	_segments = [NSMutableArray array];

	return self;
}

- (void)addEndPoint:(NSNumber*)endPointNumber endValue:(NSNumber*)endValueNumber curve:(id<JAParametric>)curve
{
	CGFloat	endPoint = [endPointNumber floatValue];
	if(_segments.count != 0)
	{
		CGFloat previousEndPoint = ((JACurveComposite_curveSegment*)[_segments lastObject]).endPoint;
		// Make sure the endPoint is bigger than the previous one
		if(endPoint <= previousEndPoint)
		{
			[NSException raise:NSInvalidArgumentException format:@"JACurveComposite: Each endPoint must be bigger than the previous endPoint (%.2f was given and the previous value was %.2f).", endPoint, previousEndPoint];
		}
		// Prevent additions beyond 1.0
		if(previousEndPoint == 1.0f)
		{
			[NSException raise:NSInvalidArgumentException format:@"JACurveComposite: The previous endPoint is already 1.0, cannot add any more curve segments."];
		}
	}
	// Make sure the endPoint is in range
	if((endPoint <= 0.0f) || (endPoint > 1.0f))
	{
		[NSException raise:NSInvalidArgumentException format:@"JACurveComposite: endPoint must be in the range 0.0 < value <= 1.0 (%.2f was given).", endPoint];
	}

	JACurveComposite_curveSegment*	segment = [JACurveComposite_curveSegment new];
	segment.endPoint = [endPointNumber floatValue];
	segment.endValue = [endValueNumber floatValue];
	segment.curve = curve;
	[_segments addObject:segment];
}

- (void)appendFormat:(NSString*)fmt argList:(va_list)args
{
#define FORMAT_BUFFER_SIZE	(NSUInteger)32
	unichar		buffer[FORMAT_BUFFER_SIZE];
	NSUInteger	fmtIdx, fmtRemain;

	// Iterate through the format string...
	for(fmtIdx = 0, fmtRemain = fmt.length; fmtRemain > 0; fmtIdx += FORMAT_BUFFER_SIZE)
	{
		// Copy the next chunk of characters into the buffer
		NSUInteger	i, remain;
		remain = MIN(FORMAT_BUFFER_SIZE, fmtRemain);
		[fmt getCharacters:buffer range:NSMakeRange(fmtIdx, remain)];
		fmtRemain -= remain;
		// Iterate through this chunk
		for(i = 0; i < remain; i++)
		{
			unichar		uc = buffer[i];
			NSArray*	arr = va_arg(args, NSArray*);
			switch(uc)
			{
				case 'L':	// Linear
				{
					[self addEndPoint:arr[0] endValue:arr[1] curve:JACurveLinear];
					break;
				}
				case 'E':	// EaseInEaseOut
				{
					[self addEndPoint:arr[0] endValue:arr[1] curve:JACurveEaseInEaseOut];
					break;
				}
				case 'I':	// EaseIn
				{
					[self addEndPoint:arr[0] endValue:arr[1] curve:JACurveEaseIn];
					break;
				}
				case 'O':	// EaseOut
				{
					[self addEndPoint:arr[0] endValue:arr[1] curve:JACurveEaseOut];
					break;
				}
				case 'H':	// Hermite
				{
					JACurveHermite*	hermite = [JACurveHermite new];
					hermite.gradientIn = [arr[2] floatValue];
					hermite.gradientOut = [arr[3] floatValue];
					[self addEndPoint:arr[0] endValue:arr[1] curve:hermite];
					break;
				}
				case 'C':	// Composite
				{
					[self addEndPoint:arr[0] endValue:arr[1] curve:arr[2]];
					break;
				}
			}
		}
	}
}

+ (JACurveComposite*)curveWithFormat:(NSString*)fmt, ...
{
	JACurveComposite* curve = [self new];
	va_list args;
    va_start(args, fmt);
	[curve appendFormat:fmt argList:args];
    va_end(args);
	return curve;
}



#pragma mark -
#pragma mark JAParametric implementation

- (CGFloat)valueForParameter:(CGFloat)s
{
	NSUInteger	numSegments = _segments.count;

	// If there are no curve segments just behave like a linear curve
	if(numSegments == 0)
	{
		return s;
	}

	JACurveComposite_curveSegment*	activeSegment = nil;
	JACurveComposite_curveSegment*	previousSegment = nil;
	CGFloat							startValue = _startValue;
	CGFloat							curveIn;

	if(numSegments == 1)
	{
		// Only 1 curve segment, treat it as the full curve
		activeSegment = [_segments objectAtIndex:0];
		curveIn = s;
	}
	else
	{
		// 2 or more curve segments...
		if(s <= 0.0f)
		{
			activeSegment = [_segments objectAtIndex:0];
			// Previous endPoint is 0.0 so just use active segment endPoint
			curveIn = s / activeSegment.endPoint;
		}
		else if(s >= 1.0f)
		{
			activeSegment = [_segments objectAtIndex:numSegments - 1];
			previousSegment = [_segments objectAtIndex:numSegments - 2];
			startValue = previousSegment.endValue;
			// Use 1.0 as active segment endPoint because this is the last segment
			CGFloat	startPoint = previousSegment.endPoint;
			curveIn = (s - startPoint) / (1.0f - startPoint);
		}
		else
		{
			// Use a binary search to find the active segment. The active segment is
			// the one such that previousSegment.endPoint < s <= activeSegment.endPoint
			NSInteger	minIdx = 0;
			NSInteger	maxIdx = (NSInteger)numSegments - 1;
			CGFloat		startPoint;
			CGFloat		endPoint;
			while(minIdx < maxIdx)
			{
				// Calculate the middle index - half way between the enclosing min/max values
				NSInteger	midIdx = (minIdx + maxIdx) / 2;
				// Get the startPoint and endPoint for this middle index
				if(midIdx == 0)
				{
					startPoint = 0.0f;
				}
				else
				{
					previousSegment = [_segments objectAtIndex:(NSUInteger)midIdx - 1];
					startPoint = previousSegment.endPoint;
				}
				activeSegment = [_segments objectAtIndex:(NSUInteger)midIdx];
				endPoint = (midIdx == ((NSInteger)numSegments - 1)) ? 1.0f : activeSegment.endPoint;
				// Compare to see if s is between start/end  - or if we should search higher or lower
				if(s <= startPoint)
				{
					// Search lower
					maxIdx = midIdx - 1;
				}
				else if(s > endPoint)
				{
					// Search higher
					minIdx = midIdx + 1;
				}
				else
				{
					// We found our match
					minIdx = maxIdx = midIdx;
				}
			}

			// Set the active segment and calculate the curve input
			activeSegment = [_segments objectAtIndex:(NSUInteger)minIdx];
			if(minIdx == 0)
			{
				startPoint = 0.0f;
				startValue = _startValue;
			}
			else
			{
				previousSegment = [_segments objectAtIndex:(NSUInteger)minIdx - 1];
				startPoint = previousSegment.endPoint;
				startValue = previousSegment.endValue;
			}
			endPoint = (minIdx == ((NSInteger)numSegments - 1)) ? 1.0f : activeSegment.endPoint;
			curveIn = (s - startPoint) / (endPoint - startPoint);
		}
	}

	// startValue, endValue, and curveIn have all been calculated: Do the interpolation
	return LERP(startValue, activeSegment.endValue, [activeSegment.curve valueForParameter:curveIn]);
}

@end
