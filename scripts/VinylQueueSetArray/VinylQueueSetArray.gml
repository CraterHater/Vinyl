// Feather disable all

/// Sets the queued sound for a queue voice. This function will "save" a copy of the input array
/// which means that any adjustment to the input array after calling VinylQueueSetArray() will not
/// alter what sounds are played back. You will need to call VinylQueueSetArray() again if you want
/// to change the internal sound array.
/// 
/// @param voice
/// @param soundArray

function VinylQueueSetArray(_voice, _soundArray)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    _voiceStruct.__soundArray = variable_clone(_soundArray);
}