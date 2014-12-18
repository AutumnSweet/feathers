---
title: How to use the Feathers PanelScreen component  
author: Josh Tynjala

---
# How to use the Feathers `PanelScreen` component

The `PanelScreen` component is meant to be a base class for custom screens to be displayed by `StackScreenNavigator` and `ScreenNavigator`. `PanelScreen` is based on the `Panel` component, and it provides an scrolling, a header and optional footer, and optional layout.

## Skinning a `PanelScreen`

For full details about what skin and style properties are available, see the [`PanelScreen` API reference](../api-reference/feathers/controls/PanelScreen.html).

As mentioned above, `PanelScreen` is a subclass of `Panel`. For more detailed information about the skinning options available to `PanelScreen`, see [How to use the Feathers `Panel` component](panel.html).

### Targeting a `PanelScreen` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( PanelScreen ).defaultStyleFunction = setPanelScreenStyles;
```

If you want to customize a specific panel screen to look different than the default, you may use a custom style name to call a different function:

``` code
screen.styleNameList.add( "custom-panel-screen" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( PanelScreen )
    .setFunctionForStyleName( "custom-panel-screen", setCustomPanelScreenStyles );
```

Trying to change the panel screen's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the panel screen was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the panel screen's properties directly.

## Related Links

-   [`feathers.controls.PanelScreen` API Documentation](../api-reference/feathers/controls/PanelScreen.html)

-   [How to use the Feathers `Panel` component](panel.html)

For more tutorials, return to the [Feathers Documentation](index.html).


