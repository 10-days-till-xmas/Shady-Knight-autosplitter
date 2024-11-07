// By 10_days_till_xmas
// asl-help by Ero (https://github.com/just-ero/asl-help)

state("Shady Knight") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Shady Knight";

    vars.MissionStates = new ExpandoObject();
        vars.MissionStates.Intro = 0;
        vars.MissionStates.InProcess = 1;
        vars.MissionStates.Complete = 2;

    vars.Helper.AlertGameTime();
}   


onStart
{
    vars.TotalGameTime = 0d;
}

init
{
    vars.TotalGameTime = 0d;

    vars.WaitForGameTime = false;

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["MissionTime"] = mono.Make<float>("Game", "mission", "rawResults", "time");
        vars.Helper["MissionState"] = mono.Make<int>("Game", "mission", "state");
        vars.Helper["LevelIndex"] = mono.Make<int>("Game", "mission", "levelData", "index");

        return true;
    });
}

update
{
}

start 
{
    return old.MissionState == vars.MissionStates.Intro && current.MissionState == vars.MissionStates.InProcess;
}

split 
{
    return old.MissionState == vars.MissionStates.InProcess && current.MissionState == vars.MissionStates.Complete;
}

reset 
{
    if ( old.LevelIndex != current.LevelIndex )
        return current.MissionState != vars.MissionStates.Intro && current.MissionState == vars.MissionStates.Intro && old.LevelIndex != current.LevelIndex;
}

gameTime 
{
    if (current.MissionTime < old.MissionTime) {
        vars.TotalGameTime += old.MissionTime;
    }

    if (current.MissionState == 1)
        return TimeSpan.FromSeconds(vars.TotalGameTime + current.MissionTime);
}

isLoading 
{
    return true;
}
