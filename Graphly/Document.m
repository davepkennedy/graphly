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
    NSMutableArray* activeNodes;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _graph = [[Graph alloc] init];
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

- (BOOL) nodeIsActive:(Node*)node {
    BOOL isActive = [activeNodes containsObject:node];
    return isActive;
}

- (void) setActiveNode:(Node*)node {
    if (node) {
        activeNodes = [NSMutableArray arrayWithObject:node];
    } else {
        activeNodes = [NSMutableArray array];
    }
}

- (void) addActiveNode:(Node*)node {
    if (node) {
        [activeNodes addObject:node];
    }
}

- (void) connectTo:(Node*)node {
    [((Node*)[self.objectController content]) addConnection:node];
    [self.graphView setNeedsDisplay:YES];
}

@end
