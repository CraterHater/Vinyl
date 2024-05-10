// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceBlend(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceStructDict   = __VinylSystem().__voiceStructDict;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    array_push(_voiceCleanUpArray, self);
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __gainBase = _pattern.__gain;
    
    if (_pattern.__noMix)
    {
        var _mixStruct = undefined;
        __gainMix = 1;
    }
    else
    {
        var _mixStruct = _mixDict[$ _pattern.__mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", _pattern.__mixName, "\" not recognised");
            return;
        }
        
        __gainMix = _mixStruct.__gainFinal;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    __blendFactor = 0;
    
    __voiceTop   = -1;
    __voiceArray = [];
    __gainArray  = [];
    
    var _soundArray = __pattern.__soundArray;
    if (array_length(_soundArray) > 0)
    {
        var _loop = _pattern.__loop ?? false;
        
        __voiceTop = audio_play_sound(_soundArray[0], 0, _loop, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
        __voiceArray[0] = __voiceTop;
        __gainArray[0] = 1;
        
        //Add the generated voice to the mix's array of voices
        if (_mixStruct == undefined) _mixStruct.__Add(__voiceTop);
        struct_set_from_hash(_voiceStructDict, int64(__voiceTop), self);
        
        var _i = 1;
        repeat(array_length(_soundArray)-1)
        {
            __voiceArray[_i] = audio_play_sound(_soundArray[_i], 0, _loop, 0, 0, __pitchLocal);
            __gainArray[_i] = 0;
            
            ++_i;
        }
    }
    
    __voiceCount = array_length(__voiceArray);
    
    
    
    
    
    static __Update = function(_delta)
    {
        __gainFadeOut -= _delta*__gainFadeOutSpeed;
        if (__gainFadeOut <= 0)
        {
            __Stop();
            return false;
        }
        
        __UpdateGain();
        return true;
    }
    
    static __UpdateGain = function()
    {
        var _voiceArray = __voiceArray;
        var _gainArray  = __gainArray;
        var _gainShared = __VINYL_VOICE_GAIN_EQUATION;
        
        var _i = 0;
        repeat(__voiceCount)
        {
            audio_sound_gain(_voiceArray[_i], _gainArray[_i]*_gainShared, VINYL_STEP_DURATION);
            ++_i;
        }
    }
    
    static __IsPlaying = function()
    {
        return (__voiceTop >= 0);
    }
    
    static __Stop = function()
    {
        if (__voiceTop >= 0)
        {
            __voiceTop = -1;
            
            var _i = 0;
            repeat(array_length(__voiceArray))
            {
                audio_stop_sound(__voiceArray[_i]);
                ++_i;
            }
        }
    }
    
    static __Pause = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            audio_pause_sound(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            audio_resume_sound(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __IsPaused = function()
    {
        if (__voiceTop < 0) return false;
        return audio_is_paused(__voiceTop);
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        if (__gainFadeOutSpeed == undefined) array_push(_voiceUpdateArray, self);
        __gainFadeOutSpeed = max(0.001, _rateOfChange);
    }
    
    static __SetLocalGain = function(_gain)
    {
        __gainLocal = _gain;
        __UpdateGain();
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = _gain;
        __UpdateGain();
    }
    
    static __SetBlend = function(_value)
    {
        __blendFactor = clamp(_value, 0, 1);
        
        if (__voiceCount <= 0) return;
        
        var _gainShared = __VINYL_VOICE_GAIN_EQUATION;
        
        //Scale up the blend factor to match the number of channels we have
        var _factor = clamp(__blendFactor, 0, 1)*(__voiceCount - 1);
        
        //Set channels using linear crossfades
        var _i = 0;
        repeat(__voiceCount)
        {
            var _gain = max(0, 1 - abs(_i - _factor));
            
            audio_sound_gain(__voiceArray[_i], _gain*_gainShared, VINYL_STEP_DURATION);
            __gainArray[_i] = _gain;
            
            ++_i;
        }
    }
    
    static __SetBlendAnimCurve = function(_value, _animCurve)
    {
        __blendFactor = clamp(_value, 0, 1);
        
        var _gainShared = __VINYL_VOICE_GAIN_EQUATION;
        
        //Set channels from the animation curve
        var _channelCount = array_length(animcurve_get(_animCurve).channels);
        var _i = 0;
        repeat(min(_channelCount, __voiceCount))
        {
            var _gain = max(0, animcurve_channel_evaluate(animcurve_get_channel(_animCurve, _i), __blendFactor));
            
            audio_sound_gain(__voiceArray[_i], _gain*_gainShared, VINYL_STEP_DURATION);
            __gainArray[_i] = _gain;
            
            ++_i;
        }
        
        //Set remaining channels to 0
        repeat(__voiceCount - _i)
        {
            audio_sound_gain(__voiceArray[_i], 0, VINYL_STEP_DURATION);
            __gainArray[_i] = 0;
            
            ++_i;
        }
    }
}