//
//  NodeView.m
//  Graphly
//
//  Created by Dave Kennedy on 08/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "NodeView.h"
#import "GraphView.h"

#define NODE_SIZE 20
#define LINE_WIDTH 2

@implementation NodeView {
    Node* _node;
    NSMutableArray<NodeView*>* _connections;
}

@synthesize color;
@synthesize connections = _connections;
@synthesize node = _node;

- (NSPoint) anchor
{
    return NSMakePoint(self.frame.origin.x + (NODE_SIZE/2), self.frame.origin.y + (NODE_SIZE/2));
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL) acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (instancetype) initNode:(Node*) node withPosition:(NSPoint) point {
    NSRect nameBounds = [node.name boundingRectWithSize:NSMakeSize(100, 1000) options:0 attributes:NULL];
    self = [super initWithFrame:NSMakeRect(
                                           point.x-(NODE_SIZE/2),
                                           point.y-(NODE_SIZE/2),
                                           NODE_SIZE + nameBounds.size.width, NODE_SIZE)];
    if (self) {
        self.color = [NSColor redColor];
        _node = node;
        _node.position = point;
        _connections = [NSMutableArray array];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSRect bounds = self.bounds;
    bounds.origin.x += LINE_WIDTH;
    bounds.origin.y += LINE_WIDTH;
    bounds.size.width = NODE_SIZE - (LINE_WIDTH * 2);
    bounds.size.height = NODE_SIZE - (LINE_WIDTH * 2);
    NSBezierPath* oval = [NSBezierPath bezierPathWithOvalInRect:bounds];
    oval.lineWidth = LINE_WIDTH;
    [color setFill];
    [oval fill];
    [[NSColor blackColor] setStroke];
    [oval stroke];
    
    [self.node.name drawInRect:NSMakeRect(NODE_SIZE, 0, self.bounds.size.width, NODE_SIZE) withAttributes:NULL];
}

- (void) mouseDown:(NSEvent *)event {
    GraphView* graphView = (GraphView*)self.superview;
    if ((event.modifierFlags & NSEventModifierFlagShift) == NSEventModifierFlagShift) {
        [graphView.activeNode addConnection:self];
        [graphView setNeedsDisplay:YES];
    } else {
        lastDragLocation = [[self superview] convertPoint:[event locationInWindow] fromView:nil];
        [graphView setActiveNode:self];
    }
}

- (void) mouseDragged:(NSEvent *)event {
    NSPoint newDragLocation = [[self superview] convertPoint:[event locationInWindow] fromView:nil];
    NSPoint thisOrigin = [self frame].origin;
    thisOrigin.x += (-lastDragLocation.x + newDragLocation.x);
    thisOrigin.y += (-lastDragLocation.y + newDragLocation.y);
    [self setFrameOrigin:thisOrigin];
    self.node.position = thisOrigin;
    
    lastDragLocation = newDragLocation;
    [self.superview setNeedsDisplay:YES];
}

- (NSInteger)numberOfProperties {
    return self.node.numberOfProperties;
}

- (id) property:(NSString*)name forItem:(NSInteger)item
{
    return [self.node property:name forItem:item];
}

- (void) newValue:(id)object forProperty:(NSString*)name forItem:(NSInteger)item
{
    [self.node newValue:object forProperty:name forItem:item];
}

- (void) addConnection:(NodeView *)node {
    [self.node addConnection:node.node];
    [_connections addObject:node];
    [self.superview setNeedsDisplay:YES];
}

- (void) setConnections:(NSArray<NodeView *> *)connections {
    _connections = connections;
}
@end
