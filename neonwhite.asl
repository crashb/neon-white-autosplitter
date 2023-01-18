state("Neon White") {
    // This pointer path is valid whether or not mods are loaded.
    string255 levelScene : "UnityPlayer.dll", 0x1A058E0, 0x48, 0x10, 0x18;
}

init {
    print("Starting Neon White autosplitter..");

    vars.firstLvls = new HashSet<string> {
        "id/TUT_MOVEMENT.unity", // White's & Mikey's Rush
        "id/SIDEQUEST_DODGER.unity", // Violet's Rush
        "id/SIDEQUEST_OBSTACLE_PISTOL.unity", // Red's Rush
        "id/SIDEQUEST_SUNSET_FLIP_POWERBOMB.unity", // Yellow's Rush
    };

    vars.introScenes = new HashSet<string> {
        "nu.unity", // Main Menu
        "s/IntroCards.unity", // Intro
    };

    vars.ignoredScenes = new HashSet<string> {
        "yworld/GodTemple_Environment_Base.unity",
        "GodTemple_InteriorLighting_Test.unity",
        "yworld/HandOfGod_Environment_Base_LOOKDEV.unity",
        "terlife/Afterlife_Environment_Green.unity",
    };
    
    vars.watchers = new MemoryWatcherList
    {
        new MemoryWatcher<long>(new DeepPointer("UnityPlayer.dll", 0x199CDC0, 0x18, 0xB8, 0x38, 0x48, 0x20)) { Name = "playthroughTime" },
        new MemoryWatcher<long>(new DeepPointer("UnityPlayer.dll", 0x199CDC0, 0x18, 0xB8, 0x38, 0x48, 0x30)) { Name = "rushTimeOffset" },
    };
    
    vars.modsChecked = false;
}

update {
    if (!vars.modsChecked && old.levelScene == "s/IntroCards.unity" && current.levelScene == "nu.unity") {
        if (modules.Any(m => m.ModuleName == "Bootstrap.dll")) {
            print("Mods found.");
            vars.watchers = new MemoryWatcherList
            {
                new MemoryWatcher<long>(new DeepPointer("UnityPlayer.dll", 0x1A058E0, 0x128, 0x8, 0x38, 0x60, 0x48, 0x20)) { Name = "playthroughTime" },
                new MemoryWatcher<long>(new DeepPointer("UnityPlayer.dll", 0x1A058E0, 0x128, 0x8, 0x38, 0x60, 0x48, 0x30)) { Name = "rushTimeOffset" },
            };
        } else {
            print("No mods found.");
        }
        vars.modsChecked = true;
    }

    vars.watchers.UpdateAll(game);

    current.playthroughTime = vars.watchers["playthroughTime"].Current;
    current.rushTimeOffset = vars.watchers["rushTimeOffset"].Current;

    if (string.IsNullOrEmpty(current.levelScene) || vars.ignoredScenes.Contains(current.levelScene))
        current.levelScene = old.levelScene;
}

start {
    return old.levelScene != current.levelScene  
    && old.levelScene != "id/Heaven_Environment.unity" // make sure the mission was not started from Job Archive
    && vars.firstLvls.Contains(current.levelScene);
}

split {
    if (old.levelScene != current.levelScene
        && !vars.introScenes.Contains(current.levelScene)
        && !vars.ignoredScenes.Contains(current.levelScene)
        && !vars.firstLvls.Contains(current.levelScene))
        {
            return true;
        }
}

reset {
    return old.levelScene != current.levelScene 
        && vars.firstLvls.Contains(current.levelScene) 
        || current.levelScene == "nu.unity";
}

gameTime {
    if (current.rushTimeOffset == 0 
        && !vars.firstLvls.Contains(current.levelScene)
        || current.playthroughTime == -1) {
        return;
    }

    long totalMicroseconds = current.rushTimeOffset + current.playthroughTime;
    long totalMilliseconds = totalMicroseconds / 1000;
    return TimeSpan.FromMilliseconds(totalMilliseconds);
}

isLoading {
    return true;
}