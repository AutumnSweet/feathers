# Feathers Cookbook: Dispatching a triggered event from a custom item renderer

Sometimes, you want a [custom item renderer](../item-renderers.html) to dispatch `Event.TRIGGERED`, similar to a `Button`. Additionally, item renderers in a `PickerList` must dispatch `Event.TRIGGERED` to properly close the pop-up list when tapping an item that is already selected.

First, let's make sure that we're only tracking a single touch ID:

``` code
protected var touchID:int = -1;
```

There's no reason to track more than one touch here, so if a touch begins, we'll ignore other touches that begin before the original touch ends.

Inside our constructor, or in the component's `initialize()` function, we can listen for `TouchEvent.TOUCH`:

``` code
override protected function initialize():void
{
    this.addEventListener( TouchEvent.TOUCH, touchHandler );
 
    // you may be initializing other things here too
}
```

For more information about the `initialize()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](http://wiki.starling-framework.org/feathers/component-properties-methods).

Now, let's create our `TouchEvent.TOUCH` listener. Comments appear inline to explain each step of the process. To see where a touch begins, look at the `else` block near the bottom.

``` code
private function touchHandler( event:TouchEvent ):void
{
    if( !this._isEnabled )
    {
        // if we were disabled while tracking touches, clear the touch id.
        this.touchID = -1;
        return;
    }
 
    if( this.touchID >= 0 )
    {
        // a touch has begun, so we'll ignore all other touches.
 
        var touch:Touch = event.getTouch( this, null, this.touchID );
        if( !touch )
        {
            // this should not happen.
            return;
        }
 
        if( touch.phase == TouchPhase.ENDED )
        {
            touch.getLocation( this.stage, HELPER_POINT );
            var isInBounds:Boolean = this.contains( this.stage.hitTest( HELPER_POINT, true ) );
            if( isInBounds )
            {
                this.dispatchEventWith( Event.TRIGGERED );
            }
 
            // the touch has ended, so now we can start watching for a new one.
            this.touchID = -1;
        }
        return;
    }
    else
    {
        // we aren't tracking another touch, so let's look for a new one.
 
        touch = event.getTouch( this, TouchPhase.BEGAN );
        if( !touch )
        {
            // we only care about the began phase. ignore all other phases.
            return;
        }
 
        // save the touch ID so that we can track this touch's phases.
        this.touchID = touch.id;
    }
}
```

It's a little complicated, but it will ensure that we are only tracking a single touch ID at a time. In multi-touch environments, this is essential.

The key part is the line with the `isInBounds` local variable. What we're doing there with the call to `contains()` and `hitTest()` is ensuring two things: 1) the touch hasn't moved outside the bounds of the item renderer and 2) nothing else on the display list has moved above the item renderer to block the touch.

Also, you may have seen the `HELPER_POINT` object we passed to `getLocation()`. We're going to add a static constant that we can pass into that function so that it doesn't need to create a new `flash.geom.Point` for its return value. This will help us avoid some unnecessary garbage collection when we check a touch's location to help performance a bit:

``` code
private static const HELPER_POINT:Point = new Point();
```

It's static to avoid creating a different `Point` object for every item renderer. We simply need to ensure that multiple item renderers won't be modifying it at the same time. Since the item renderer isn't dispatching any events between the call to `getLocation()` and the call to `hitTest()`, we know that only one item renderer may be using `HELPER_POINT` at any given time.

Finally, add a listener for `Event.REMOVED_FROM_STAGE` inside the constructor or in the `initialize()` function:

``` code
this.addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler );
```

The listener will clear the `touchID` to `-1` just we did in `TouchPhase.ENDED`:

``` code
private function removedFromStageHandler( event:Event ):void
{
    this.touchID = -1;
}
```

This ensures that if a component is removed and then reused later, it won't remember a touch that doesn't exist anymore.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

-   [Feathers Cookbook: Selecting a custom item renderer on tap or click](item-renderer-select-on-tap.html)

-   [Feathers Cookbook: Dispatching a long press event from a custom item renderer](item-renderer-long-press.html)

This is a recipe in the [Feathers Cookbook](start.html). For more information about Feathers, return to the [Feathers Documentation](../start.html).


