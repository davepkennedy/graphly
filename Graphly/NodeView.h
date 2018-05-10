//
//  NodeView.h
//  Graphly
//
//  Created by Dave Kennedy on 08/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Node.h"

@interface NodeView : NSView {
    NSPoint lastDragLocation;
}

@property NSColor* color;
@property (readonly) NSArray<NodeView*>* connections;
@property (readonly) NSPoint anchor;
@property (readonly) Node* node;

- (instancetype) initNode:(Node*) node withPosition:(NSPoint) point;
- (NSInteger)numberOfProperties;
- (id) property:(NSString*)name forItem:(NSInteger)item;
- (void) newValue:(id)object forProperty:(NSString*)name forItem:(NSInteger)item;
- (void) addConnection:(NodeView*) node;
- (void) setConnections:(NSArray<NodeView *> *)connections;

@end
