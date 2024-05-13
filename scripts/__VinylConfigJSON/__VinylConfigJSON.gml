// Feather disable all

/// This is an optional configuration script that you can edit. On boot, Vinyl will import the JSON
/// defined in this script by passing it into VinylSetupImportJSON().

global.VinylConfigSON = [
    {
        mix: "Test",
        members: [
            {
                sound: sndBleep0,
            },
            {
                sound: sndBleep1,
            },
            {
                shuffle: "Shuffle",
                gain: [0.9, 1.1],
                pitch: [0.8, 1.2],
                sounds: [sndBleep0, sndBleep1, sndBleep2, sndBleep3, sndBleep4, sndBleep5,
                         sndBleep6, sndBleep7, sndBleep8, sndBleep9, sndBleep10, sndBleep11,],
            },
            {
                hlt: "HLT",
                head: sndSync0,
                loop: sndSync1,
                tail: sndSync2,
            },
            {
                blend: "Blend",
                sounds: [sndSync0, sndSync1, sndSync2, sndSync3,],
            },
        ],
    },
];