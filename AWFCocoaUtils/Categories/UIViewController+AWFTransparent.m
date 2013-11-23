//
//  UIViewController+AWFPresentTransparent.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import <objc/runtime.h>

#import "UIViewController+AWFTransparent.h"

@implementation UIViewController (AWFTransparent)

static char const * const
    AWFTransparentViewControllerKey =
        "AWFTransparentViewController";

static const CGFloat AnimationDuration = 0.3f;

- (UIViewController *)transparentViewController
{
    return objc_getAssociatedObject(
        self,
        AWFTransparentViewControllerKey);
}

- (void)setTransparentViewController:(UIViewController *)transparentViewController
{
    objc_setAssociatedObject(
        self,
        AWFTransparentViewControllerKey,
        transparentViewController,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)alpha
{
    return self.transparentViewController.view.alpha;
}

- (void)setAlpha:(CGFloat)alpha
{
    UIView *view = self.transparentViewController.view;
    
    view.alpha = alpha;
    view.opaque = NO;
    
    for (UIView *subview in view.subviews)
    {
        subview.alpha = alpha;
        subview.opaque = NO;
    }
}

- (CGRect)frameWhenFullyPresented
{
    UIView *view = self.transparentViewController.view;
    
    return CGRectMake(0,
                      0,
                      view.frame.size.width,
                      view.frame.size.height);
}

- (CGRect)frameWhenFullyDismissed
{
    UIView *view = self.transparentViewController.view;
    
    return CGRectMake(0 - view.frame.size.width,
                      0 - view.frame.size.width,
                      view.frame.size.width,
                      view.frame.size.height);
}

- (void)performTransitionForPresentWithCompletion:(void (^)(void))completion animated:(BOOL)animated
{
    if (self.modalTransitionStyle != UIModalTransitionStyleCoverVertical)
    {
        NSLog(@"Warning!!! presentTransparentViewController only supports modalTransitionStyle==UIModalTransitionStyleCoverVertical");
    }
    
    UIView *view = self.transparentViewController.view;
    
    view.hidden = NO;
    
    if (animated)
    {
        [UIView beginAnimations:@"present" context:(__bridge void *)(completion)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationDidStopSelector:@selector(presentAnimationDidStop:finished:context:)];
    }
    
    view.frame = [self frameWhenFullyPresented];
    
    if (animated)
    {
        [UIView commitAnimations];
    }
    else
    {
        [self presentAnimationDidStop:nil finished:[NSNumber numberWithBool:YES] context:(__bridge void *)(completion)];
    }
}

- (void)performTransitionForDismissWithCompletion:(void (^)(void))completion animated:(BOOL)animated
{
    UIView *view = self.transparentViewController.view;
    
    if (animated)
    {
        [UIView beginAnimations:@"dismiss" context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:AnimationDuration];
        [UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop:finished:context:)];
    }
    
    view.frame = [self frameWhenFullyDismissed];
    
    if (animated)
    {
        [UIView commitAnimations];
    }
    else
    {
        [self dismissAnimationDidStop:nil finished:[NSNumber numberWithBool:YES] context:(__bridge void *)(completion)];
    }
}

- (void)presentAnimationDidStop:(NSString *)animationID
                       finished:(NSNumber *)finished
                        context:(void *)context
{
    void (^completion) (void) = (__bridge void (^)(void))(context);
    if (completion)
    {
        completion();
    }
}

- (void)dismissAnimationDidStop:(NSString *)animationID
                       finished:(NSNumber *)finished
                        context:(void *)context
{
    UIView *view = self.transparentViewController.view;
    if (view) view.hidden = YES;
    
    void (^completion) (void) = (__bridge void (^)(void))(context);
    if (completion)
    {
        completion();
    }
    
    self.alpha = 1.0f;
    self.transparentViewController = nil;
}

- (void)presentTransparentViewController:(UIViewController *)viewController
                                animated:(BOOL)animated
                                   alpha:(CGFloat)alpha
                              completion:(void (^)(void))completion
{
    // Save the view controller so we have access to it when we dismiss
    self.transparentViewController = viewController;
    
    // Set the transparency
    self.alpha = alpha;
    
    // Perform the transition
    [self performTransitionForPresentWithCompletion:completion animated:animated];
}

- (void)dismissTransparentViewControllerAnimated:(BOOL)animated
                                      completion:(void (^)(void))completion
{
    if (!self.transparentViewController) return;
    
    // Perform the transition
    [self performTransitionForDismissWithCompletion:completion animated:animated];
}

@end
