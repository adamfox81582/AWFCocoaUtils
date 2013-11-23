//
//  UIViewController+AWFPresentTransparent.h
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

@interface UIViewController (AWFTransparent)

@property (nonatomic, strong) UIViewController *transparentViewController;
@property (nonatomic) CGFloat alpha;

- (void)presentTransparentViewController:(UIViewController *)viewController
                                animated:(BOOL)animated
                                   alpha:(CGFloat)alpha
                              completion:(void (^)(void))completion;

- (void)dismissTransparentViewControllerAnimated:(BOOL)animated
                                      completion:(void (^)(void))completion;

@end
