//
//  UINavigationController+AJIsPop.h
//  PreventPop
//
//  Created by mac on 2017/12/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Protocol

@protocol UINavigationControllerShouldPop <NSObject>

@optional
//prevent PopViewController With Back Button
- (BOOL)navigationControllerShouldPop:(UINavigationController *)navigationController;
//prevent PopViewController With Gesture
- (BOOL)navigationControllerShouldStartInteractivePopGestureRecognize:(UINavigationController *)navigationController;

@end

@interface UINavigationController (AJIsPop)<UIGestureRecognizerDelegate>

@end


