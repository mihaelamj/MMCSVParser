//
//  CSVParser.m
//  MMJCSVParser
//
//  Created by Mihaela Mihaljević Jakić on 6/27/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "CSVParser.h"

@implementation CSVParser

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)parse
{
    NSString *stringToParse = [self.dataSource stringToParse:self];
    if (!stringToParse) return;    
    NSArray *lines = [stringToParse componentsSeparatedByString:@"\n"];
    
    // tell delegate the parsing has started
    if ([self.delegate respondsToSelector:@selector(parserDidStartParsing:linesNo:)]) {
        [self.delegate parserDidStartParsing:self linesNo:lines.count];
    }
    
    NSUInteger i = 0;
    
    for (NSString *line in lines){
        [self parseLine:line atIndex:i];
        i++;
        // check if we should parse line at index
        if ([self.delegate respondsToSelector:@selector(parser:shouldParseLineAtIndex:)]) {
            if (![self.delegate parser:self shouldParseLineAtIndex:i]) continue;
        }
        //check if we should parse this line
        if ([self.delegate respondsToSelector:@selector(parser:shouldParseLineWithString:)]) {
            if (![self.delegate parser:self shouldParseLineWithString:line]) continue;
        }
        [self parseLine:line atIndex:i];
    }
    
    // tell delegate the parsing has ended
    if ([self.delegate respondsToSelector:@selector(parserDidEndParsing:)]) {
        [self.delegate parserDidEndParsing:self];
    }
}
    
- (void)parseLine:(NSString *)line atIndex:(NSUInteger)index
{
    NSString *goodLine = [self removeExtraSpaces:line];
    
    //give delegate raw line
    if ([self.delegate respondsToSelector:@selector(parser:didLoadLineWithString:atIndex:)]) {
        [self.delegate parser:self didLoadLineWithString:line atIndex:index];
    }
    // explode line into array and give it to the delegate
    if ([self.delegate respondsToSelector:@selector(parser:didExplodeLineToArray:atIndex:)]) {
        NSArray *fields = [goodLine componentsSeparatedByCharactersInSet:[self.dataSource fieldSeparators:self]];
        [self.delegate parser:self didExplodeLineToArray:fields atIndex:index];
    }
}

#pragma mark - helpers

- (NSString *)removeExtraSpaces:(NSString *)string
{
    NSString *goodLine = [NSString stringWithString:string];
    while ([goodLine rangeOfString:@"  "].location != NSNotFound) {
        goodLine = [goodLine stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    };
    return goodLine;
}

@end
