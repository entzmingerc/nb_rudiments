# nb_rudiments
a port of the rudiments synth engine as an nb synth for norns

`nb` is a [voice library](https://github.com/sixolet/nb) for Norns.  
`nb_rudiments` is a port of the lofi percussion synth [rudiments](https://github.com/cfdrake/rudiments) as an nb voice to be played with any nb compatible norns script.  
it's a ...rudimentary port without many additional functions, just the engine with an added gain parameter and a tanh soft clipping on the output.  
  
1) download this like you would any other script  
2) turn on the mod: go to system > mods > find nb_rudiments, turn enc3 to the right until you see a +. this tells norns to load the mod at the next power ON  
3) go to system > restart and then check the mods, it should have a dot . to the left of the name indicating the mod has been loaded  
4) find a script that supports nb  
5) go to your params and select nb_rudiments from your nb voices  
6) start playing notes by calling player:note_on() like you would for other nb voices  
