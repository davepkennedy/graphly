//
//  Graph.m
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "Graph.h"

@implementation Graph {
    NSMutableArray<Node*>* _nodes;
}

@synthesize nodes = _nodes;

- (instancetype) init {
    self = [super init];
    if (self) {
        _nodes = [NSMutableArray array];
    }
    return self;
}

- (instancetype) initWithNodes:(NSArray*)nodes {
    self = [super init];
    if (self) {
        _nodes = [NSMutableArray array];
        for (NSDictionary* dict in nodes) {
            [_nodes addObject:[[Node alloc] initWithValues:dict]];
        }
    }
    return self;
}

- (Node*) newNode {
    Node* node = [[Node alloc] init];
    [_nodes addObject:node];
    return node;
}

- (void) connect:(Node*) origin to:(Node*) destination {
    
}

-(NSArray<NSDictionary*>*) toArray {
    NSMutableArray<NSDictionary*>* data = [NSMutableArray array];
    for (Node* node in _nodes) {
        [data addObject:[node toDictionary]];
    }
    return data;
}

-(Node*) nodeForID:(NSUUID*) identifier {
    for (Node* node in _nodes) {
        if ([node.identifier isEqual:identifier]) {
            return node;
        }
    }
    return nil;
}

@end
