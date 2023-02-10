/// Instantly stops a playback instance, or all instances assigned to the given label
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylStop(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__Stop();
    
    if (_id == undefined) return;
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__Stop();
}