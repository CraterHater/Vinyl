hltVoice   = undefined;
blendVoice = undefined;

duckPrio0 = undefined;
duckPrio1 = undefined;
duckPrio2 = undefined;

///*
VinylSetupImportJSON([
    {
        ducker: "ducker test",
    },
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
    {
        mix: "Ducking Mix",
        membersDuckOn: "ducker test",
        members: [
            {
                sound: sndSync0,
                duckPrio: 0,
            },
            {
                sound: sndSync1,
                duckPrio: 1,
            },
            {
                sound: sndSync2,
                duckPrio: 2,
            },
            {
                sound: sndSync3,
                duckPrio: 3,
            },
        ],
    },
]);
//*/

show_debug_message(json_stringify(VinylSetupExportJSON(), true));
show_debug_message(__VinylSetupExportGMLMacros());
show_debug_message(__VinylSetupExportGML(true));