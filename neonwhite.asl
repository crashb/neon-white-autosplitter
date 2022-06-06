state("Neon White") {
    string255 levelId : "UnityPlayer.dll", 0x1A058E0, 0x48, 0x10, 0x18;
    float levelTime : "UnityPlayer.dll", 0x199CDC0, 0x10, 0x108, 0x28, 0x40, 0x20;
    short levelStatus : "UnityPlayer.dll", 0x199B7A0, 0x70, 0x0, 0xD8, 0x600, 0x7D8, 0x62;
}

startup {
    vars.FIRST_LEVEL_ID = "id/TUT_MOVEMENT.unity";
    vars.LEVEL_COMPLETE = 1;

    vars.ResetVars = (Action)(() => {
        vars.totalTime = 0f;
    });

    vars.ResetVars();
}

update {
    if (string.IsNullOrEmpty(current.levelId)) {
        current.levelId = old.levelId;
    }
}

gameTime {
    if (current.levelStatus == vars.LEVEL_COMPLETE) {
        current.levelTime = old.levelTime;
    }
    
    if (current.levelTime == -1 && old.levelTime != -1) {
        vars.totalTime += old.levelTime;
    }

    if (current.levelTime < 0) {
        return TimeSpan.FromSeconds(vars.totalTime);
    }
    else {
        return TimeSpan.FromSeconds(vars.totalTime + current.levelTime);
    }
}

isLoading {
    return true;
}

start {
    bool start = old.levelId != current.levelId && current.levelId == vars.FIRST_LEVEL_ID;
    if (start) {
        vars.ResetVars();
    }
    return start;
}

reset {
    bool reset = old.levelId != current.levelId && current.levelId == vars.FIRST_LEVEL_ID;
    if (reset) {
        vars.ResetVars();
    }
    return reset;
}

split {
    return old.levelId != current.levelId;
}
