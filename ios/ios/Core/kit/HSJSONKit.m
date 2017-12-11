//
//  HSJSONKit.m
//  ios
//
//  Created by Michael on 2017/12/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import "HSJSONKit.h"

@implementation HSJSONKit

@end

@implementation NSString (HSJSONKitDeserializing)
- (id)objectFromJSONString{
    NSError* error;
    id obj = [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return obj;
}
//- (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
//- (id)mutableObjectFromJSONString;
//- (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end

@implementation NSData (HSJSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData{
    NSError* error;
    id obj = [NSJSONSerialization JSONObjectWithData: self options:0 error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
    }
    return obj;
}
//- (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
//- (id)mutableObjectFromJSONData;
//- (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end

////////////
#pragma mark Serializing methods
////////////

@implementation NSString (HSJSONKitSerializing)

- (NSData *)JSONData{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return data;
}

- (NSString *)JSONString{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return  [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
}

@end

@implementation NSArray (HSJSONKitSerializing)

- (NSData *)JSONData{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return data;
}

- (NSString *)JSONString{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return  [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (HSJSONKitSerializing)

- (NSData *)JSONData{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return data;
}

- (NSString *)JSONString{
    NSError* error;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON Error:%@", [error description]);
        return nil;
    }
    return  [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
}

@end
