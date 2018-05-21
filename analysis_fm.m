%% 4th semester project - Analysis of FM Signals:

clc;
clear all;
close all;

%defining parameters
fm = 5;  %Message Frequency
fc = 30; %Carrier Frequency
mi = 3;  %Modulation Index
t=0:0.0001:1; %time range
NS=10000; 

%% Signal Definitions:

m=cos(2*pi*fm*t); %Message signal
subplot(3,1,1);
plot(t,m);
xlabel('Time');
ylabel('Amplitude');
title('Message Signal');
grid on;

c=sin(2*pi*fc*t); %carrier signal
subplot(3,1,2);
plot(t,c);
xlabel('Time');
ylabel('Amplitude');
title('Carrier Signal');
grid on;

y=cos(2*pi*fc*t+(mi.*sin(2*pi*fm*t)));%Frequency modulated signal
subplot(3,1,3);
plot(t,y);
xlabel('Time');
ylabel('Amplitude');
title('FM Signal');
grid on;


%% Analysis in Frequency Domain

figure(2);
ff = fft(y,NS); %fft of fm signal
ttt = 0:NS-1;
xlim([0 80]);
plot(ttt,abs(ff));

sidamp = (1/2)*besselj(0:mi,mi);
sidamp = [fliplr(sidamp(2:end)), sidamp];
sidf = (fc-mi*fm):fm:(fc+mi*fm); %collection of frequencies of peaks
plot(ttt,abs(ff),sidf,sidamp,'o')
xlim([0 80])
title('FFT Of Periodic Signal');
xlabel('Frequency in HZ');

%result: fd(frequency deviation)
fd_1 = (sidf(mi*2+1)-sidf(1))/2;

%% Analysis in Time Domain:

figure(3);
zzz = hilbert(y);  %hilbert transform of fm signal
instfreq = NS/(2*pi)*diff(unwrap(angle(zzz)));
plot(t(2:end),instfreq)
title('Instantaneous Frequency');
xlabel('Time');
ylabel('Frequency in Hz');
maxf = max(instfreq);
minf = min(instfreq);

%result: fd(frequency deviation)
fd_2 = (maxf - minf)/2; 

%% Demodulation:

figure(4)
z = fmdemod(y,fc,10000,fd_1); %getting message signal again
plot(t,z);
title('Demodulated Signal');
xlabel('Time');
ylabel('Amplitude');
