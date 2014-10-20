//
//  AMResizableSplitViewController.m
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks, LLC. All rights reserved.
//

#import "AMResizableSplitViewController.h"
#import "AMResizableSplitterView.h"

#define SPLITTER_LENGTH 20

@interface AMSplitContainer : UIView
@property (nonatomic, weak) AMResizableSplitViewController *controller;
@end

#pragma mark - class extension
@interface AMResizableSplitViewController () <AMResizableSplitterViewDelegate> {
	BOOL _handlingMove;
}
@property (nonatomic) UIView *view1;
@property (nonatomic) UIView *view2;
@end

#pragma mark - implementation

@implementation AMResizableSplitViewController

-(id)init
{
	if ((self = [super init])) {
		self.minimumView1Size = CGSizeMake(100, 100);
		self.minimumView2Size = CGSizeMake(100, 100);
	}
	return self;
}

#pragma mark - UIViewController overrides

-(void)loadView
{
	AMSplitContainer *view = [[AMSplitContainer alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	view.autoresizesSubviews=NO;
	view.clipsToBounds=YES;
	view.controller = self;
	self.view = view;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	CGRect frame = self.view.frame;
	CGFloat sectionLen = floorf((frame.size.width - SPLITTER_LENGTH)/2);
	self.splitterView = [[AMResizableSplitterView alloc] initWithFrame:CGRectMake(sectionLen, 0, SPLITTER_LENGTH, frame.size.height)];
	self.splitterView.delegate = self;
	[self.view addSubview:self.splitterView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self adjustToDefaultFrames];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^{
		[self rotateChildren:toInterfaceOrientation];
	}];
}

#pragma mark - meat & potatos

-(void)viewFrameDidChange
{
	CGRect winFrame = self.view.window.frame;
	BOOL isWide = winFrame.size.width > winFrame.size.height;
	CGRect ourFrame = self.view.frame;
	CGRect r1 = self.controller1.view.frame;
	CGRect r2 = self.controller2.view.frame;
	CGRect rs = self.splitterView.frame;
	if (isWide) {
		//adjust for height in case we have a toolbar
		if (r1.size.height > ourFrame.size.height) {
			r1.size.height = ourFrame.size.height;
			r2.size.height = ourFrame.size.height;
			rs.size.height = ourFrame.size.height;
			if ((r1.size.width + r2.size.width + rs.size.width) < ourFrame.size.width) {
				//need to adjust the width. just add the diff to r2
				CGFloat diff = ourFrame.size.width - r1.size.width - r2.size.width - rs.size.width;
				r2.size.width += diff;
			}
		}
	} else {
		if (r1.size.width < ourFrame.size.width) {
			r1.size.width = ourFrame.size.width;
			r2.size.width = ourFrame.size.width;
			rs.size.width = ourFrame.size.width;
			if ((r1.size.height + r2.size.height + rs.size.height) > ourFrame.size.height) {
				//need to subtract from the height. just subtract diff from r2
				CGFloat diff = ourFrame.size.height - r1.size.height - r2.size.height - rs.size.height;
				r2.size.height += diff;
			}
		}
	}
	self.controller1.view.frame = r1;
	self.controller2.view.frame = r2;
	self.splitterView.frame = rs;
}

-(void)rotateChildren:(UIInterfaceOrientation)destOrientation
{
	BOOL toLand = UIInterfaceOrientationIsLandscape(destOrientation);
	CGRect dividerFrame = self.splitterView.frame;
	CGRect r1 = self.controller1.view.frame;
	CGRect r2 = self.controller2.view.frame;
	//adjust view1's frame
	CGFloat tmp = r1.size.height;
	r1.size.height = r1.size.width;
	r1.size.width = tmp;
	//adjust splitter's frame
	tmp = dividerFrame.origin.y;
	dividerFrame.origin.y = dividerFrame.origin.x;
	dividerFrame.origin.x = tmp;
	tmp = dividerFrame.size.height;
	dividerFrame.size.height = dividerFrame.size.width;
	dividerFrame.size.width = tmp;
	//adjust view2's frame
	tmp = r2.origin.y;
	r2.origin.y = r2.origin.x;
	r2.origin.x = tmp;
	tmp = r2.size.height;
	r2.size.height = r2.size.width;
	r2.size.width = tmp;
	//adjust rects for status bar height
	CGFloat halfBar = floorf(SPLITTER_LENGTH / 2);
	if (toLand) {
		r1.size.height -= halfBar;
		r2.size.height -= halfBar;
		dividerFrame.size.height -= halfBar;
	} else {
		r1.size.width += halfBar;
		r2.size.width += halfBar;
		dividerFrame.size.width += halfBar;
	}
	//set the frames
	self.splitterView.frame = dividerFrame;
	self.controller1.view.frame = r1;
	self.controller2.view.frame = r2;
}

-(void)adjustToDefaultFrames
{
	CGRect winFrame = self.view.window.frame;
	BOOL isWide = winFrame.size.width > winFrame.size.height;
	CGRect ourFrame = self.view.frame;
	CGFloat sectionLen = floorf((ourFrame.size.width - SPLITTER_LENGTH) / 2);
	if (isWide) {
		self.controller1.view.frame = CGRectMake(0, 0, sectionLen, ourFrame.size.height);
		self.controller2.view.frame = CGRectMake(sectionLen+SPLITTER_LENGTH, 0, sectionLen, ourFrame.size.height);
		self.splitterView.frame = CGRectMake(sectionLen, 0, SPLITTER_LENGTH, ourFrame.size.height);
	} else {
		sectionLen = floorf((ourFrame.size.height - SPLITTER_LENGTH) / 2);
		self.controller1.view.frame = CGRectMake(0, 0, ourFrame.size.width, sectionLen);
		self.controller2.view.frame = CGRectMake(0, sectionLen+SPLITTER_LENGTH, ourFrame.size.width, sectionLen);
		self.splitterView.frame = CGRectMake(0, sectionLen, ourFrame.size.width, SPLITTER_LENGTH);
	}
}

-(void)splitterViewWillStartTrackingTouches:(AMResizableSplitterView *)splitterView
{
	if ([self.delegate respondsToSelector:@selector(willMoveSplitter:)])
		[self.delegate willMoveSplitter:self];
}

-(void)splitterViewDidEndTrackingTouches:(AMResizableSplitterView *)splitterView
{
	if ([self.delegate respondsToSelector:@selector(didMoveSplitter:)])
		[self.delegate didMoveSplitter:self];
}

-(void)splitterView:(AMResizableSplitterView*)splitterView moveByOffset:(CGFloat)offset
{
	CGRect winFrame = self.view.window.frame;
	BOOL isLand = winFrame.size.width > winFrame.size.height;
	CGRect dividerRect = splitterView.frame;

	//validate the offset is in the acceptable range
	CGFloat curLoc = isLand ? self.splitterView.frame.origin.x : self.splitterView.frame.origin.y;
	CGFloat newLoc = curLoc + offset;
	CGFloat minOffset = isLand ? self.minimumView1Size.width : self.minimumView1Size.height;
	CGFloat maxOffset = isLand ? self.view.bounds.size.width : self.view.bounds.size.height;
	maxOffset -= isLand ? self.minimumView2Size.width : self.minimumView2Size.height;
	if (newLoc < minOffset)
		offset = 0;
	if (newLoc > maxOffset)
		offset = maxOffset - curLoc;
	if (offset == 0)
		return;
	
	CGRect r1 = self.controller1.view.frame;
	CGRect r2 = self.controller2.view.frame;
	if (isLand) {
		dividerRect.origin.x = dividerRect.origin.x + offset;
		r1.size.width += offset;
		r2.origin.x += offset;
		r2.size.width = self.view.bounds.size.width - r2.origin.x;
	} else {
		dividerRect.origin.y = dividerRect.origin.y + offset;
		r1.size.height += offset;
		r2.origin.y += offset;
		r2.size.height = self.view.bounds.size.height - r2.origin.y;
	}
	splitterView.frame = dividerRect;
	self.controller1.view.frame = r1;
	self.controller2.view.frame = r2;

	[self.view setNeedsDisplay];
}

#pragma mark - accessors

-(void)setController1:(UIViewController *)controller1
{
	if (_controller1) {
		[_controller1 willMoveToParentViewController:nil];
		[_controller1.view removeFromSuperview];
		[_controller1 removeFromParentViewController];
	}
	_controller1 = controller1;
	[self addChildViewController:controller1];
	[self.view addSubview:controller1.view];
	[controller1 didMoveToParentViewController:self];
}

-(void)setController2:(UIViewController *)controller2
{
	if (_controller2) {
		[_controller2 willMoveToParentViewController:nil];
		[_controller2.view removeFromSuperview];
		[_controller2 removeFromParentViewController];
	}
	_controller2 = controller2;
	[self addChildViewController:controller2];
	[self.view addSubview:controller2.view];
	[controller2 didMoveToParentViewController:self];
}

-(CGFloat)splitterPosition
{
	if (self.view.frame.size.width > self.view.frame.size.height)
		return self.splitterView.frame.origin.x + floorf(SPLITTER_LENGTH/2);
	return self.splitterView.frame.origin.y + floorf(SPLITTER_LENGTH/2);
}

-(void)setSplitterPosition:(CGFloat)splitterPosition
{
	[self setSplitterPosition:splitterPosition animated:NO];
}

-(void)setSplitterPosition:(CGFloat)splitterPosition animated:(BOOL)animated
{
	CGFloat offset = splitterPosition;
	if (self.view.frame.size.width > self.view.frame.size.height)
		offset -= self.splitterView.frame.origin.x;
	else
		offset -= self.splitterView.frame.origin.y;
	[self splitterView:self.splitterView moveByOffset:offset - floorf(SPLITTER_LENGTH/2)];
}
@end

@implementation AMSplitContainer
-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self.controller viewFrameDidChange];
}
@end
