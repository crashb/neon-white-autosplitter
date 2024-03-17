state("Neon White") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();
}

init 
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
        // Don't use, goes to 0 on level transition
        // ----------------
		//vars.Helper["levelRushMicroseconds"] = mono.Make<long>("Game", 1, "_instance", "_currentPlaythrough", "m_levelRushOffsetMicroseconds");
        // ----------------
        vars.Helper["levelRushMicroseconds"] = mono.Make<long>("LevelRush", "m_currentLevelRush", "currentTimerMicroseconds");
        vars.Helper["levelPlaythroughMicroseconds"] = mono.Make<long>("Game", 1, "_instance", "_currentPlaythrough", "microseconds");
		return true;
	});
}

update {
    current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
}

isLoading {
    return true;
}

gameTime {
    long totalMicroseconds = current.levelRushMicroseconds + current.levelPlaythroughMicroseconds;
    long totalMilliseconds = totalMicroseconds / 1000;
    return TimeSpan.FromMilliseconds(totalMilliseconds);
}

split 
{
    return current.Scene != old.Scene;
}

start 
{
    return old.Scene != current.Scene && old.Scene == "Menu" && current.Scene != "Heaven_Environment";
}

reset 
{
    return old.Scene != current.Scene && current.Scene == "Menu";
}
