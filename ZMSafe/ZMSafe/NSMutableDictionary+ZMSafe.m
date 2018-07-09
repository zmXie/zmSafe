//
//  NSMutableDictionary+ZMSafe.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/26.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSMutableDictionary+ZMSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableDictionary (ZMSafe)
static NSString *KMDictionaryClass = @"__NSDictionaryM";

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMDictionaryClass)
                                            srcSel:@selector(setObject:forKey:)
                                       swizzledSel:@selector(zm_safeSetObject:forKey:)];
    });
}
- (void)zm_safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(!anObject || !aKey) return;
    [self zm_safeSetObject:anObject forKey:aKey];
}

@end
