// Feather disable all

function __VedClassYYPAudioGroup() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    __soundNameArray = [];
    
    static __Add = function(_name)
    {
        array_push(__soundNameArray, _name);
    }
    
    static __Remove = function(_name)
    {
        var _index = __VedArrayFindIndex(__soundNameArray, _name);
        if (_index != undefined) array_delete(__soundNameArray, _index, 1);
    }
    
    static __CopyAssetArrayTo = function(_array)
    {
        array_copy(_array, array_length(_array), __soundNameArray, 0, array_length(__soundNameArray));
    }
    
    static __MoveAllToDefault = function()
    {
        var _audioGroupDict = _system.__project.__libAudioGroup.__GetDictionary();
        
        var _i = 0;
        repeat(array_length(__soundNameArray))
        {
            var _name = __soundNameArray[_i];
            
            var _sound = _audioGroupDict[$ _name];
            if (_sound != undefined) _sound.__SetAudioGroup(__VED_DEFAULT_AUDIO_GROUP);
            
            ++_i;
        }
        
        array_resize(__soundNameArray, 0);
    }
}