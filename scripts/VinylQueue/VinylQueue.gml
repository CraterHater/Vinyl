/// @param source
/// @param ...

function VinylQueue()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (0) for VinylQueue()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternQueue(argument[0]); break;
        case 2: return new __VinylPatternQueue(argument[0], argument[1]); break;
        case 3: return new __VinylPatternQueue(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternQueue(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternQueue(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylQueue()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternQueue() constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceQueue);
    
    __sources = array_create(argument_count, undefined);
    __pop     = false;
    __popLast = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __VinylPatternizeSource(argument[_i]);
        ++_i;
    }
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    
    static GroupAdd      = __VinylPatternGroupAdd;
    static GroupDelete   = __VinylPatternGroupDelete;
    static GroupClear    = __VinylPatternGroupClear;
    static GroupAssigned = __VinylPatternGroupAssigned;
    
    #endregion
    
    
    
    #region Public Methods
    
    static PopSet = function(_pop, _dontPopLast)
    {
        __pop     = _pop;
        __popLast = _dontPopLast;
        return self;
    }
    
    static PopGet = function()
    {
        return {
            pop : __pop,
            popLast : __popLast
        };
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Queue " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}