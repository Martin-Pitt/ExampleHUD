# Example of a Movable and Resizable HUD

Have you ever been frustrated that in Second Life you need to *edit* a HUD just to move or resize it? If you are a designer of HUDs in Second Life, this is for you.

This directory contains a working example of how to make a HUD **movable and resizable** by simply grabbing and dragging it with your mouse.  No edit mode required. There is also a helper script that can configure a linked set of prims into an example HUD.  This script is not a complete HUD, it only contains the logic to move and resize a HUD.  Making it into a complete HUD is an exercise left to the reader.

If you do decide to use this it would be nice if you let Quark Idlemind in Second Life know.

## What is provided

The main script, `Movable Resizable HUD.lsl`, is a fully working example HUD. You can move it around by grabbing the background with your mouse and dragging. You can resize it by grabbing the lower left corner and dragging. 

Every HUD should support this, don't you think?

## How it works

The secret is placing a sheet of "glass" (a transparent prim) in front of the HUD's background. When you touch the HUD, the script figures out whether you grabbed a button, the background, or the resize corner. If it's a move or resize action, the glass expands to cover the entire screen. It then uses `llDetectedTouchPos()` to track your mouse movement and updates the HUD accordingly. When you release the mouse (`touch_end`), the glass shrinks back to just covering the background.

Two scripts are included:
- `Movable Resizable HUD.lsl` — the main script
- `Configure Example HUD.lsl` — sets up a nice example HUD for you

## `Movable Resizable HUD.lsl`

This script implements mouse-based moving and resizing. It is written more for readability than raw efficiency. It makes a few assumptions you will probably want to adjust for your own HUDs:

- The HUD is twice as wide as it is high
- The background uses a 512×256 texture
- The lower-left 64 pixels are the resize grab area
- The background prim is a box rotated `<0, 270, 270>` so face 0 faces the user
- There is a child prim named `Glass`

The script works whether the root prim is the background or a child prim is the background. It can also be easily extended to handle buttons baked into the background texture.

## `Configure Example HUD.lsl`

Because a working example is always better than just a script, this helper script will automatically configure and texture a linked set of prims into a nice-looking example HUD.

**How to use it:**
1. Create and link together several box prims (at least 2, 3–5 is nicer).
2. Attach the object to your HUD attachment point.
3. Drop in `Configure Example HUD.lsl` — it will reconfigure everything.
4. Drop in `Movable Resizable HUD.lsl` — the config script will remove itself and your HUD becomes active.

With 3 or more prims touching it will switch it between root-prim and child-prim background setups.

## Coordination between the scripts

The configuration script uses **Linkset Data** to tell the main script which prim is the background. You can also manually control this by setting the `BackgroundName` variable in `Movable Resizable HUD.lsl`:
- `""` → root prim is the background
- `"HUD"` → child prim named "HUD" is the background
