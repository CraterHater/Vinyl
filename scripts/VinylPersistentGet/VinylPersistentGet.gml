/// Returns the persistence state of a Vinyl instance
/// 
/// This function will return <undefined> if passed a label name. This function will further
/// return <undefined> for audio played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylPersistentGet(_id)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance)) return _instance.__PersistentGet();
}