//  
//  GATransitionAnimate.h
//  NewDemo
//
//  Created by shuangba on 2019/11/6.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, GATransitionAnimateType)  {
    NoneAnimateType,    // 没有动画
    FadeAnimateType,    // 渐显动画
    SwipeAnimateType,   // 侧滑动画 需要在UIScreenEdgePanGestureRecognizer中调用
    PopupAnimateType,   // 弹性Pop动画
    CircleAnimateType,  // 扩散圆动画
    CardAnimateType,    // 底部卡片动画 使用时需要modalPresentationStyle = UIModalPresentationCustom
    OpenAnimateType     // Push/Pop开门动画 需要在导航的Push/Pop中调用
};

@interface GATransitionAnimate : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) GATransitionAnimateType animateType;
// OpenAnimateType时使用
@property (nonatomic, assign) BOOL isPop;

@end

NS_ASSUME_NONNULL_END
