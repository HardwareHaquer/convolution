<b>Working Notes</b>

These will be streamlined into documentation of the project in the months to come.  
Currently, they are just a place to paste configuration settings.

<b>Jack Audio Settings</b>

Massive XRuns cause supercollider server to crash/quit after about 1 minute without these settings:

`jackd -P70 -d alsa -dhw:1 -p 128 -n 3 -r 48000 -s`

Values may change as I tweak to the best possible settings.

Settings are based on this site: http://wiki.linuxaudio.org/wiki/raspberrypi

Need to test: setting cpu_scaling to performance and turning off certain unneeded services, or running without desktop once interface is completed.


<b>Supercollider</b>

Running ide with `scide -style=gtkrc` makes tooltips legible which is crucial for training beginners.  
Hopefully his will be fixed in future version of SC and will not need change.


<b>How to open supercollider without IDE:

Mac: `/Applications/Supercollider/Supercollider.App/Contents/MacOS/sclang path/to/supercollider.scd`
Linux: just `sclang path/to/scfile.scd` after starting jackd
Also if running via ssh:<br>
`export DISPLAY=0.0`<br>
`jackd (the required options)`<br>
`sclang path/to/file.scd`

To quit sclang: `0.exit;`

These are steps toward running SC from boot without needing desktop and using openFrameworks as osc interface.

