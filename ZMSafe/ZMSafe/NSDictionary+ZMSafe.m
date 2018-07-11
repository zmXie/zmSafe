//
//  NSDictionary+ZMSafe.m
//  SwizzleProject
//
//  Created by CHT-Technology on 2017/4/25.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "NSDictionary+ZMSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSDictionary (ZMSafe)
static NSString *KDictionaryClass = @"__NSPlaceholderDictionary";

+(void)load
{
    NSLog(@"NSDictionary + load");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KDictionaryClass)
                                            srcSel:@selector(initWithObjects:forKeys:count:)
                                       swizzledSel:@selector(zm_safeInitWithObjects:forKeys:count:)];
    });
}

- (instancetype)zm_safeInitWithObjects:(id*)objects forKeys:(id*)keys count:(NSUInteger)cnt
{
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if(!keys[i]) keys[i] = @"";

        if(!objects[i]) objects[i] = @"";
    }
    return [self zm_safeInitWithObjects:objects forKeys:keys count:cnt];
}

@end
