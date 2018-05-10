//
//  Graph.h
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface Graph : NSObject

@property (readonly) NSArray<Node*>* nodes;

- (instancetype) initWithNodes:(NSArray*)nodes;

- (Node*) newNode;

-(NSArray<NSDictionary*>*) toArray;

@end