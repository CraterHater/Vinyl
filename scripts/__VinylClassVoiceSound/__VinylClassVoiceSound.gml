// Feather disable all

/// @param voice
/// @param loopLocal
/// @param gainBase
/// @param gainLocal
/// @param gainMix
/// @param pitchBase
/// @param pitchLocal
/// @param [pattern]
/// @param [gainFactor]
/// @param [pitchFactor]

function __VinylClassVoiceSound(_voice, _loopLocal, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, _pattern, _gainFactor, _pitchFactor) constructor
{
    static _voiceLookUpDict   = __VinylSystem().__voiceLookUpDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    __voice      = _voice;
    __loopLocal  = _loopLocal;
    __gainBase   = _gainBase;
    __gainLocal  = _gainLocal;
    __gainMix    = _gainMix;
    __pitchBase  = _pitchBase;
    __pitchLocal = _pitchLocal;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern     = _pattern;
        __mixName     = (_pattern != undefined)? _pattern.__mixName : undefined;
        __gainFactor  = _gainFactor;
        __pitchFactor = _pitchFactor;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    array_push(_voiceCleanUpArray, self);
    struct_set_from_hash(_voiceLookUpDict, int64(_voice), self);
    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", _voice, " to voice lookup struct");
    
    
    
    
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voice);
    }
    
    static __Stop = function()
    {
        audio_stop_sound(__voice);
    }
    
    static __Pause = function()
    {
        audio_pause_sound(__voice);
    }
    
    static __Resume = function()
    {
        audio_resume_sound(__voice);
    }
    
    static __IsPaused = function()
    {
        return audio_is_paused(__voice);
    }
    
    static __Update = function(_delta)
    {
        __gainFadeOut -= __gainFadeOutSpeed*_delta;
        if (__gainFadeOut <= 0)
        {
            __Stop();
            return false;
        }
        
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
        return true;
    }
    
    static __CheckForCleanUp = function()
    {
        if (not audio_is_playing(__voice))
        {
            //FIXME - Replace with struct_remove_from_hash() when that is made available
            struct_set_from_hash(_voiceLookUpDict, int64(__voice), undefined);
            if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Removing ", __voice, " from voice lookup struct");
            
            return true;
        }
        
        return false;
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        if (__gainFadeOutSpeed == undefined) array_push(_voiceUpdateArray, self);
        __gainFadeOutSpeed = max(0.001, _rateOfChange);
    }
    
    static __SetLocalGain = function(_gain)
    {
        __gainLocal = max(0, _gain);
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = _gain;
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetFromPattern = function(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mixName)
    {
        __gainBase  = lerp(_gainMin,  _gainMax,  __gainFactor);
        __pitchBase = lerp(_pitchMin, _pitchMax, __pitchFactor);
        
        __VinylVoiceMoveMix(__voice, _mixName);
        
        audio_sound_loop( __voice, __loopLocal ?? _loop);
        audio_sound_gain( __voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
        audio_sound_pitch(__voice, __VINYL_VOICE_PITCH_EQUATION);
    }
}