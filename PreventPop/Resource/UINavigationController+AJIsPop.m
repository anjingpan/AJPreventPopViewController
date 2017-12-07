//
//  UINavigationController+AJIsPop.m
//  PreventPop
//
//  Created by mac on 2017/12/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UINavigationController+AJIsPop.h"
#import <objc/runtime.h>

#pragma mark - Const
static void *DelegateKey = &DelegateKey;

#pragma mark - Property

@interface UINavigationController ()

    @property (nonatomic, weak) id<UIGestureRecognizerDelegate> gestureDeleagte;

@end

@implementation UINavigationController (AJIsPop)

#pragma mark - Life Cycle
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(viewDidLoad) WithMethod:@selector(AJ_viewDidLoad)];
        [self exchangeMethod:@selector(navigationBar:shouldPopItem:) WithMethod:@selector(AJ_navigationBar:shouldPopItem:)];
    });
    
}

- (void)AJ_viewDidLoad{
    [self AJ_viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (BOOL)AJ_navigationBar:(UINavigationBar *)bar shouldPopItem:(UINavigationItem *)item{
    
    UIViewController *vc = self.topViewController;
    if (item != vc.navigationItem) {
        return true;
    }
    
    if ([vc respondsToSelector:@selector(navigationControllerShouldPop:)]){
        //修复返回按钮变灰
        for (UIView *subView in self.navigationBar.subviews) {
            if (subView.alpha > 0 && subView.alpha < 1) {
                [UIView animateWithDuration:0.25 animations:^{
                    subView.alpha = 1;
                }];
            }
        }
        if ([(id<UINavigationControllerShouldPop>)vc navigationControllerShouldPop:self]) {
            return [self AJ_navigationBar:bar shouldPopItem:item];
        }else{
            return false;
        }
    }else{
        return [self AJ_navigationBar:bar shouldPopItem:item];
    }
}


+ (void)exchangeMethod: (SEL)sel1 WithMethod: (SEL)sel2 {
    Class class = [self class];
    
    SEL originalSelector = sel1;
    SEL swizzledSelector = sel2;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(swizzledMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Getter && Setter
- (void)setGestureDeleagte:(id<UIGestureRecognizerDelegate>)gestureDeleagte{
    objc_setAssociatedObject(self, &DelegateKey, self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UIGestureRecognizerDelegate>)gestureDeleagte{
    return objc_getAssociatedObject(self, &DelegateKey);
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        UIViewController *vc = self.topViewController;
        if ([vc respondsToSelector:@selector(navigationControllerShouldStartInteractivePopGestureRecognize:)]) {
            if (![(id<UINavigationControllerShouldPop>)vc navigationControllerShouldStartInteractivePopGestureRecognize:self])  {
                return false;
            }
        }
        [self.gestureDeleagte gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        [self.gestureDeleagte gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        [self.gestureDeleagte gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return true;
}


@end


