// Feather disable all
function __VinylClassPatternFallback() : __VinylClassPatternCommon() constructor
{
    static __patternType = __VINYL_PATTERN_TYPE_FALLBACK;
    static __pool = __VinylGlobalData().__poolSound;
    
    static __name  = __VINYL_FALLBACK_NAME;
    static __child = false;
    
    static toString = function()
    {
        return "<fallback>";
    }
    
    static __Serialize = function(_struct)
    {
        __SerializeShared(_struct);
        
        //Force the name and child state
        _struct.__name  = __VINYL_FALLBACK_NAME;
        _struct.__child = false;
    }
    
    static __Deserialize = function(_struct, _child)
    {
        __DeserializeShared(_struct, _child);
        
        //Force the name and child state
        __name  = __VINYL_FALLBACK_NAME;
        __child = false;
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, _sound, _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1, _effectChainName = __effectChainName)
    {
        return __VinylPlaySimple(_sound, _gain*__gain[0], _gain*__gain[1], _pitch*__pitch[0], _pitch*__pitch[1], __labelArray, _effectChainName);
    }
}
