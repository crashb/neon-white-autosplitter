state("Neon White") {
    long levelPlaythroughMicroseconds : "UnityPlayer.dll", 0x199CDC0, 0x18, 0x40, 0x28, 0x48, 0x20;
    long levelRushMicroseconds : "UnityPlayer.dll", 0x1930010, 0x10, 0xD0, 0x8, 0x60, 0x50, 0x0, 0x1C0, 0x10, 0x20;
    string255 levelId : "UnityPlayer.dll", 0x1A058E0, 0x48, 0x10, 0x18;
}

startup {
    vars.FIRST_LEVEL_ID = "id/TUT_MOVEMENT.unity";
}

update {
    if (string.IsNullOrEmpty(current.levelId)) {
        current.levelId = old.levelId;
    }

    // levelRushMicroseconds is set to 0 when loading; supress this for a clean timer,
    // unless levelRushMicroseconds is actually zero. (i.e. we are on the first level)
    if (current.levelRushMicroseconds == 0 && current.levelId != vars.FIRST_LEVEL_ID) {
        current.levelRushMicroseconds = old.levelRushMicroseconds;
    }

    // levelRushMicroseconds is incremented by levelPlaythroughMicroseconds every level;
    // if levelPlaythroughMicroseconds hasn't reset yet, supress this change.
    if (current.levelRushMicroseconds == old.levelRushMicroseconds + current.levelPlaythroughMicroseconds) {
        current.levelRushMicroseconds = old.levelRushMicroseconds;
    }
}

isLoading {
    return true;
}

gameTime {
    long totalMicroseconds = current.levelRushMicroseconds + current.levelPlaythroughMicroseconds;
    long totalMilliseconds = totalMicroseconds / 1000;
    return TimeSpan.FromMilliseconds(totalMilliseconds);
}

split {
    return old.levelId != current.levelId;
}

start {
    return old.levelId != current.levelId && current.levelId == vars.FIRST_LEVEL_ID;
}

reset {
    return old.levelId != current.levelId && current.levelId == vars.FIRST_LEVEL_ID;
}