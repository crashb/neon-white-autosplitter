state("Neon White") {
    string255 levelId : "UnityPlayer.dll", 0x1A058E0, 0x48, 0x10, 0x18;
}

startup {
    vars.firstLevelId = "id/TUT_MOVEMENT.unity";
    vars.oldLevelId = vars.firstLevelId;
}

start {
    if (current.levelId == vars.firstLevelId && current.levelId != old.levelId) {
        // reset old level ID to the first level ID when restarting the run
        vars.oldLevelId = vars.firstLevelId;
        return true;
    }
}

reset {
    if (current.levelId == vars.firstLevelId && current.levelId != old.levelId) {
        return true;
    }
}

split {
    // when restarting a level, the levelId is set to null for a brief instant,
    // so only check against the actual old levelId instead of using old.levelId
    if (current.levelId != vars.oldLevelId && current.levelId != null) {
        vars.oldLevelId = current.levelId;
        return true;
    }
}