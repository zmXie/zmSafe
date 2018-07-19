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

//数组初始化类
static NSString *KInitArrayClass   = @"__NSPlaceholderArray";
//空元素数组类，空数组
static NSString *KEmptyArrayClass  = @"__NSArray0";
//单元素数组类，一个元素的数组
static NSString *KSingleArrayClass = @"__NSSingleObjectArrayI";
//多元素数组类，两个元素以上的数组
static NSString *KMultiArrayClass  = @"__NSArrayI";

#define KSelectorFromString(s1,s2) NSSelectorFromString([NSString stringWithFormat:@"%@%@",s1,s2])

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KInitArrayClass)
                                            srcSel:@selector(initWithObjects:count:)
                                       swizzledSel:@selector(zm_safeInitWithObjects:count:)];
        
        [self zm_arrayMethodSwizzleWithRealClass:KEmptyArrayClass prefix:@"zm_emptyArray"];
        [self zm_arrayMethodSwizzleWithRealClass:KSingleArrayClass prefix:@"zm_singleArray"];
        [self zm_arrayMethodSwizzleWithRealClass:KMultiArrayClass prefix:@"zm_multiArray"];
        
    });

}

+ (void)zm_arrayMethodSwizzleWithRealClass:(NSString *)realClass prefix:(NSString *)prefix
{
    
    [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                        srcSel:@selector(objectAtIndex:)
                                   swizzledSel:KSelectorFromString(prefix, @"ObjectAtIndex:")];
    
    [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                        srcSel:@selector(arrayByAddingObject:)
                                   swizzledSel:KSelectorFromString(prefix, @"ArrayByAddingObject:")];
    
    if (iOS11) {
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                            srcSel:@selector(objectAtIndexedSubscript:)
                                       swizzledSel:KSelectorFromString(prefix, @"ObjectAtIndexedSubscript:")];
    }
}

#pragma mark -- swizzled Methods
- (instancetype)zm_safeInitWithObjects:(id *)objects count:(NSUInteger)cnt
{
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (!objects[i]) objects[i] = @"";
    }
    return [self zm_safeInitWithObjects:objects count:cnt];
}

- (id)zm_emptyArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_emptyArrayObjectAtIndex:index];
}

- (id)zm_singleArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_singleArrayObjectAtIndex:index];
}

- (id)zm_multiArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    // NSLog(@"%@",NSStringFromClass(self.class));      //__NSArrayI
    // NSLog(@"%@",NSStringFromClass(self.superclass)); //NSArray
    // __NSArrayI是NSArray的子类
    // zm_multiArrayObjectAtIndex:是NSArray的方法,self是__NSArrayI的实例，子类调用父类的方法，没问题
    return [self zm_multiArrayObjectAtIndex:index];
}

//解决array[index] 字面量语法超出界限的bug
- (id)zm_emptyArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_emptyArrayObjectAtIndexedSubscript:index];
}

- (id)zm_singleArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_singleArrayObjectAtIndexedSubscript:index];
}

- (id)zm_multiArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self zm_multiArrayObjectAtIndexedSubscript:index];
}

- (NSArray*)zm_emptyArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self zm_emptyArrayArrayByAddingObject:anObject];
}

- (NSArray*)zm_singleArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self zm_singleArrayArrayByAddingObject:anObject];
}

- (NSArray*)zm_multiArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self zm_multiArrayArrayByAddingObject:anObject];
}

@end


