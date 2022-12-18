/// @param name
/// @param parent
/// @param dynamic
/// @param label

function __VinylClassLabel(_name, _parent, _dynamic, _labelData = {}) constructor
{
    __name    = _name;
    __parent  = _parent;
    __dynamic = _dynamic;
    
    __assetGain  = _labelData[$ "gain" ] ?? 0;
    __assetPitch = _labelData[$ "pitch"] ?? 1;
    
    __limitMaxCount    = _labelData[$ "limit"] ?? infinity;
    __limitFadeOutRate = abs(_labelData[$ "limit fade out rate"] ?? VINYL_DEFAULT_GAIN_RATE);
    
    __audioArray = [];
    
    __inputGain  = 0;
    __inputPitch = 1;
    
    __gainTarget    = 0.0;
    __gainRate      = VINYL_DEFAULT_GAIN_RATE;
    __stopAtSilence = false;
    
    __pitchTarget  = 1.0;
    __pitchRate    = VINYL_DEFAULT_PITCH_RATE;
    __stopOnTarget = false;
    
    __outputGain  = 0;
    __outputPitch = 1;
    
    if (VINYL_DEBUG_PARSER) __VinylTrace("Creating label definition for \"",__name, "\", gain=", __assetGain, " db, pitch=", 100*__assetPitch, "%, max instances=", __limitMaxCount);
    
    
    
    static __Stop = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylStop(__audioArray[_i]);
            ++_i;
        }
        
        array_resize(__audioArray, 0);
    }
    
    static __Pause = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylPause(__audioArray[_i]);
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylResume(__audioArray[_i]);
            ++_i;
        }
    }
    
    /*
    static __HasAncestor = function(_label)
    {
        if (__parent == _label) return true;
        if (is_struct(__parent)) return __parent.__HasAncestor(_label);
        return false;
    }
    */
    
    static __CopyOldState = function(_oldLabel)
    {
        __inputGain  = _oldLabel.__inputGain;
        __inputPitch = _oldLabel.__inputPitch;
        
        __gainTarget    = _oldLabel.__gainTarget;
        __gainRate      = _oldLabel.__gainRate;
        __stopAtSilence = _oldLabel.__stopAtSilence;
        
        __pitchTarget  = _oldLabel.__pitchTarget;
        __pitchRate    = _oldLabel.__pitchRate;
        __stopOnTarget = _oldLabel.__stopOnTarget;
        
        if (VINYL_DEBUG_PARSER)
        {
            __VinylTrace("Copying state to label \"", __name, "\":");
            __VinylTrace("    gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch in=", 100*__inputPitch, "%/out=", 100*__outputPitch, "%");
            __VinylTrace("    gain target=", __gainTarget, " dB, rate=", __gainRate, " dB, stop on silence=", __stopAtSilence? "true" : "false");
            __VinylTrace("    pitch target=", __pitchTarget, "%, rate=", __pitchRate, " dB, stop on target=", __stopOnTarget? "true" : "false");
        }
    }
    
    static __AddInstance = function(_id)
    {
        if (__limitMaxCount >= 0)
        {
            while (array_length(__audioArray) >= __limitMaxCount)
            {
                var _oldestInstance = global.__vinylIdToInstanceDict[? __audioArray[0]];
                array_delete(__audioArray, 0, 1);
                
                if (is_struct(_oldestInstance))
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Label \"", __name, "\" will exceed ", __limitMaxCount, " playing instance(s), fading out oldest instance ", _oldestInstance.__id, " playing ", audio_get_name(_oldestInstance.__sound));
                    _oldestInstance.__InputGainTargetSet(VINYL_SILENCE, __limitFadeOutRate, true, true);
                }
            }
        }
        
        //Add this instance to each label's playing array
        //Playing instances are removed from labels inside the label's __Tick() method
        //  N.B. This has no protection for duplicate entries!
        array_push(__audioArray, _id);
    }
    
    
    
    #region Gain
    
    static __InputGainSet = function(_gain)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" gain=", _gain, " db");
        }
        
        __inputGain  = _gain;
        __gainTarget = _gain;
    }
    
    static __InputGainTargetSet = function(_targetGain, _rate, _stopAtSilence, _shutdown)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" gain target=", _targetGain, " db, rate=", _rate, " db/frame, stop at silence=", _stopAtSilence? "true" : "false");
        }
        
        __gainTarget    = _targetGain;
        __gainRate      = _rate;
        __stopAtSilence = _stopAtSilence;
    }
    
    static __FadeOut = function(_rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Fading out ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylFadeOut(__audioArray[_i]);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __InputPitchSet = function(_pitch)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" pitch=", 100*_pitch, "%");
        }
        
        __inputPitch  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __InputPitchTargetSet = function(_targetPitch, _rate, _stopOnTarget, _shutdown)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" pitch target=", 100*_targetPitch, "%, rate=", 100*_rate, "%/frame, stop on target=", _stopOnTarget? "true" : "false");
        }
        
        __pitchTarget  = _targetPitch;
        __pitchRate    = _rate;
        __stopOnTarget = _stopOnTarget;
    }
    
    #endregion
    
    
    
    static __Tick = function()
    {
        //Update input values based on gain/pitch target
        var _delta = clamp(__gainTarget - __inputGain, -__gainRate, __gainRate);
        if (_delta != 0)
        {
            __inputGain += _delta;
            if (__stopAtSilence && (_delta < 0) && ((__inputGain <= VINYL_SILENCE) || (__outputGain <= VINYL_SILENCE))) __Stop();
        }
        
        var _delta = clamp(__pitchTarget - __inputPitch, -__pitchRate, __pitchRate);
        if (_delta != 0)
        {
            __inputPitch += _delta;
            if (__stopOnTarget && (__inputPitch == __pitchTarget)) __Stop();
        }
        
        //Update the output gain
        var _gainDelta  = __outputGain;
        var _pitchDelta = __outputPitch;
        
        __outputGain  = __inputGain  + __assetGain;
        __outputPitch = __inputPitch * __assetPitch;
        
        if (is_struct(__parent))
        {
            __outputGain  += __parent.__outputGain;
            __outputPitch *= __parent.__outputPitch;
        }
        
        _gainDelta  = __outputGain  - _gainDelta;
        _pitchDelta = __outputPitch / _pitchDelta;
        
        //If our values have changed at all, iterate over instances that are labelled to use us
        if ((_gainDelta != 0) || (_pitchDelta != 1))
        {
            var _i = 0;
            repeat(array_length(__audioArray))
            {
                var _instance = global.__vinylIdToInstanceDict[? __audioArray[_i]];
                if (!is_struct(_instance))
                {
                    array_delete(__audioArray, _i, 1);
                }
                else
                {
                    _instance.__outputChanged = true;
                    
                    _instance.__outputGain  += _gainDelta;
                    _instance.__outputPitch *= _pitchDelta;
                    
                    ++_i;
                }
            }
        }
    }
}