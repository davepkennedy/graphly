//
//  Document.m
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document {
    Graph* _graph;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void) awakeFromNib {
    if (!_graph) {
        _graph = [[Graph alloc] init];
    }
}

- (void) activeNode:(Node *)node {
    [self.objectController setContent:node];
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    NSData* data = [NSJSONSerialization dataWithJSONObject:[_graph toArray] options:NSJSONWritingPrettyPrinted error:outError];
    if (*outError) {
        return NO;
    }
    [data writeToURL:url atomically:false];
    return YES;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:outError];
    if (*outError) {
        return NO;
    }
    _graph = [[Graph alloc] initWithNodes:array];
    return YES;
}

- (Graph*) graph {
    return _graph;
}

@end
