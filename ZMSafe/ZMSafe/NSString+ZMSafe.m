//
//  NSString+ZMSafe.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/26.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSString+ZMSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSString (ZMSafe)
static NSString *KStringClass = @"__NSCFString";

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(characterAtIndex:)
                                       swizzledSel:@selector(zm_safeCharacterAtIndex:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringWithRange:)
                                       swizzledSel:@selector(zm_safeSubstringWithRange:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringFromIndex:)
                                       swizzledSel:@selector(zm_safeSubstringFromIndex:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringToIndex:)
                                       swizzledSel:@selector(zm_safeSubstringToIndex:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(rangeOfString:)
                                       swizzledSel:@selector(zm_safeRangeOfString:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(doubleValue)
                                       swizzledSel:@selector(zm_doubleValue)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(floatValue)
                                       swizzledSel:@selector(zm_floatValue)];
        
    });
}

- (unichar)zm_safeCharacterAtIndex:(NSUInteger)index{
    if(index >= self.length) return 0;
    
    return [self zm_safeCharacterAtIndex:index];
}

- (NSString *)zm_safeSubstringFromIndex:(NSUInteger)from{
    if(from > self.length) return @"";
    
    return [self zm_safeSubstringFromIndex:from];
    
}

- (NSString *)zm_safeSubstringToIndex:(NSUInteger)to{
    if(to > self.length) return self;
    
    return [self zm_safeSubstringToIndex:to];
    
}

- (NSString *)zm_safeSubstringWithRange:(NSRange)range{
    if(range.location + range.length > self.length) return @"";
    
    return [self zm_safeSubstringWithRange:range];
    
}

- (NSRange)zm_safeRangeOfString:(NSString *)searchString{
    if(!searchString) return NSMakeRange(0, 0);
    
    return [self zm_safeRangeOfString:searchString];
}

- (double)zm_doubleValue{
    
    if ([self rangeOfString:@","].location != NSNotFound) {
       return [[[self class] stringDeleteString:self] zm_doubleValue];
    }
    
    return [self zm_doubleValue];
}

- (float)zm_floatValue{
    if ([self rangeOfString:@","].location != NSNotFound) {
        return [[[self class] stringDeleteString:self] zm_floatValue];
    }
    
    return [self zm_floatValue];
}

//删除中间的，%
+(NSString *)stringDeleteString:(NSString *)str;
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ( c == ',' || c == '%') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}

@end
