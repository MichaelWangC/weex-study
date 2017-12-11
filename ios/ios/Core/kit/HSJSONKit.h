//
//  HSJSONKit.h
//  ios
//
//  Created by Michael on 2017/12/11.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSJSONKit : NSObject

@end

@interface NSString (HSJSONKitDeserializing)
- (id)objectFromJSONString;
//- (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
//- (id)mutableObjectFromJSONString;
//- (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end

@interface NSData (HSJSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromJSONData;
//- (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
//- (id)mutableObjectFromJSONData;
//- (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
//- (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end

////////////
#pragma mark Serializing methods
////////////

@interface NSString (HSJSONKitSerializing)
- (NSData *)JSONData;     // Invokes JSONDataWithOptions:JKSerializeOptionNone   includeQuotes:YES
- (NSString *)JSONString; // Invokes JSONStringWithOptions:JKSerializeOptionNone includeQuotes:YES
@end

@interface NSArray (HSJSONKitSerializing)
- (NSData *)JSONData;
- (NSString *)JSONString;
@end

@interface NSDictionary (HSJSONKitSerializing)
- (NSData *)JSONData;
- (NSString *)JSONString;
@end
