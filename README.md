
# Convolution
Repository for Supercollider powered Raspberry Pi programmable portable synthesizer.

<p>Currently very messy and in active development.  Eventually the code base will stablize.  The goal is to create a programmable synth that removes many of the annoyances of getting supercollider set up on a raspberyy pi and the challenges for beginning programmers to write a hardware and software interface for supercollider.  Effectively sandboxing the process of coding synths, samplers, and filters in supercollider. Beginning programmers will be able to quickly create and perform custom insturments while being introduced to the power and flexibility of supercollider.  Advanced programmers will be to use this as a starting point for further development.</p>

<p>Currently the software will run on osx.  Testing on Windows shortly and on linux.  To run supercollider on raspberry pi takes more work and the documentation for that process is not complete yet.</p>

# How To Run in current state:
<ol>
<li> Download processing: <a href="www.processing.org">www.processing.org</a></li>
<li> Download SuperCollider: <a href="http://supercollider.github.io/">http://supercollider.github.io/</a></li>
<li> Download or Clone this repo and make sure you are on the note-expansion branch.</li>
<li> Open SuperCollider and then open convolution/supercollider/SuppercolliderFinalFiles/BasicBootRequirements.scd.</li>
<li> Follow the instructions in the comments to boot the server and load the required files.  The drum machine should begin playing an obnoxoius repetitive beat if it is working.</li>
<li> Open Processing and open the ConvolutionInterface.pde file and run it.  </li>
</ol>
<p>Once the matrix has played through once the drum machine should go silent.  Now you can turn on and off different instruments.  The up and down arrow allow you to switch instruments and then use the last two sliders to control amplitude and playback rate.  The others are not connected to controls on the synth server yet.  The left and right arrows allow you to change from drum machine to step sequencer to lead synth, though lead synth needs the physical interface to work.  Also, occasionally you cannot click on any buttons until you cycle through the modes at least once more.  </p>




