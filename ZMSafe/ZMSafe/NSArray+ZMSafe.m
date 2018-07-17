//
//  NSArray+ZMSafe.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/25.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSArray+ZMSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSArray (ZMSafe)
static NSString *KArrayClass = @"__NSArrayI";
static NSString *KArrayInitClass = @"__NSPlaceholderArray111";


+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KArrayInitClass)
                                            srcSel:@selector(initWithObjects:count:)
                                       swizzledSel:@selector(zm_safeInitWithObjects:count:)];
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KArrayClass)
                                            srcSel:@selector(objectAtIndex:)
                                       swizzledSel:@selector(zm_safeObjectAtIndex:)];
        if (iOS11) {
            [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KArrayClass)
                                                srcSel:@selector(objectAtIndexedSubscript:)
                                           swizzledSel:@selector(zm_safeObjectAtIndexedSubscript:)];
        }
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KArrayClass)
                                            srcSel:@selector(arrayByAddingObject:)
                                       swizzledSel:@selector(zm_safeArrayByAddingObject:)];
        
    });

}

- (instancetype)zm_safeInitWithObjects:(id *)objects count:(NSUInteger)cnt
{
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (!objects[i]) objects[i] = @"";
    }
    return [self zm_safeInitWithObjects:objects count:cnt];
}

- (id)zm_safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_safeObjectAtIndex:index];
}

//解决array[index] 字面量语法超出界限的bug
- (id)zm_safeObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_safeObjectAtIndexedSubscript:index];
}

- (NSArray*)zm_safeArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self zm_safeArrayByAddingObject:anObject];
}

@end


