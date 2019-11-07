//
//  GATransitionInteractive.h
//  NewDemo
//
//  Created by shuangba on 2019/11/6.
//  Copyright © 2019 shuangba. All rights reserved.
//  SwipeAnimateType时使用

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GATransitionInteractive : UIPercentDrivenInteractiveTransition

// NS_DESIGNATED_INITIALIZER关键字 意思是最终被指定的初始化方法，在interface只能用一次而且必须以init开头的方法。
- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

// NS_UNAVAILABLE 用来修饰所有的方法，表示这个类的这个方法是不可用的。
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
