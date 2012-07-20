//
//  AMResizableSplitViewController.h
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMResizableSplitterView;

@interface AMResizableSplitViewController : UIViewController

//the view controllers displayed in the split view
@property (nonatomic) UIViewController *controller1;
@property (nonatomic) UIViewController *controller2;

//the splitter view
@property (nonatomic) AMResizableSplitterView *splitterView;

//the midpoint of the splitter view (x/y depending on orientation)
@property (nonatomic) CGFloat splitterPosition;

//the minimum size (width used when landscape, height used when portrait) for the first view. default is 100, 100
@property (nonatomic) CGSize minimumView1Size;

//the minimum size (width used when landscape, height used when portrait) for the second view. default is 100, 100
@property (nonatomic) CGSize minimumView2Size;

// designated initializer
-(id)init;

-(void)setSplitterPosition:(CGFloat)splitterPosition animated:(BOOL)animated;
@end
