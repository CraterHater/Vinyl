/// Starts playing a sound and returns a Vinyl ID to identify the playback instance
/// 
/// Vinyl IDs are separate from GameMaker's native audio instances IDs and the two sets of
/// IDs cannot be used interchangeably
/// 
/// There is a perfomance overhead when creating and maintaining Vinyl audio instances. In
/// resource-constrained situations, you may want to consider using VinylPlaySimple() for some
/// of your audio
/// 
/// @param emitter
/// @param sound
/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlayOnEmitter(_emitter, _sound, _loop = undefined, _gain = 1, _pitch = 1)
{
    if (!is_struct(_emitter) || !is_instanceof(_emitter, __VinylClassEmitterRef)) __VinylError("Emitter not valid");
    if (!is_struct(_emitter.__emitter)) __VinylError(_emitter, " has been destroyed");
    
    return __VinylPatternGet(_sound).__Play(_emitter, _sound, _loop, _gain, _pitch, undefined).__id;
}