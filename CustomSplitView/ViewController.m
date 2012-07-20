//
//  ViewController.m
//  CustomSplitView
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "ViewController.h"
#import "SplitterView.h"

@interface SVCView : UIView
@end

@interface ViewController () <SplitterViewDelegate> {
	BOOL _handlingMove;
}
@property (nonatomic) SplitterView *dividerView;
@property (nonatomic) UIView *view1;
@property (nonatomic) UIView *view2;
@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.dividerView = [[SplitterView alloc] initWithFrame:CGRectMake(502, 0, 20, 748)];
	self.dividerView.delegate = self;
	[self.view addSubview:self.dividerView];
	self.dividerView.minX = 100;
	self.dividerView.minY = 100;
	self.dividerView.maxX = 900;
	self.dividerView.maxY = 800;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^{
		[self rotateChildren:toInterfaceOrientation];
	}];
}

-(void)rotateChildren:(UIInterfaceOrientation)destOrientation
{
	BOOL toLand = UIInterfaceOrientationIsLandscape(destOrientation);
	CGRect dividerFrame = self.dividerView.frame;
	CGRect r1 = self.controller1.view.frame;
	CGRect r2 = self.controller2.view.frame;
	//r1 always has the same adjustment -- just swap width and height
	CGFloat tmp = r1.size.height;
	r1.size.height = r1.size.width;
	r1.size.width = tmp;
	tmp = dividerFrame.origin.y;
	dividerFrame.origin.y = dividerFrame.origin.x;
	dividerFrame.origin.x = tmp;
	tmp = dividerFrame.size.height;
	dividerFrame.size.height = dividerFrame.size.width;
	dividerFrame.size.width = tmp;
	tmp = r2.origin.y;
	r2.origin.y = r2.origin.x;
	r2.origin.x = tmp;
	tmp = r2.size.height;
	r2.size.height = r2.size.width;
	r2.size.width = tmp;
	if (toLand) {
		r1.size.height -= 20;
		r2.size.height -= 20;
		dividerFrame.size.height -= 20;
	} else {
		r1.size.width += 20;
		r2.size.width += 20;
		dividerFrame.size.width += 20;
	}
	self.dividerView.frame = dividerFrame;
	self.controller1.view.frame = r1;
	self.controller2.view.frame = r2;
}

-(void)adjustToDefaultFrames
{
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		[self adjustforLandscape];
	else
		[self adjustForPortrait];
}

-(void)adjustForPortrait
{
	self.controller1.view.frame = CGRectMake(0, 0, 768, 502);
	self.controller2.view.frame = CGRectMake(0, 522, 768, 502);
	self.dividerView.frame = CGRectMake(0, 502, 768, 20);
}

-(void)adjustforLandscape
{
	self.controller1.view.frame = CGRectMake(0, 0, 502, 748);
	self.controller2.view.frame = CGRectMake(522, 0, 502, 748);
	self.dividerView.frame = CGRectMake(502, 0, 20, 748);
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self adjustToDefaultFrames];
}

-(void)splitterView:(SplitterView*)splitterView moveByOffset:(CGFloat)offset
{
	CGRect dividerRect = splitterView.frame;

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

-(void)setSplitterPosition:(CGFloat)splitterPosition animated:(BOOL)animated
{
	_splitterPosition = splitterPosition;
}

@end

@implementation SVCView

-(void)layoutSubviews
{
	
}

@end
