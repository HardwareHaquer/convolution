s.boot;
s.reboot
(
s.startAliveThread;
ServerBoot.add { s.initTree };
)

s.plotTree;
s.meter(2,8);

x = {SinOsc.ar(440)}.play
x.free;
s.killAll
s.quit