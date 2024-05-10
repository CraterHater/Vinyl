// Feather disable all

/// @param voice
/// @param gainBase
/// @param gainLocal
/// @param gainMix
/// @param pitchBase
/// @param pitchLocal
/// @param [pattern]
/// @param [gainFactor]
/// @param [pitchFactor]

function __VinylClassVoiceSound(_voice, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, _pattern, _gainFactor, _pitchFactor) constructor
{
    static _voiceStructDict   = __VinylSystem().__voiceStructDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    array_push(_voiceCleanUpArray, self);
    struct_set_from_hash(_voiceStructDict, int64(_voice), self);
    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", _voice, " to voice lookup struct");
    
    __voice      = _voice;
    __gainBase   = _gainBase;
    __gainLocal  = _gainLocal;
    __gainMix    = _gainMix;
    __pitchBase  = _pitchBase;
    __pitchLocal = _pitchLocal;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern     = _pattern;
        __gainFactor  = _gainFactor;
        __pitchFactor = _pitchFactor;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    
    
    
    
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
}