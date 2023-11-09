# Assets

&nbsp;

An asset is any [sound asset](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm) added to the GameMaker IDE. You can further define properties for these assets to [the configuration file](Config-File) in order to take advantage of Vinyl's features.

&nbsp;

## Properties

Assets should be set up in the [configuration file](Config-File).

|Property        |Datatype        |Default                             |Notes                                                                                                      |
|----------------|----------------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`                                 |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                 |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*                       |                                                                                                           |
|`bpm`           |number          |[`VINYL_DEFAULT_BPM`](Config-Macros)|                                                                                                           |
|`loop`          |boolean         |*passthrough*                       |                                                                                                           |
|`stack`         |string          |*passthrough*                       |[Stack](Stacks) to push voices to                                                                          |
|`stack priority`|number          |`0`                                 |Priority for voices when pushed to the stack above                                                         |
|`label`         |string or array |`[]`                                |Label to assign this asset to. Can be a string for a single label, or an array of label names              |
|`persistent`    |boolean         |*passthrough*                       |                                                                                                           |

## Examples

```
{ //Start of __VinylConfig
	...
    
	assets: { //Start of asset definitions

        sndGunshot: {
        	gain: 1.5 //Boom!
        }
        
        //Duplicate pitch randomisation across three different assets
        [sndFootstepGrass, sndFootstepMetal, sndFootstepWood]: {
        	pitch: [0.92, 1.08] //Vary the pitch as we're walking
        }

        sndPlayerMumble: {
        	gain: 0.9
        	label: speech //Use the "speech" label for extra control
        }

        sndMusic: {
        	loop: true
            stack: bgm //Use the background music stack
            //Stack priority defaults to 0
        }
        
        sndChestJingle: {
        	stack: bgm
        	stack priority: 1 //Duck lower priority music when we're playing
        }

		sndDeath: {
			gain: 1.4
			pitch: 0.9
			label: [sfx, speech]
		}

		sndTransition: {
			gain: 0.4
			persistent: true //Don't stop this audio between rooms
		}
        
        sndXylophone: {
        	transpose: 0 //We want to track the global transposition
        	pitch: [0.98, 1.02] //Add a subtle pitch variation on top
        }
	}

	...
}
```