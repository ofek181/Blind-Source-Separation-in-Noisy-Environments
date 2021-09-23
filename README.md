<p>Faculty of Engineering Bar Ilan University<br>
Signal Processing Laboratory</p>

# Blind Source Separation in Noisy Environments Using Model-based EM Algorithm
## Ofek Ophir<br>
#### Advisor: Mr. Aviad Eisenberg
#### Academic Advisor: Prof. Sharon Ganot<br>
![image](https://user-images.githubusercontent.com/80195693/134568276-145c3ed2-52ae-4c3d-9cb5-ef63c99eac08.png)

## Abstract

<p>Speech separation is a core problem is signal processing, real world speech signals
often involve distortions such as reverberation, interfering speakers, and noise.
In this context, source separation refers to the problem of extracting the target
speakers within the mixture while cancelling interfering speakers and/or noise.
This problem may arise in various real scenarios, for instance, spoken communication
over mobile phones, conference call systems, hearing aids and even video game
consoles.</p>

<p>In this project we present the problem of blind source separation of speech signals in
noisy environments using multiple microphones.<br>
Blind estimation of the acoustic parameters for each one of the source signals is
initialized using the Degenerate Unmixing Estimation Technique (DUET), and
carried out using the Expectation Maximization (EM) algorithm.<br>
The latent data are estimated in the E step of the algorithm, whereas in the M step,
the algorithm estimates the acoustic transfer function of each source and the noise
covariance matrix.</p>

<p>In the model presented in this project, the clean signal is assumed deterministic
unknown<br>
This means that only the a posteriori probabilities of the presence of each
source are estimated in the E step, while the time-frequency coefficients of the
parameters are estimated in the M step using the minimum variance distortionless
response beamformer (MVDR beamformer).</p>

<p>The algorithm was then tested using a noisy mixtures of two speech sources in
different reverberation and noise settings.<br>
The recording device used in this project is a MATRIX Voice (with 8 MEMs
microphone array) connected to a Raspberry Pi 3, giving us an 8-channel audio
signal of the mixture containing the two speakers in the presence of noise and
reverberation.</p>

This project is based on the paper:<br>
B. Schwartz, S. Gannot, E. Habets, "Two Model-Based EM Algorithms for Blind
Source Separation in Noisy Environment", "IEEE/ACM Transactions on Audio,
Speech, and Language Processing", 2017/01/<br>
A video demonstration of this project can be found in the following link:<br>
https://www.youtube.com/watch?v=3byVhd68VZQ
