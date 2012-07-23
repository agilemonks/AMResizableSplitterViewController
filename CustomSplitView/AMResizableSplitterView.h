//
//  AMResizableSplitterView.h
//
//  Created by Mark Lilback on 7/19/12.
//  Copyright (c) 2012 Agile Monks, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMResizableSplitterView;

@protocol AMResizableSplitterViewDelegate <NSObject>
-(void)splitterViewWillStartTrackingTouches:(AMResizableSplitterView*)splitterView;
-(void)splitterView:(AMResizableSplitterView*)splitterView moveByOffset:(CGFloat)offset;
-(void)splitterViewDidEndTrackingTouches:(AMResizableSplitterView*)splitterView;

@end

@interface AMResizableSplitterView : UIView
@property (nonatomic, weak) id<AMResizableSplitterViewDelegate> delegate;
@end
