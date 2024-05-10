// Feather disable all

/// @param patternName
/// @param soundHead
/// @param soundLoop
/// @param soundTail
/// @param gain
/// @param mix

function __VinylClassPatternHLT(_patternName, _soundHead, _soundLoop, _soundTail, _gain, _mix) constructor
{
    __patternName = _patternName;
    
    __soundHead = __VinylImportSound(_soundHead);
    __soundLoop = __VinylImportSound(_soundLoop);
    __soundTail = __VinylImportSound(_soundTail);
    __gain      = _gain;
    
    __SetMix(_mix);
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceHLT(self, _gainLocal, _pitchLocal);
        return _struct.__currentVoice;
    }
    
    static __UpdateSetup = function(_soundHead, _soundLoop, _soundTail, _gain, _mix)
    {
        __soundHead = __VinylImportSound(_soundHead);
        __soundLoop = __VinylImportSound(_soundLoop);
        __soundTail = __VinylImportSound(_soundTail);
        __gain      = _gain;
        
        __SetMix(_mix);
        
        if (VINYL_LIVE_EDIT)
        {
            //TODO
        }
    }
    
    static __SetMix = function(_mix)
    {
        __mixName = _mix;
        __noMix   = (_mix == undefined) || (_mix == VINYL_NO_MIX);
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(__soundHead, __soundLoop, __soundTail, 1, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function()
    {
        var _struct = {
            hlt: __patternName,
        };
        
        if (__soundHead != undefined) _struct.head = audio_get_name(__soundHead);
        if (__soundLoop != undefined) _struct.loop = audio_get_name(__soundLoop);
        if (__soundTail != undefined) _struct.tail = audio_get_name(__soundTail);
        
        if (__gain != 1) _struct.gain = __gain;
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _useMacros)
    {
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    hlt: ");
        
        if (_useMacros)
        {
            buffer_write(_buffer, buffer_text, __VinylGetPatternMacro(__patternName));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        else
        {
            buffer_write(_buffer, buffer_text, "\"");
            buffer_write(_buffer, buffer_text, __patternName);
            buffer_write(_buffer, buffer_text, "\",\n");
        }
        
        if (__soundHead != undefined)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    head: ");
            buffer_write(_buffer, buffer_text, audio_get_name(__soundHead));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__soundLoop != undefined)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    loop: ");
            buffer_write(_buffer, buffer_text, audio_get_name(__soundLoop));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__soundTail != undefined)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    tail: ");
            buffer_write(_buffer, buffer_text, audio_get_name(__soundTail));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__gain != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    gain: ");
            buffer_write(_buffer, buffer_text, __gain);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportHLTJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "hlt":
                case "head":
                case "loop":
                case "tail":
                case "gain":
                break;
                
                default:
                    __VinylError("Head-Loop-Tail pattern property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "loop")) __VinylError("Head-Loop-Tail pattern \"", _json.hlt, "\" property .loop must be defined");
    }
    
    VinylSetupHLT(_json.hlt, _json[$ "head"], _json.loop, _json[$ "tail"], _json[$ "gain"]);
    
    return _json.hlt;
}