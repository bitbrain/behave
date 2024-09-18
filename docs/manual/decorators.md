# Decorators
Decorators are versatile nodes that can be combined with any other nodes described in this guide. They can modify or alter the behavior of their child node(s), providing additional flexibility and control in the behavior tree.

## Failer
A `Failer` node will always return a `FAILURE` status code, regardless of the result of its child node. This can be useful in cases where you want to force a branch to fail, such as when an optional action is not critical for the overall success of the behavior tree.

**Example:** An NPC trying to pick up an item, even if the action fails, the NPC can continue with other tasks.

## Succeeder
A `Succeeder` node will always return a `SUCCESS` status code, no matter the outcome of its child node. This can be helpful when you want to ensure that a branch is considered successful, even if the actual action or condition fails.

**Example:** An NPC attempts to open a door, but even if the door is locked, the NPC continues with its routine as if the door was opened.

## Inverter
An `Inverter` node reverses the outcome of its child node. It returns `FAILURE` if its child returns a `SUCCESS` status code, and `SUCCESS` if its child returns a `FAILURE` status code. This is useful when you want to negate a condition or invert the result of an action.

**Example:** Instead of creating separate conditions like "guards sees an enemy" and "guard doesn't see an enemy", you could create just 1, and then invert it.

<ul style="list-style: none;">
    <li>
        <img src="assets/icons/tree.svg" width="18px"/>
        BeehaveTree
    </li>
    <li>
        <ul style="list-style: none;">
        <li>
            <a href="#/manual/selector?id=selector-node"><img src="assets/icons/selector.svg" width="18px"/></a>
            SelectorComposite
        </li>
        <li>
            <ul style="list-style: none;">
                <li>
                    <a href="#/manual/sequence?id=sequence-node"><img src="assets/icons/sequence.svg" width="18px"/></a>
                    SequenceComposite
                </li>
                <li>
                    <ul style="list-style: none;">
                        <li>
                            <a href="#/manual/decorators?id=inverter"><img src="assets/icons/inverter.svg" width="18px"/></a>
                            InverterDecorator
                        </li>
                        <li>
                            <ul style="list-style: none;">
                                <li>
                                    <a href="#/manual/condition_leaf?id=condition-leaf"><img src="assets/icons/condition.svg" width="18px"/></a>
                                    SeesEnemy
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="#/manual/action_leaf?id=action-leaf-node"><img src="assets/icons/action.svg" width="18px"/></a>
                            Patrol
                        </li>
                    </ul>
                </li>
            </ul>
        </li>
        <li>
            <ul style="list-style: none;">
                <li>
                    <a href="#/manual/sequence?id=sequence-node"><img src="assets/icons/sequence.svg" width="18px"/></a>
                    SequenceComposite2
                </li>
                <li>
                    <ul style="list-style: none;">
                        <li>
                            <a href="#/manual/condition_leaf?id=condition-leaf"><img src="assets/icons/condition.svg" width="18px"/></a>
                            SeesEnemy
                        </li>
                        <li>
                            <a href="#/manual/action_leaf?id=action-leaf-node"><img src="assets/icons/action.svg" width="18px"/></a>
                            Attack
                        </li>
                    </ul>
                </li>
            </ul>
        </li>
    </li>
</ul>

## Limiter
The `Limiter` node executes its `RUNNING` child a specified number of times (x). When the maximum number of ticks is reached, it returns a `FAILURE` status code. The limiter resets its counter after its child returns either `SUCCESS` or `FAILURE`.

This node can be beneficial when you want to limit the number of times an action or condition is executed, such as limiting the number of attempts an NPC makes to perform a task. Once a limiter reaches its maximum number of ticks, it will start interrupting its child on every tick.

**Example:** An NPC tries to unlock a door with lockpicks but will give up after three attempts if unsuccessful.

## TimeLimiter
The `TimeLimiter` node only gives its `RUNNING` child a set amount of time to finish. When the time is up, it interrupts its child and returns a `FAILURE` status code. The time limiter resets its time after its child returns either `SUCCESS` or `FAILURE`.

This note is useful when you want to limit the execution time of a long running action. Once a time limiter reaches its time limit, it will start interrupting its child on every tick.

**Example:** A mob aggros and tries to chase you, the chase action will last a maximum of 10 seconds before being aborted if not complete.

## Delayer
When first executing the `Delayer` node, it will start an internal timer and return `RUNNING` until the timer is complete, after which it will execute its child node. The delayer resets its time after its child returns either `SUCCESS` or `FAILURE`.

**Example:** You stun a boss mob and it waits a certain amount of time before resuming its attack patterns.

## Cooldown
The `Cooldown` node executes its child until it either returns `SUCCESS` or `FAILURE`, after which it will start an internal timer and return `FAILURE` until the timer is complete. The cooldown is then able to execute its child again.

**Example:** A mob attacks you and has to wait before it can attack you again.

## UntilFail

The `UntilFail` node executes its child and returns `RUNNING` as long as it returns either `RUNNING` or `SUCCESS`. If its child returns `FAILURE`, it will instead return `SUCCESS`.

**Example:** A turret fires upon any NPC in range until it does not detect any more NPCs.

<ul style="list-style: none;">
    <li>
        <img src="assets/icons/tree.svg" width="18px"/>
        BeehaveTree
    </li>
    <li>
        <ul style="list-style: none;">
            <li>
                <a href="#/manual/decorators?id=untilfail"><img src="assets/icons/until_fail.svg" width="18px"/></a>
                UntilFailDecorator
            </li>
            <li>
                <ul style="list-style: none;">
                    <li>
                        <a href="#/manual/sequence?id=sequence-node"><img src="assets/icons/sequence.svg" width="18px"/></a>
                        SequenceComposite
                    </li>
                    <li>
                        <ul style="list-style: none;">
                            <li>
                                <a href="#/manual/condition_leaf?id=condition-leaf"><img src="assets/icons/condition.svg" width="18px"/></a>
                                DetectsNPCs
                            </li>
                            <li>
                                <a href="#/manual/action_leaf?id=action-leaf-node"><img src="assets/icons/action.svg" width="18px"/></a>
                                Shoot
                            </li>
                        </ul>
                    </li>
                </ul>
            </li>
        </ul>
    </li>
</ul>
