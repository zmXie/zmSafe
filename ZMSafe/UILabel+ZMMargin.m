//
//  UILabel+ZMMargin.m
//  ZMSafe
//
//  Created by xzm on 2018/7/5.
//  Copyright © 2018年 CHT-Technology. All rights reserved.
//

#import "UILabel+ZMMargin.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation UILabel (ZMMargin)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
         [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(textRectForBounds:limitedToNumberOfLines:) swizzledSel:@selector(zm_textRectForBounds:limitedToNumberOfLines:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(drawTextInRect:) swizzledSel:@selector(zm_drawTextInRect:)];
       
    });
}

- (CGRect)zm_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [self zm_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.textEdgeInset) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.textEdgeInset.left;
    rect.origin.y -= self.textEdgeInset.top;
    rect.size.width += (self.textEdgeInset.left + self.textEdgeInset.right);
    rect.size.height += (self.textEdgeInset.top + self.textEdgeInset.bottom);
    return rect;
}

- (void)zm_drawTextInRect:(CGRect)rect
{
    [self zm_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInset)];
}

- (UIEdgeInsets)textEdgeInset
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if(value)
    {
        return value.UIEdgeInsetsValue;
    }
    return UIEdgeInsetsZero;
}

- (void)setTextEdgeInset:(UIEdgeInsets)textEdgeInset
{
    objc_setAssociatedObject(self, @selector(textEdgeInset), [NSValue valueWithUIEdgeInsets:textEdgeInset], OBJC_ASSOCIATION_ASSIGN);
}

@end
