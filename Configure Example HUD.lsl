// Please see https://github.com/quark-idlemind/ExampleHUD for a description of
// this script.
//
// Please do not sell this script but feel free to incorporate the logic.  It
// would be nice if you let Quark Idlemind know if you do use this script.

// This script is a quick hack to setup a group of prims for use by the 
// Movable Resizeable HUD script.

string Background = "16669a27-9b4b-1a17-f726-463acce9b28f";
string XButton = "d86c6efa-b381-dcf6-1ffa-54db80c4fe78";

list ButtonTextures = [
    "2aa38c8e-db40-cc7a-b257-1ffab02fe446",
    "6278e68b-fd36-670d-3c54-dcea78260267",
    "664cf64d-50e9-1151-38cf-e9776c1959ad",
    "a92be939-50b3-14d7-d7f6-5dd923910cf0",
    "131a5b8b-0949-4a4d-bf67-36cc06db99a4",
    "b725a9e1-db00-9591-6633-12017868019a"
];

reset() {
    integer n = llGetNumberOfPrims();
    vector pos;
    llSetScale(<.3, .3, .3>);
    while (n > 1) {
            llSetLinkPrimitiveParamsFast(n--, [
                PRIM_SIZE, <.3, .3, .3>,
                PRIM_TEXTURE, -1, TEXTURE_BLANK, <1, 1, 0>, <0, 0, 0>, 0,
                PRIM_POS_LOCAL, pos,
                PRIM_ROT_LOCAL, ZERO_ROTATION,
                PRIM_COLOR, -1, <1, 1, 1>, 1
            ]);
            pos.x += .05;
            pos.z += .05;
            pos.y += .05;
    }
}

MakeRootAsBackground() {
    integer n = llGetNumberOfPrims();
    llSetLinkPrimitiveParamsFast(1, [
        PRIM_SIZE, <.5, .25, .1>,
        PRIM_TEXTURE, -1, TEXTURE_BLANK, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_TEXTURE, 0, Background, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_COLOR, -1, <1, 1, 1>, 1
    ]);
    llSetLinkPrimitiveParams(2, [
        PRIM_SIZE, <.5, .25, .2>,
        PRIM_TEXTURE, -1, TEXTURE_TRANSPARENT, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_POS_LOCAL, <0, 0, 0>,
        PRIM_NAME, "Glass"
    ]);
    llLinksetDataWrite("BackgroundPrim", "1");
    if (n == 2) {
        return;
    }
    float size = (0.33) / (float)(n-2);
    if (size > .06) {
        size = .06;
    }
    float delta = (.5 - (size * (n-2))) / (n-1);
    while (n > 2) {
        string texture = TEXTURE_BLANK;
        if (n <= 8) {
            texture = llList2String(ButtonTextures, n - 3);
        }
        llSetLinkPrimitiveParams(n, [
            PRIM_SIZE, <size, size, .25>,
            PRIM_TEXTURE, -1, TEXTURE_TRANSPARENT, <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_TEXTURE, 0, texture, <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_POS_LOCAL, <-.25 + delta + size/2 + (delta + size) * (n-3), -.025, 0>,
            PRIM_NAME, "Button " + (string)(n-2)
        ]);
        --n;
    }
}

MakeRootAsButton() {
    integer n = llGetNumberOfPrims();
    llSetLinkPrimitiveParamsFast(1, [
        PRIM_SIZE, <.05, .05, .1>,
        PRIM_TEXTURE, -1, TEXTURE_BLANK, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_TEXTURE, 0, XButton, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_COLOR, -1, <1, 1, 1>, 1
    ]);
    vector Offset = <-0.2, -0.075, 0>;
    llSetLinkPrimitiveParamsFast(2, [
        PRIM_SIZE, <.5, .25, .1>,
        PRIM_TEXTURE, -1, TEXTURE_BLANK, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_TEXTURE, 0, Background, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_COLOR, -1, <1, 1, 1>, 1,
        PRIM_POS_LOCAL, Offset,
        PRIM_NAME, "HUD"
    ]);
    llSetLinkPrimitiveParams(3, [
        PRIM_SIZE, <.5, .25, .2>,
        PRIM_TEXTURE, -1, TEXTURE_TRANSPARENT, <1, 1, 0>, <0, 0, 0>, 0,
        PRIM_POS_LOCAL, Offset,
        PRIM_NAME, "Glass"
    ]);
    llLinksetDataWrite("BackgroundPrim", "2");
    if (n == 3) {
        return;
    }
    float size = (0.33) / (float)(n-3);
    if (size > .06) {
        size = .06;
    }
    float delta = (.5 - (size * (n-3))) / (n-2);
    while (n > 3) {
        string texture = TEXTURE_BLANK;
        if (n <= 9) {
            texture = llList2String(ButtonTextures, n - 4);
        }
        llSetLinkPrimitiveParams(n, [
            PRIM_SIZE, <size, size, .25>,
            PRIM_TEXTURE, -1, TEXTURE_TRANSPARENT, <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_TEXTURE, 0, texture, <1, 1, 0>, <0, 0, 0>, 0,
            PRIM_POS_LOCAL, Offset + <-.25 + delta + size/2 + (delta + size) * (n-4), -.025, 0>,
            PRIM_NAME, "Button " + (string)(n-2)
        ]);
        --n;
    }
}

integer mode = 0;
integer expire;
integer started;

default {
    state_entry() {
        if (llGetNumberOfPrims() < 2) {
            llOwnerSay("Please drop me in an object with at least 2 linked prims");
            llRemoveInventory(llGetScriptName());
            return;
        }
        if (llGetInventoryNumber(INVENTORY_SCRIPT) > 1) {
            llOwnerSay("Only the \"" + llGetScriptName() + "\" script should be in this object.");
            return;
        }
        if (llGetAttached()) {
            llSetRot(llEuler2Rot(<0, PI * 3.0 / 2.0, PI * 3.0 / 2.0>));
        }
        MakeRootAsBackground();
        started = TRUE;
    }
    changed(integer what) {
        if (what & CHANGED_INVENTORY) {
            if (!started) {
                llResetScript();
            } else if (llGetInventoryNumber(INVENTORY_SCRIPT) > 1) {
                llOwnerSay("Now removing the script " + llGetScriptName());
                llRemoveInventory(llGetScriptName());
            }
        }
    }
    on_rez(integer n) {
        llResetScript();
    }
    touch_start(integer n) {
        expire = llGetUnixTime() + 3;
    }
    touch(integer n) {
        if (llGetUnixTime() > expire) {
            llOwnerSay("Now removing the script " + llGetScriptName());
            llRemoveInventory(llGetScriptName());
        }
    }
    touch_end(integer n) {
        if (llGetNumberOfPrims() < 3) {
            return;
        }
        mode = mode ^ 1;
        if (mode) {
            MakeRootAsButton();
        } else {
            MakeRootAsBackground();
        }
    }
}
