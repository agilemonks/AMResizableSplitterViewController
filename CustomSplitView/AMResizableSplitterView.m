//
//  AMResizableSplitterView.m
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks, LLC. All rights reserved.
//

#import "AMResizableSplitterView.h"

@interface AMResizableSplitterGripView : UIView

@end

@interface AMResizableSplitterView()
@property (nonatomic, weak) AMResizableSplitterGripView *gripView;
@end

@implementation AMResizableSplitterView

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor brownColor];
		AMResizableSplitterGripView *gripView = [[AMResizableSplitterGripView alloc] initWithFrame:CGRectMake(fabs(frame.size.width/2), 2, 30, 16)];
		gripView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		self.gripView = gripView;
		[self addSubview:gripView];
		gripView.center = CGPointMake(fabsf(self.bounds.size.width/2), fabsf(self.bounds.size.height/2));
		gripView.backgroundColor = [UIColor clearColor];
	}
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	CGRect gframe = self.gripView.frame;
	CGRect frame = self.frame;
	if (frame.size.width > frame.size.height) {
		//portrait
		gframe.size.width = 30;
		gframe.size.height = 16;
	} else {
		gframe.size.width = 16;
		gframe.size.height = 30;
	}
	self.gripView.frame = gframe;
	self.gripView.center = CGPointMake(fabsf(self.bounds.size.width/2), fabsf(self.bounds.size.height/2));
	[self.gripView setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL isLand = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
	CGPoint pt = [touches.anyObject locationInView:self.superview];
	CGFloat ptVal = isLand ? pt.x : pt.y;
	CGFloat startVal = isLand ? self.frame.origin.x : self.frame.origin.y;
	CGFloat offset = (startVal - ptVal) * -1;
	[self.delegate splitterView:self moveByOffset:offset];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end

@implementation AMResizableSplitterGripView

-(void)drawRect:(CGRect)rect
{
	CGRect frame = self.frame;
	CGRect sframe = self.superview.frame;
	UIColor *gray = [UIColor colorWithWhite:0.4 alpha:1];
	if (sframe.size.width > sframe.size.height) {
		//portrait
		CGRect lineRect = CGRectMake(0, 1, frame.size.width, 1);
		for (int i=0; i < 3; i++) {
			[gray set];
			UIRectFill(lineRect);
			lineRect.origin.y += 1;
			[[UIColor whiteColor] set];
			UIRectFill(lineRect);
			lineRect.origin.y += 4;
		}
	} else {
		//landscape
		CGRect lineRect = CGRectMake(1, 0, 1, frame.size.height-2);
		for (int i=0; i < 3; i++) {
			[gray set];
			UIRectFill(lineRect);
			lineRect.origin.x += 1;
			[[UIColor whiteColor] set];
			UIRectFill(lineRect);
			lineRect.origin.x += 4;
		}
	}
}

@end
