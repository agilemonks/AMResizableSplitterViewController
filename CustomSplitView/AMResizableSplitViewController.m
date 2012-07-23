//
//  AMResizableSplitViewController.m
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks, LLC. All rights reserved.
//

#import "AMResizableSplitViewController.h"
#import "AMResizableSplitterView.h"

#define SPLITTER_LENGTH 20

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
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	view.autoresizesSubviews=NO;
	self.view = view;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.splitterView = [[AMResizableSplitterView alloc] initWithFrame:CGRectMake(502, 0, SPLITTER_LENGTH, 748)];
	self.splitterView.delegate = self;
	[self.view addSubview:self.splitterView];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self adjustToDefaultFrames];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^{
		[self rotateChildren:toInterfaceOrientation];
	}];
}

#pragma mark - meat & potatos

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
	if (toLand) {
		r1.size.height -= 20;
		r2.size.height -= 20;
		dividerFrame.size.height -= 20;
	} else {
		r1.size.width += 20;
		r2.size.width += 20;
		dividerFrame.size.width += 20;
	}
	//set the frames
	self.splitterView.frame = dividerFrame;
	self.controller1.view.frame = r1;
	self.controller2.view.frame = r2;
}

-(void)adjustToDefaultFrames
{
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		self.controller1.view.frame = CGRectMake(0, 0, 502, 748);
		self.controller2.view.frame = CGRectMake(522, 0, 502, 748);
		self.splitterView.frame = CGRectMake(502, 0, SPLITTER_LENGTH, 748);
	} else {
		self.controller1.view.frame = CGRectMake(0, 0, 768, 502);
		self.controller2.view.frame = CGRectMake(0, 522, 768, 502);
		self.splitterView.frame = CGRectMake(0, 502, 768, SPLITTER_LENGTH);
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
	BOOL isLand = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
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
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
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
	if ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)))
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
	if ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)))
		offset -= self.splitterView.frame.origin.x;
	else
		offset -= self.splitterView.frame.origin.y;
	[self splitterView:self.splitterView moveByOffset:offset - floorf(SPLITTER_LENGTH/2)];
}

@synthesize controller1=_controller1;
@synthesize controller2=_controller2;
@synthesize splitterView=_splitterView;
@synthesize minimumView1Size=_minimumView1Size;
@synthesize minimumView2Size=_minimumView2Size;
@synthesize delegate=_delegate;
@end
