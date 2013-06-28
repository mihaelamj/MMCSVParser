//
//  CSVPViewController.m
//  MMJCSVParser
//
//  Created by Mihaela Mihaljević Jakić on 6/27/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "CSVPViewController.h"
#import "CSVParser.h"

@interface CSVPViewController () <CSVParserDelegate, CSVParserDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) CSVParser *parser;
@property (strong, nonatomic) NSString *stringToParse;
@property (strong, nonatomic) NSCharacterSet *separators;
@end

@implementation CSVPViewController

#pragma mark - Properties

- (CSVParser *)parser
{
    if (!_parser) {
        _parser = [[CSVParser alloc] initWithDelegate:self andDataSource:self];
    }
    return _parser;
}

- (NSString *)stringToParse
{
    return _stringToParse ? _stringToParse : @"";
}

- (NSCharacterSet *)separators
{
    return _separators ? _separators : [NSCharacterSet whitespaceCharacterSet];
}

#pragma mark - Tests

- (IBAction)testClicked:(UIButton *)sender {
    self.stringToParse = [self getCSVFileString:sender.titleLabel.text];
    self.separators = [NSCharacterSet characterSetWithCharactersInString:@","];
    self.textView.text = self.stringToParse;
    [self.parser parse];    
}


-(NSString *)getCSVFileString:(NSString *)fileName
{
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"csv"];	
	NSStringEncoding encoding = 0;
	NSString *fileString = [NSString stringWithContentsOfFile:file usedEncoding:&encoding error:nil];
    return fileString;
}

#pragma mark - CSVParserDelegate

- (void)parserDidStartParsing:(CSVParser *)parser linesNo:(NSUInteger)linesNo
{
    NSLog(@"Started parsing %d lines", linesNo);
}

- (void)parserDidEndParsing:(CSVParser *)parser
{
    NSLog(@"Finished parsing");    
}

- (void)parser:(CSVParser *)parser didLoadLineWithString:(NSString *)string atIndex:(NSUInteger)index
{
    NSLog(@"Loaded line: %@ st index:%d", string, index);
}


- (BOOL)parser:(CSVParser *)parser shouldParseLineAtIndex:(NSInteger)index
{
    return index % 2 == 0;
}

- (BOOL)parser:(CSVParser *)parser shouldParseLineWithString:(NSString *)string
{
    return YES;
}

- (void)parser:(CSVParser *)parser didExplodeLineToArray:(NSArray *)array atIndex:(NSUInteger)index
{
    NSLog(@"Exploded line: %d to array:\n%@", index, array);
}


#pragma mark - CSVParserDataSource

- (NSString *)stringToParse:(CSVParser *)parser
{
    return self.stringToParse;
}

- (NSCharacterSet *)fieldSeparators:(CSVParser *)parser
{
    return self.separators;
//    return [NSCharacterSet characterSetWithCharactersInString:@","];
}

@end
