//
//  YLPDFStream.m
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import "YLPDFStream.h"
#import "YLPDFUtil.h"

@implementation YLPDFStream

+ (YLPDFStream *) pdfStreamWithCGPDFStream: (CGPDFStreamRef)stream
{
    return [[[YLPDFStream alloc] initWithCGPDFStream: stream] autorelease];
}

- (id) initWithCGPDFStream: (CGPDFStreamRef)stream
{
    self = [super init];
    if (self) {
        _stream = stream;
    }
    return self;
}

- (void) dealloc
{
    _stream = NULL;
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat: @"<< dict = %@, length = %lld >>", self.dictionary, [self.data length]];
}

- (NSDictionary *) dictionary
{
    return YLGetDictionaryFromCGPDFDictionary(CGPDFStreamGetDictionary(_stream));
}

- (NSData *) data
{
    NSData *data = (NSData *)CGPDFStreamCopyData(_stream, CGPDFDataFormatRaw);
    return [data autorelease];
}

@end
