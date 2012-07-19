//
//  ViewController.m
//  CustomSplitView
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "ViewController.h"
#import "SplitterView.h"

@interface ViewController ()
@property (nonatomic) SplitterView *dividerView;
@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.dividerView = [[SplitterView alloc] initWithFrame:CGRectMake(502, 0, 20, 748)];
	[self.view addSubview:self.dividerView];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	//we do the layout our selves
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		[self adjustforLandscape];
	} else {
		[self adjustForPortrait];
	}
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^{
		if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
			[self adjustforLandscape];
		else
			[self adjustForPortrait];
	}];
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
	self.controller2.view.frame = CGRectMake(522, 0, 502, 768);
	self.dividerView.frame = CGRectMake(502, 0, 20, 748);
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

@end
