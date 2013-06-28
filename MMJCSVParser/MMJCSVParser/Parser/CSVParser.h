//
//  CSVParser.h
//  MMJCSVParser
//
//  Created by Mihaela Mihaljević Jakić on 6/27/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

//taken from "Cocoa design patterns" by Bruck, Erik M:, Yacktman...

//**Delegates** react to changes or control other objects, they are optional and the object that uses a delegate falls back to default behaviour if there is no delegate

//should messages
//- are expected to return a value (usually BOOL)
//- usually take an argument that identifies object sending the message
//- message is sent before a change to the object is made, so that the delegate could influence the change

//will messages
//- not expected to return a value
//- message is sent before a change happens, and is strictly informative

//did messages
//- sent after the change happens
//- strictly informative

//**Data sources** provides data for another object that may not be functional withut a valid data source

//if([[self delegate] respondsToSelector:
//    @selector(barViewWillChangeValue:)])
//{
//    [[self delegate] barViewWillChangeValue:notification];
//}

@protocol CSVParserDelegate, CSVParserDataSource; //forward declaration is needed for protocols


@interface CSVParser : NSObject
@property (nonatomic, weak) id <CSVParserDelegate> delegate;
@property (nonatomic, weak) id <CSVParserDataSource> dataSource;

- (void)parse;
- (id)initWithDelegate:(id)delegate andDataSource:(id)dataSource;
@end

@protocol CSVParserDelegate <NSObject>

@required 
- (void)parser:(CSVParser *)parser didLoadLineWithString:(NSString *)string atIndex:(NSUInteger)index;

@optional
- (void)parserDidStartParsing:(CSVParser *)parser linesNo:(NSUInteger)linesNo;
- (void)parserDidEndParsing:(CSVParser *)parser;
- (BOOL)parser:(CSVParser *)parser shouldParseLineAtIndex:(NSInteger)index;
- (BOOL)parser:(CSVParser *)parser shouldParseLineWithString:(NSString *)string;
- (void)parser:(CSVParser *)parser didExplodeLineToArray:(NSArray *)array atIndex:(NSUInteger)index;
@end

@protocol CSVParserDataSource <NSObject>
@required 
- (NSString *)stringToParse:(CSVParser *)parser;
- (NSCharacterSet *)fieldSeparators:(CSVParser *)parser;
@end