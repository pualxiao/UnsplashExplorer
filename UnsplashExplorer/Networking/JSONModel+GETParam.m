//
//  JSONModel+GETParam.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//


#import "JSONModel+GETParam.h"

@implementation JSONModel (GETParam)


- (NSString *)toGETParamString
{
    NSMutableString *strParam = [[NSMutableString alloc] init];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (u_int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        id value = [self valueForKey:name];
        
        value = [self transfer2String:value];
        if (value && (![value isKindOfClass:[NSString class]] || [value length] > 0)) {
            if (i == 0) {
                [strParam appendFormat:@"%@=%@", name, value];
            } else {
                [strParam appendFormat:@"&%@=%@", name, value];
            }
        }
    }
    return strParam;
}


- (NSString *)transfer2String:(id)obj {
    if (!obj) {
        return @"";
    }
    if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return [NSString stringWithFormat:@"%@", obj];
    }
}

@end
