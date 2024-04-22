# Simple Parallel Node
The Simple Parallel node is a fundamental building block in Behavior Trees, used to execute two children at same time. It helps you run multiple actions simultaneously.Think of the Simple Parallel node as "While doing A, do B as well."

## How does it work?
Simple Parallel nodes will attampt to execute all chidren at same time and can only have exactly two children. First child as primary node, second child as secondary node.  
This node will always report primary node's state, and continue tick while primary node return `RUNNING`. The state of secondary node will be ignored and executed like a subtree.  
If primary node return `SUCCESS` or `FAILURE`, this node will interrupt secondary node and return primary node's result.  
If this node is running under delay mode, it will wait seconday node finish its action after primary node terminates.


## Example Scenarios
Here are some example scenarios to help you understand the Sequence node better:

### Example: While attacking the enemy, move toward the enemy 
Imagine you want a ranged enemy character trying to shoot you whenever he can while to move towards you. You can use a Simple Parallel node with the following child nodes architecture:

1. Move to point A near player
2. Sequence Node
   1. Check if enemy can shoot
   2. Shoot

The enemy will move to a location near player and try to shoot at same time, and if move action is successful or failure, the Simple Parallel node will termitate the child sequence node for shooting attempt, then return `SUCCESS` or `FAILURE` according to move action result.

Simple Parallel can be nested to create complex behaviors while it's not suggested, because too much nesting would make it hard to maintain your behavior tree.
