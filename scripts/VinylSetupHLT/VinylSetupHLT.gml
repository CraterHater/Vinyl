// Feather disable all

/// Sets up a head-loop-tail pattern for playback with Vinyl. When played, an HLT pattern will
/// first play the "head" sound. Once that sound has finished, the loop sound will be played.
/// After VinylHLTEndLoop() is called, the loop sound will play out and the tail sound will be
/// played.
/// 
/// You should typically only call this function once on boot. Subsequent calls to this function
/// will only affect audio that is already playing if VINYL_LIVE_EDIT is set to <true>, and even
/// then calls to this function whilst audio is playing is expensive.
/// 
/// @param patternName
/// @param [soundHead]
/// @param soundLoop
/// @param [soundTail]
/// @param [gain=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupHLT(_patternName, _soundHead = undefined, _soundLoop, _soundTail = undefined, _gain = 1, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    if (_mix == VINYL_NO_MIX) _mix = undefined;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_soundHead, _soundLoop, _soundTail, _gain, _mix);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternHLT(_patternName, _soundHead, _soundLoop, _soundTail, _gain, _mix);
    }
}