/// Returns if a Vinyl playback instance is paused
/// 
/// This function will return <undefined> if passed a label name as labels cannot have a "paused"
/// state in themselves. This function will further return <undefined> for audio played using
/// VinylPlaySimple()
/// 
/// @param vinylID

function VinylPausedGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    var _instance = _idToInstanceDict[? _id];
    return (_instance == undefined)? undefined : _instance.__PauseGet();
}