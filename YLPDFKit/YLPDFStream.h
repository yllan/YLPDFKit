//
//  YLPDFStream.h
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YLPDFStream : NSObject {
@private
    CGPDFStreamRef _stream;
}

+ (YLPDFStream *) pdfStreamWithCGPDFStream: (CGPDFStreamRef)stream;
- (id) initWithCGPDFStream: (CGPDFStreamRef)stream;

@property (readonly) NSDictionary *dictionary;
@property (readonly) NSData *data;

@end
