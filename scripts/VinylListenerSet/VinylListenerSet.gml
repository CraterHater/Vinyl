/// @param x
/// @param y

function VinylListenerSet(_x, _y)
{
    static _globalData       = __VinylGlobalData();
    static _panEmitterArray  = _globalData.__poolPanEmitter.__activeArray;
    static _effectChainArray = _globalData.__effectChainArray;
    
    if ((_x != _globalData.__listenerX) || (_y != _globalData.__listenerY))
    {
        _globalData.__listenerX = _x;
        _globalData.__listenerY = _y;
        
        audio_listener_set_position(VINYL_LISTENER_INDEX, _x, _y, 0);
        
        var _i = 0;
        repeat(array_length(_panEmitterArray))
        {
            _panEmitterArray[_i].__UpdatePosition();
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(_effectChainArray))
        {
            _effectChainArray[_i].__UpdatePosition();
            ++_i;
        }
    }
}