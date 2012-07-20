//
//  ViewController.h
//  CustomSplitView
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic) UIViewController *controller1;
@property (nonatomic) UIViewController *controller2;
@property (nonatomic) CGFloat splitterPosition;

-(void)setSplitterPosition:(CGFloat)splitterPosition animated:(BOOL)animated;
@end
