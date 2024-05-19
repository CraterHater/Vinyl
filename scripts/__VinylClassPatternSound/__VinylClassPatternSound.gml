// Feather disable all

/// @param sound
/// @param gain
/// @param pitch
/// @param loop
/// @param mix
/// @param duck
/// @param duckPrio
/// @param metadata

function __VinylClassPatternSound(_sound, _gain, _pitch, _loop, _mixName, _duckName, _duckPrio, _metadata) constructor
{
    static _mixDict         = __VinylSystem().__mixDict;
    static _duckDict        = __VinylSystem().__duckDict;
    static _toUpdateArray   = __VinylSystem().__toUpdateArray;
    static _voiceToSoundMap = __VinylSystem().__voiceToSoundMap;
    
    __sound    = _sound;
    __gain     = _gain;
    __pitch    = _pitch;
    __loop     = _loop;
    __mixName  = _mixName;
    __duckName = _duckName;
    __duckPrio = _duckPrio;
    __metadata = _metadata;
    
    
    
    
    
    static __Play = function(_loopLocal, _gainLocal, _pitchLocal, _duckNameLocal, _duckPrioLocal)
    {
        var _sound      = __sound;
        var _gainSound  = __gain;
        var _pitchSound = __pitch;
        var _mixName    = __mixName;
        
        if (__mixName == undefined)
        {
            var _mixStruct     = undefined;
            var _gainMix       = 1;
            var _loopFinal     = _loopLocal ?? __loop;
            var _duckNameFinal = _duckNameLocal ?? __duckName;
        }
        else
        {
            var _mixStruct = _mixDict[$ _mixName];
            if (_mixStruct == undefined)
            {
                __VinylError("Mix \"", _mixName, "\" not recognised");
                return;
            }
            
            var _gainMix       = _mixStruct.__gainFinal;
            var _loopFinal     = _loopLocal ?? (__loop ?? (_mixStruct.__membersLoop ?? false));
            var _duckNameFinal = _duckNameLocal ?? (__duckName ?? _mixStruct.__membersDuck);
        }
        
        if (_duckNameFinal != undefined)
        {
            var _duckStruct = _duckDict[$ _duckNameFinal];
            if (_duckStruct == undefined)
            {
                __VinylError("Duck \"", _duckNameFinal, "\" not recognised");
                return;
            }
            
            var _duckPrioFinal = _duckPrioLocal ?? (__duckPrio ?? 0);
            var _gainDuck = (_duckStruct.__maxPriority <= __duckPrio)? 1 : 0;
        }
        else
        {
            var _gainDuck = 1;
        }
        
        var _voice = audio_play_sound(_sound, 0, _loopFinal, _gainSound*_gainLocal*_gainMix*_gainDuck/VINYL_MAX_VOICE_GAIN, 0, _pitchSound*_pitchLocal);
        
        //If we're in live edit mode then always create a struct representation
        if (VINYL_LIVE_EDIT || (_duckNameFinal != undefined))
        {
            var _voiceStruct = new __VinylClassVoiceSound(_voice, _loopLocal, _gainSound, _gainLocal, _gainMix, _gainDuck, _pitchSound, _pitchLocal, _duckNameLocal, _duckPrioLocal, self);
        }
        
        if (_duckStruct != undefined) _duckStruct.__Push(_voiceStruct, _duckPrioFinal);
        if (_mixStruct != undefined) _mixStruct.__Add(_voice);
        
        _voiceToSoundMap[? _voice] = _sound;
        
        return _voice;
    }
    
    static __UpdateSetup = function(_gain, _pitch, _loop, _mixName, _duckName, _duckPrio, _metadata)
    {
        if (VINYL_LIVE_EDIT)
        {
            array_push(_toUpdateArray, self);
        }
        
        __gain         = _gain;
        __pitch        = _pitch;
        __loop         = _loop;
        __mixName      = _mixName;
        __duckName     = _duckName;
        __duckPrio = _duckPrio;
        __metadata     = _metadata;
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1, 1, false, (VINYL_DEFAULT_MIX == VINYL_NO_MIX)? undefined : VINYL_DEFAULT_MIX, undefined, 0, undefined);
    }
    
    static __ExportJSON = function(_ignoreEmpty)
    {
        if (_ignoreEmpty)
        {
            if ((__gain == 1) && (__pitch == 1) && (not __loop))
            {
                return undefined;
            }
        }
        
        var _struct = {
            sound: audio_get_name(__sound),
        };
        
        if (__gain != 1) _struct.gain = __gain;
        if (__pitch != 1) _struct.pitch = __pitch;
        if (__loop) _struct.loop = true;
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _ignoreEmpty)
    {
        if (_ignoreEmpty)
        {
            if ((__gain == 1) && (__pitch == 1) && (not __loop))
            {
                return undefined;
            }
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    sound: ");
        buffer_write(_buffer, buffer_text, audio_get_name(__sound));
        buffer_write(_buffer, buffer_text, ",\n");
        
        if (__gain != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    gain: ");
            buffer_write(_buffer, buffer_text, __gain);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__pitch != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    pitch: ");
            buffer_write(_buffer, buffer_text, __pitch);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__loop)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    loop: true,\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportSoundJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "sound":
                case "loop":
                case "gain":
                case "pitch":
                case "duck":
                case "duckPrio":
                case "metadata":
                break;
                
                default:
                    __VinylError("Sound \"", _json, "\" property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    var _sound = _json.sound;
    if (is_string(_sound))
    {
        var _handle = asset_get_index(_sound);
        if (not audio_exists(_handle))
        {
            __VinylTrace("Warning! Sound with name \"", _sound, "\" not found");
            return;
        }
    }
    else if (not is_handle(_sound))
    {
        __VinylError("Sound specified with incorrect datatype (", typeof(_sound), ")");
    }
    
    VinylSetupSound(_json.sound, _json[$ "gain"], _json[$ "pitch"], _json[$ "loop"], undefined, _json[$ "duck"], _json[$ "duckPrio"], _json[$ "metadata"]);
    
    return _json.sound;
}