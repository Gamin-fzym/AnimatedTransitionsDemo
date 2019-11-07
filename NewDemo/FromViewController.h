//
//  FromViewController.h
//  NewDemo
//
//  Created by shuangba on 2019/10/28.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GATransitionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FromViewController : GATransitionViewController

@property (weak, nonatomic) IBOutlet UIButton *navBut;
@property (weak, nonatomic) IBOutlet UIButton *modelBut;

@end

NS_ASSUME_NONNULL_END
