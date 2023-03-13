# Other Functions

&nbsp;

## `VinylTypeGet`

`VinylTypeGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* String, the type of a [voice](Voices)

|Name    |Datatype|Purpose            |
|--------|--------|-------------------|
|`target`|voice   |The voice to target|

This function can return one of the following values as strings: `"asset"` `"basic"` `"queue"` `"multi"`

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylNameGet`

`VinylNameGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* String, the name of a [voice](Voices)

|Name    |Datatype|Purpose            |
|--------|--------|-------------------|
|`target`|voice   |The voice to target|

The string returned by this function uniquely indentifies the voice, and further contains information on the pattern used to play the voice.

!> This function is on the slow side and is provided for debug use only.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPatternGet`

`VinylPatternGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* String or [audio asset](Overview) index, the pattern or audio asset used to create the voice

|Name    |Datatype|Purpose            |
|--------|--------|-------------------|
|`target`|voice   |The voice to target|

#### **Example**

```gml
//Only play this music track if the stack isn't already playing it
if (VinylStackPatternGet("music", 1) != sndChickenNuggets)
{
    VinylStackPush("music", 1, VinylPlay(sndChickenNuggets));
}
```

<!-- tabs:end -->

&nbsp;

## `VinylLabelVoicesGet`

`VinylLabelVoicesGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Array of [voices](Voices)

|Name  |Datatype|Purpose        |
|------|--------|---------------|
|`name`|string  |Label to target|

Returns an array containing every voice assigned to the label.

!> Do not modify the array returned by this function!

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLabelVoiceCountGet`

`VinylLabelVoiceCountGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the number of [voices](Voices) assigned to the label

|Name  |Datatype|Purpose        |
|------|--------|---------------|
|`name`|string  |Label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylSystemReadConfig`

`VinylSystemReadConfig(configStruct)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name          |Datatype|Purpose                                           |
|--------------|--------|--------------------------------------------------|
|`configStruct`|        |                                                  |

Updates Vinyl's internal configuration from a struct representation of the [configuration file](Config-File). You'll generally never need to call this if you've got live update enabled, but it is provided if you're building out a custom workflow of some kind (e.g. loading YAML-formatted configuration instead).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLiveUpdateSet`

`VinylLiveUpdateSet(state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                   |
|----------|--------|------------------------------------------|
|`state`   |boolean |Whether to enable or disable live updating|

Toggles live updating on and off. Live updating has a slight performance hit (moreso when storing your project on a "spinning disk" hard drive) so turning it off can be help for profiling and development in general.

?> This function will do nothing when running outside the IDE, or when not running on Windows, Mac, or Linux.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLiveUpdateGet`

`VinylLiveUpdateGet()`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether live updating of [Vinyl's configuration file](Config-File) is enabled

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This function will always return `false` when running outside the IDE, or when not running on Windows, Mac, or Linux.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->