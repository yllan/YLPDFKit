//
//  YLPDFUtil.c
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import "YLPDFUtil.h"
#import "YLPDFStream.h"

void dumpDictionary(const char *key, CGPDFObjectRef object, void *info);

id dumpObject(CGPDFObjectRef object) 
{
    CGPDFObjectType type = CGPDFObjectGetType(object);
    switch(type) {
        case kCGPDFObjectTypeBoolean:
        {
            CGPDFBoolean pdfbool;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeBoolean, &pdfbool)) {
                return pdfbool ? @"True" : @"False";
            }
        }
            break;
            
        case kCGPDFObjectTypeInteger:
        {
            CGPDFInteger pdfint;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeInteger, &pdfint)) {
                return [NSNumber numberWithLong: pdfint];
            }
        }
            break;
            
        case kCGPDFObjectTypeReal:
        {
            CGPDFReal pdfreal;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeReal, &pdfreal))
                return [NSNumber numberWithFloat: pdfreal];
        }
            break;
            
        case kCGPDFObjectTypeName:
        {
            const char *name;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeName, &name))
                return [NSString stringWithUTF8String: name];
        }
            break;
            
        case kCGPDFObjectTypeString:
        {
            CGPDFStringRef pdfstr;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeString, &pdfstr)) {
                CFStringRef str = CGPDFStringCopyTextString(pdfstr);
                return [(NSString *)str autorelease];
            }
        }
            break;
            
        case kCGPDFObjectTypeArray:
        {
            CGPDFArrayRef array;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeArray, &array)) {
                NSMutableArray *entries = [NSMutableArray array];
                NSUInteger count = CGPDFArrayGetCount(array);
                
                for (NSUInteger i = 0; i < count; i++) {
                    CGPDFObjectRef entry;
                    CGPDFArrayGetObject(array, i, &entry);
                    [entries addObject: dumpObject(entry)];
                }
                return entries;
            }
        }
            break;
            
        case kCGPDFObjectTypeDictionary:
        {
            CGPDFDictionaryRef dict;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeDictionary, &dict))
            {
                NSMutableDictionary *results = [NSMutableDictionary dictionary];
                CGPDFDictionaryApplyFunction(dict, dumpDictionary, results);
                return results;
            }
        }
            break;
            
        case kCGPDFObjectTypeNull:
        {
            return [NSNull null];
        }
            break;
            
        case kCGPDFObjectTypeStream:
        {
            CGPDFStreamRef pdfStream;
            CGPDFObjectGetValue(object, kCGPDFObjectTypeStream, &pdfStream);
            YLPDFStream *stream = [YLPDFStream pdfStreamWithCGPDFStream: pdfStream];
            return stream;
        }
            break;
    }
    return nil;
}

void dumpDictionary(const char *key, CGPDFObjectRef object, void *info)
{
    NSMutableDictionary *results = (NSMutableDictionary *)info;
    NSString *keyString = [NSString stringWithFormat: @"%s", key];
    if ([@"Parent" caseInsensitiveCompare: [NSString stringWithUTF8String: key]] == NSOrderedSame) {
        // Don't add parent
    } else {
        [results setValue: dumpObject(object) forKey: keyString];
    }
}

NSDictionary *YLGetDictionaryFromCGPDFDictionary(CGPDFDictionaryRef dictionary) 
{
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    CGPDFDictionaryApplyFunction(dictionary, dumpDictionary, results);
    return results;
}

id YLGetObjectFromCGPDFObject(CGPDFObjectRef object)
{
    return dumpObject(object);
}