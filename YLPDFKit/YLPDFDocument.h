//
//  YLPDFDocument.h
//  HypoRules
//
//  Created by Yung-Luen Lan on 4/6/11.
//  Copyright 2011 hypo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YLPDFDocument : NSObject {
@private
    NSArray *_pages;
    CGPDFDocumentRef _pdf;
}

- (id) initWithPath: (NSString *)path;

@property (readonly) NSArray *pages;

@end
