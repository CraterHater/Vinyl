/// Returns the BPM for a Vinyl playback instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param [pitchAdjusted=false]

function VinylBPMGet(_id, _pitchAdjusted = false)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance))
    {
        var _bpm = _instance.__PersistentGet();
        if (_pitchAdjusted) _bpm *= _instance.__PitchGet();
        return _bpm;
    }
    
    return 0;
}