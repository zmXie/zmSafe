//
//  NSMutableString+ZMSafe.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/26.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSMutableString+ZMSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableString (ZMSafe)
static NSString *KMStringClass = @"__NSCFConstantString";

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(replaceCharactersInRange:withString:)
                                       swizzledSel:@selector(zm_safeReplaceCharactersInRange:withString:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(insertString:atIndex:)
                                       swizzledSel:@selector(zm_safeInsertString:atIndex:)];

        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(deleteCharactersInRange:)
                                       swizzledSel:@selector(zm_safeDeleteCharactersInRange:)];

        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(appendString:)
                                       swizzledSel:@selector(zm_safeAppendString:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(setString:)
                                       swizzledSel:@selector(zm_safeSetString:)];
    });
}

- (void)zm_safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString{
    if(range.location + range.length > self.length || !aString) return;
    
    [self zm_safeReplaceCharactersInRange:range withString:aString];
}

- (void)zm_safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc{
    if (!aString || loc > self.length) return;
    
    [self zm_safeInsertString:aString atIndex:loc];
}

- (void)zm_safeDeleteCharactersInRange:(NSRange)range{
    if(range.location + range.length > self.length) return;
    
    [self zm_safeDeleteCharactersInRange:range];
}

- (void)zm_safeAppendString:(NSString *)aString{
    if(!aString) return;
    
    [self zm_safeAppendString:aString];
}

- (void)zm_safeSetString:(NSString *)aString{
    if(!aString) return;
    
    [self zm_safeSetString:aString];
}

@end
