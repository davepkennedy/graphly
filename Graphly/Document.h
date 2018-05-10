//
//  Document.h
//  Graphly
//
//  Created by Dave Kennedy on 09/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphView.h"

@interface Document : NSDocument <GraphViewDelegate>

@property IBOutlet GraphView* graphView;
@property IBOutlet NSObjectController* objectController;

@end

