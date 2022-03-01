state("Neon White") {
    string255 levelId : "UnityPlayer.dll", 0x1A058E0, 0x48, 0x10, 0x18;
}

startup {
    vars.firstLevelId = "id/TUT_MOVEMENT.unity";
}

update {
    if (string.IsNullOrEmpty(current.levelId))
        current.levelId = old.levelId;
}

start {
    return old.levelId != current.levelId && current.levelId == vars.firstLevelId;
}

reset {
    return old.levelId != current.levelId && current.levelId == vars.firstLevelId;
}

split {
    return old.levelId != current.levelId;
}
