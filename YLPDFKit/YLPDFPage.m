//
//  YLPDFPage.m
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import "YLPDFPage.h"
#import "YLPDFStream.h"
#import "YLPDFUtil.h"

@implementation YLPDFPage

+ (YLPDFPage *) pageWithCGPDFPage: (CGPDFPageRef)page
{
    return [[[YLPDFPage alloc] initWithCGPDFPage: page] autorelease];
}

- (id) initWithCGPDFPage: (CGPDFPageRef)page
{
    self = [super init];
    if (self) {
        _page = CGPDFPageRetain(page);
        
    }    
    return self;
}

- (void) dealloc
{
    CGPDFPageRelease(_page);
    [super dealloc];
}

- (NSArray *) contents
{
    NSMutableArray *results = [NSMutableArray array];
    CGPDFContentStreamRef cs = CGPDFContentStreamCreateWithPage(_page);
    CFArrayRef streams = CGPDFContentStreamGetStreams(cs);
    CFIndex count = CFArrayGetCount(streams);
    
    for (CFIndex index = 0; index < count; index++) {
        CGPDFStreamRef stream = (CGPDFStreamRef)CFArrayGetValueAtIndex(streams, index);
        [results addObject: [YLPDFStream pdfStreamWithCGPDFStream: stream]];
    }
    CGPDFContentStreamRelease(cs);
    return results;
}

- (NSDictionary *) resource
{    
    NSDictionary *dictionary = YLGetDictionaryFromCGPDFDictionary(CGPDFPageGetDictionary(_page));
    return [dictionary valueForKey: @"Resources"];
}
@end
