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

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self zm_swizzleInstanceMethodWithSrcClass:NSClassFromString(KDictionaryClass)
                                            srcSel:@selector(initWithObjects:forKeys:count:)
                                       swizzledSel:@selector(zm_safeInitWithObjects:forKeys:count:)];
    });
}

- (instancetype)zm_safeInitWithObjects:(id*)objects forKeys:(id*)keys count:(NSUInteger)cnt{
    
    //当遍历到的value或key为nil的时候，就按当前的cnt来截取
    NSUInteger actuallyCnt = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }
        actuallyCnt++;
    }
    
    return [self zm_safeInitWithObjects:objects forKeys:keys count:actuallyCnt];
}

@end
