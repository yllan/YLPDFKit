//
//  YLPDFPage.h
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YLPDFPage : NSObject {
@private
    CGPDFPageRef _page;
}

+ (YLPDFPage *) pageWithCGPDFPage: (CGPDFPageRef)page;
- (id) initWithCGPDFPage: (CGPDFPageRef)page;

@property (readonly) NSArray *contents;
@property (readonly) NSDictionary *resource;
@end
