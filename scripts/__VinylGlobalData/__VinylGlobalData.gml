function __VinylGlobalData()
{
    static _struct = {
        __listenerX: 0,
        __listenerY: 0,
        
        __panEmitterActive:     [],
        __panEmitterPool:       [],
        __panEmitterPoolReturn: [],
    };
    
    return _struct;
}