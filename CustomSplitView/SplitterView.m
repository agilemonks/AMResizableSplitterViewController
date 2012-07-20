//
//  SplitterView.m
//  CustomSplitView
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "SplitterView.h"

@implementation SplitterView {
	BOOL _inittedRange;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor brownColor];
	}
	return self;
}

-(void)didMoveToSuperview
{
	if (!_inittedRange) {
		if (self.maxX < 100)
			self.maxX = self.superview.bounds.size.height;
		if (self.maxY < 100)
			self.maxY = self.superview.bounds.size.width;
		_inittedRange=YES;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL isLand = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
	CGFloat min = isLand ? self.minX : self.minY;
	CGFloat max = isLand ? self.maxX : self.maxY;
	CGPoint pt = [touches.anyObject locationInView:self.superview];
	CGFloat ptVal = isLand ? pt.x : pt.y;
	CGFloat startVal = isLand ? self.frame.origin.x : self.frame.origin.y;
	CGFloat offset = (startVal - ptVal) * -1;
	CGFloat endVal = startVal + offset;
	if (endVal < min || endVal > max)
		return;
	[self.delegate splitterView:self moveByOffset:offset];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
