//
//  SplitterView.h
//  CustomSplitView
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplitterView;

@protocol SplitterViewDelegate <NSObject>
-(void)splitterView:(SplitterView*)splitterView moveByOffset:(CGFloat)offset;

@end

@interface SplitterView : UIView
@property (nonatomic, weak) id<SplitterViewDelegate> delegate;
//for draging while in landscape
@property CGFloat minX;
@property CGFloat maxX;
//for dragging while in portrait
@property CGFloat minY;
@property CGFloat maxY;
@end
