//
//  YLPDFDocument.m
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import "YLPDFDocument.h"
#import "YLPDFPage.h"

@implementation YLPDFDocument
@synthesize pages = _pages;

- (id) initWithPath: (NSString *)path
{
    self = [super init];
    if (self != nil) {
        CGDataProviderRef provider = CGDataProviderCreateWithFilename([path UTF8String]);
        if (provider == NULL) {
            [self release];
            return nil;
        }
        _pdf = CGPDFDocumentCreateWithProvider(provider);
        if (_pdf == NULL) {
            [self release];
            return nil;
        }
        
        NSUInteger pageCount = CGPDFDocumentGetNumberOfPages(_pdf);
        NSMutableArray *pages = [NSMutableArray arrayWithCapacity: pageCount];

        for (NSUInteger index = 1; index <= pageCount; index++) {
            [pages addObject: [YLPDFPage pageWithCGPDFPage: CGPDFDocumentGetPage(_pdf, index)]];
        }
        
        _pages = [pages copy];
        CGDataProviderRelease(provider);
    }
    return self;
}

- (void) dealloc
{
    CGPDFDocumentRelease(_pdf);
    [_pages release], _pages = nil;
    [super dealloc];
}

@end
