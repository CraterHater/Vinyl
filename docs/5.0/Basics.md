# Basics

&nbsp;

Functions on this page relate to using Vinyl at a basic level - playing audio, stopping audio, and pausing/resuming audio.

&nbsp;

## `VinylPlaySimple`

`VinylPlaySimple(sound, [gain=1], [pitch=1])`

&nbsp;

*Returns:* GameMaker [sound instance](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm)

|Name     |Datatype        |Purpose                                                                                                                                                                           |
|---------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                                                    |
|`[gain]` |number          |Instance gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|
|`[pitch]`|number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                                       |

Plays an asset, taking advantage of Vinyl's live updating configuration (including labels). However, this function does **not** create a full fat [Vinyl instance](Terminology) and is, in effect, only a wrapper around GameMaker's native [`audio_play_sound()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm) with the gain and pitch calculated through Vinyl.

!> `VinylPlaySimple()` returns a GameMaker sound instance and **not** a Vinyl instance. As such, the sound instance is not compatible with other Vinyl functions and is provided for your convenience only.

&nbsp;

## `VinylPlay`

`VinylPlay(sound, [loop], [gain=1], [pitch=1], [pan])`

&nbsp;

*Returns:* Vinyl instance

|Name     |Datatype        |Purpose                                                                                                                                                                           |
|---------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                                                    |
|`[loop]` |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop                          |
|`[gain]` |number          |Instance gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|
|`[pitch]`|number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                                       |
|`[pan]`  |number          |Panning value, from `-1` (left) to `0` (centre) to `+1` (right). Defaults to no panning                                                                                           |

Plays an asset or pattern with the desired settings and returns a [Vinyl instance](Terminology). This instance can then be used with many other Vinyl functions to manipulate and adjust the sound.

!> In the interests of managing performance, if no panning value is specified then the returned instance cannot be panned later with `VinylPanSet()`.

&nbsp;

## `VinylPlayFadeIn`

`VinylPlayFadeIn(sound, [loop], [targetGain=1], [rate=VINYL_DEFAULT_GAIN_RATE], [pitch=1])`

&nbsp;

*Returns:* Vinyl instance

|Name          |Datatype        |Purpose                                                                                                                                                 |
|--------------|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`       |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                          |
|`[loop]`      |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop|
|`[targetGain]`|number          |Target gain, in normalised gain units                                                                                                                   |
|`[rate]`      |number          |Speed to approach the target gain, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`                                                      |
|`[pitch]`     |number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                             |

A convenience function that starts playing an asset or pattern at silence and then gradually increases its gain to reach the given target. This function is effectively the same as:

```gml
var instance = VinylPlay(sound, loop, 0, pitch);
VinylGainTargetSet(instance, targetGain, rate);
return instance;
```

&nbsp;

## `VinylFadeOut`

`VinylFadeOut(id, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                   |
|--------|--------------|------------------------------------------------------------------------------------------|
|`id`    |Vinyl instance|Instance to target                                                                        |
|`[rate]`|number        |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for a [Vinyl instance](Terminology) or [Vinyl label](Terminology). This puts the instance into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

If an instance is specified, the instance's gain will decrease at the given rate (in normalised gain units per second) until the gain reaches zero, at which point the sound is stopped and the instance is marked as destroyed.

If a label is specified, each currently playing instance assigned to that label will fade out. The label itself has no "fade out" state and any new instances will be played at their normal gain.

&nbsp;

## `VinylStop`

`VinylStop(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

Immediately stops playback of a Vinyl instance and marks it as destroyed.

If a label is specified, each currently playing instance assigned to that label will be immediately stopped. The label itself has no "stopped" state and any new instances will be played as normal.

&nbsp;

## `VinylStopAll`

`VinylStopAll()`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Immediately stops playback of all currently Vinyl instance and marks them as destroyed.

&nbsp;

## `VinylExists`

`VinylExists(id)`

&nbsp;

*Returns:* Boolean, whether the given [Vinyl instance](Terminology) or [Vinyl label](Terminology) exists

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylPause`

`VinylPause(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

Pauses playback of a [Vinyl instance](Terminology). Playback can be resumed using `VinylResume()` (see below).

If a label is specified instead then all currently playing instances assigned to the label are paused individually. The label itself does not hold a "paused" state and any new audio played on that label will not start paused.

&nbsp;

## `VinylPausedGet`

`VinylPausedGet(id)`

*Returns:* Boolean, whether the given [Vinyl instance](Terminology) is paused

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

?> You cannot get a "paused" state from a label as they have none.

&nbsp;

## `VinylResume`

`VinylResume(id)`

&nbsp;

*Returns:*

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

Resumes playback of a [Vinyl instance](Terminology). If a label is provided instead then all currently playing instances assigned to the label are resumed.