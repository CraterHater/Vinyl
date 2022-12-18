function __VinylClassInstance() constructor
{
    __id = undefined;
    __pooled = true;
    
    __ResetState();
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for instance ", __id);
        
        __sound      = undefined;
        __loop       = undefined;
        __inputGain  = 0.0;
        __inputPitch = 1.0;
        
        __shutdown = false;
        
        __gainTarget  = 0.0;
        __gainRate    = VINYL_DEFAULT_GAIN_RATE;
        __pitchTarget = 1.0;
        __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
        
        __outputChanged = false;
        __outputGain    = 0.0;
        __outputPitch   = 1.0;
        
        __instance = undefined;
    }
    
    
    
    #region Gain
    
    static __InputGainSet = function(_gain)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " gain=", _gain, " db");
        }
        
        __inputGain  = _gain;
        __gainTarget = _gain;
    }
    
    static __InputGainTargetSet = function(_targetGain, _rate, _stopAtSilence)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain target for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " gain target=", _targetGain, " db, rate=", _rate, " db/frame, stop at silence=", _stopAtSilence? "true" : "false");
        }
        
        __gainTarget = _targetGain;
        __gainRate   = _rate;
        __shutdown   = _stopAtSilence;
    }
    
    static __FadeOut = function(_rate)
    {
        __InputGainTargetSet(VINYL_SILENCE, _rate, true);
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __InputPitchSet = function(_pitch)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " pitch=", 100*_pitch, "%");
        }
        
        __inputPitch  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __InputPitchTargetSet = function(_targetPitch, _rate)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch target for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " pitch target=", 100*_targetPitch, "%, rate=", 100*_rate, "%/frame");
        }
        
        __pitchTarget = _targetPitch;
        __pitchRate   = _rate;
    }
    
    #endregion
    
    
    
    static __Play = function(_sound, _loop, _gain, _pitch)
    {
        __sound      = _sound;
        __loop       = _loop ?? __GetLoopFromLabel();
        __inputGain  = _gain;
        __inputPitch = _pitch;
        
        __gainTarget  = __inputGain;
        __pitchTarget = __inputPitch;
        
        __RecalculateLabels();
        __instance = audio_play_sound(__sound, 1, __loop, __VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), 0, __outputPitch);
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch=", 100*__outputPitch, "%, label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", 100*__VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), "%)");
        }
        
        if (__outputGain > VINYL_SYSTEM_HEADROOM)
        {
            __VinylTrace("Warning! Gain value ", __outputGain, " exceeds VINYL_SYSTEM_HEADROOM (", VINYL_SYSTEM_HEADROOM, ")");
        }
    }
    
    static __GetAsset = function()
    {
        return global.__vinylAssetDict[$ __sound] ?? global.__vinylAssetDict.fallback;
    }
    
    static __GetLoopFromLabel = function()
    {
        var _asset = __GetAsset();
        return is_struct(_asset)? _asset.__GetLoopFromLabel() : false;
    }
    
    static __RecalculateLabels = function()
    {
        //Update the output values based on the asset and labels
        __outputGain  = __inputGain;
        __outputPitch = __inputPitch;
        
        var _asset = __GetAsset();
        if (is_struct(_asset))
        {
            __outputGain  += _asset.__gain;
            __outputPitch *= _asset.__pitch;
            
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                
                __outputGain  += _label.__outputGain;
                __outputPitch *= _label.__outputPitch;
                
                _label.__AddInstance(__id);
                
                ++_i;
            }
        }
    }
    
    static __Pause = function()
    {
        if (!is_numeric(__instance)) return;
        if (audio_is_paused(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing instance ", __id, " playing ", audio_get_name(__sound), " (GMinst=", __instance, ")");
        
        audio_pause_sound(__instance);
    }
    
    static __Resume = function()
    {
        if (!is_numeric(__instance)) return;
        if (!audio_is_paused(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming instance ", __id, " playing ", audio_get_name(__sound), " (GMinst=", __instance, ")");
        
        audio_resume_sound(__instance);
    }
    
    static __Stop = function()
    {
        if (__instance == undefined) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Forcing instance ", __id, " to stop (GMinst=", __instance, ")");
        
        audio_stop_sound(__instance);
        __instance = undefined;
        
        __Pool();
    }
    
    static __Depool = function(_id)
    {
        if (!__pooled) return;
        __pooled = false;
        
        __id = _id;
        global.__vinylIdToInstanceDict[? _id] = self;
        array_push(global.__vinylPlaying, self);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Depooling an instance as ID ", __id);
    }
    
    static __Pool = function()
    {
        if (__pooled) return;
        __pooled = true;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pooling instance ", __id);
        
        __Stop();
        
        //Remove this instance from all labels that we're attached to
        var _asset = __GetAsset();
        if (is_struct(_asset))
        {
            var _id = __id;
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _audioArray = _labelArray[_i].__audioArray;
                var _j = 0;
                repeat(array_length(_audioArray))
                {
                    if (_audioArray[_j] == _id)
                    {
                        array_delete(_audioArray, _j, 1);
                        break;
                    }
                    
                    ++_j;
                }
                
                ++_i;
            }
        }
        
        __ResetState();
        
        ds_map_delete(global.__vinylIdToInstanceDict, __id);
        
        //Move this instance to the "return" array
        //This prevents an instance being pooled and depooled in the same step
        //which would lead to problems with labels tracking what they're playing
        array_push(global.__vinylPoolReturn, self);
        
        __id = undefined;
    }
    
    static __Tick = function()
    {
        if (!audio_is_playing(__instance))
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Instance ", __id, " has stopped played, returning to pool");
            __Pool();
        }
        else
        {
            var _delta = clamp(__gainTarget - __inputGain, -__gainRate, __gainRate);
            if (_delta != 0)
            {
                __inputGain  += _delta;
                __outputGain += _delta;
                __outputChanged = true;
                
                if (__shutdown && (_delta < 0) && ((__inputGain <= VINYL_SILENCE) || (__outputGain <= VINYL_SILENCE)))
                {
                    __Stop();
                    return;
                }
            }
            
            var _delta = clamp(__pitchTarget - __inputPitch, -__pitchRate, __pitchRate);
            if (_delta != 0)
            {
                __inputPitch  += _delta;
                __outputPitch += _delta;
                __outputChanged = true;
            }
            
            if (__outputChanged)
            {
                __outputChanged = false;
                
                if (VINYL_DEBUG_LEVEL >= 2)
                {
                    __VinylTrace("Updated instance ", __id, " playing ", audio_get_name(__sound), ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch=", 100*__outputPitch, "%, label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", 100*__VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), "%)");
                }
                
                audio_sound_gain(__instance, __VinylGainToAmplitude(__outputGain - VINYL_SYSTEM_HEADROOM), VINYL_STEP_DURATION);
                audio_sound_pitch(__instance, __outputPitch);
            }
        }
    }
    
    static __DebugLabelNames = function()
    {
        var _asset = __GetAsset();
        return is_struct(_asset)? _asset.__DebugLabelNames() : "";
    }
}