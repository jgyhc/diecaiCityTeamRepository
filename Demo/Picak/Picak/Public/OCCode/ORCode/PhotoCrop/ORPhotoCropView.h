//
//  ORPhotoCropView.h
//  KaDian
//
//  Created by 欧阳荣 on 2019/10/28.
//  Copyright © 2019 Kadian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ORPhotoCropView : UIView
@property (nonatomic) CGFloat resizeWHScale;

@property (nonatomic, copy) void(^didCropImage)(UIImage *image);

- (void)or_setUpUIWithImage:(UIImage *)image;

- (void)or_show;
- (void)or_hide;
@end

NS_ASSUME_NONNULL_END
