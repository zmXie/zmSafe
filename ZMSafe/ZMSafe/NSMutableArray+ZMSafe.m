//
//  NSMutableArray+ZMSafe.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/25.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSMutableArray+ZMSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableArray (ZMSafe)
static NSString *KMArrayClass = @"__NSArrayM";

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(addObject:)
                                           swizzledSel:@selector(zm_safeAddObject:)];
            
            [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(insertObject:atIndex:)
                                           swizzledSel:@selector(zm_safeInsertObject:atIndex:)];
            
            [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(removeObjectAtIndex:)
                                           swizzledSel:@selector(zm_safeRemoveObjectAtIndex:)];
            
            [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(replaceObjectAtIndex:withObject:)
                                           swizzledSel:@selector(zm_safeReplaceObjectAtIndex:withObject:)];
            
            [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(objectAtIndex:)
                                           swizzledSel:@selector(zm_safeObjectAtIndex:)];
            
            if (iOS11)
            {
                [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                    srcSel:@selector(objectAtIndexedSubscript:)
                                               swizzledSel:@selector(zm_safeObjectAtIndexedSubscript:)];
            }
        }
        
    });
}

- (void)zm_safeAddObject:(id)anObject
{
    @autoreleasepool
    {
        if(!anObject)return;
        
        [self zm_safeAddObject:anObject];
    }
    
}

- (void)zm_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if(!anObject || index > self.count)return;
        [self zm_safeInsertObject:anObject atIndex:index];
    }
}

- (void)zm_safeRemoveObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if(index >= self.count) return;
        [self zm_safeRemoveObjectAtIndex:index];
    }
}

- (void)zm_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    @autoreleasepool
    {
        if(index >= self.count || !anObject) return;
        [self zm_safeReplaceObjectAtIndex:index withObject:anObject];
    }
}

- (id)zm_safeObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count) return nil;
        return [self zm_safeObjectAtIndex:index];
    }
}

- (id)zm_safeObjectAtIndexedSubscript:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count) return nil;
        return [self zm_safeObjectAtIndexedSubscript:index];
    }
}


@end



