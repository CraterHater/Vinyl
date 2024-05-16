// Feather disable all

/// Destroys a queue voice. This stops any currently playing audio and renders the queue voice
/// inoperable. This function is provided for convenience and You don't have to call this function
/// to manage memory.
/// 
/// @param voice

function VinylQueueDestroy(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__Destroy();
}