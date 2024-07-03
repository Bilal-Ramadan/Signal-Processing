fs=44100;     % sampling freq (Hz)

bits=16;      % Bit depth

nChannels=1;



%% record audio

 

recorder1=audiorecorder(fs,bits,nChannels);

recorder2=audiorecorder(fs,bits,nChannels);

data='int16';

disp("start");

recordblocking(recorder1,10);

disp("end");

disp("start");

recordblocking(recorder2,10);

disp("end");

y1=getaudiodata(recorder1,data);

y2=getaudiodata(recorder2,data);

audiowrite('input1.wav',y1,fs);

audiowrite('input2.wav',y2,fs);



%% read audio



[y1,fs]=audioread("input1.wav");

[y2,~]=audioread("input2.wav");

N=length(y1);



%% transefer to frequency domain



Y1=fft(y1,N);

Y2=fft(y2,N);



f=(-N/2:N/2-1)*fs/N;



%% plot the signals against frequency



tiledlayout(4,2);

nexttile

plot(f,abs(fftshift(Y1))/N)

title("input1 (before) against f")

xlabel('Frequency(Hz)');

ylabel('magnitude');

nexttile

plot(f,abs(fftshift(Y2))/N)

title("input2 (before) against f")

xlabel('Frequency(Hz)');

ylabel('magnitude');



%% design filter



% filterDesigner;



%% filter frequency



y_after1=filter(myfilter3,y1);

y_after2=filter(myfilter3,y2);

Y_after1=fft(y_after1,N);

Y_after2=fft(y_after2,N);



%% plot filtered audio



nexttile

plot(f,abs(fftshift(Y_after1))/N)

title("filtered input 1 against f")

xlabel('Frequency(Hz)');

ylabel('magnitude');

nexttile

plot(f,abs(fftshift(Y_after2))/N)

title("filtered input 2 against f")

xlabel('Frequency(Hz)');

ylabel('magnitude');



%% amplitude modulation variables



Ts = 1/fs;

fcarrier1 = 5000;

fcarrier2 = 16000;



%% modulation and combinning



y_modulated1 = y_after1 .* cos(2*pi*fcarrier1*Ts*(1:N).');

y_modulated2 = y_after2 .* cos(2*pi*fcarrier2*Ts*(1:N).');



TransmittedSignal = y_modulated1 + y_modulated2;

FTransmittedSignal = fft(TransmittedSignal,N);



%% plot combined signal



nexttile

plot(f,abs(fftshift(FTransmittedSignal))/N);

title('transmitted signal')

xlabel('Frequency(Hz)');

ylabel('magnitude');



%% demodulation and FFT



y_demodulated1 = TransmittedSignal .* cos(2*pi*fcarrier1*Ts*(1:N).');

y_demodulated2 = TransmittedSignal .* cos(2*pi*fcarrier2*Ts*(1:N).');



%% filtering after demodulation



y_demodulated_after1 = 2*filter(myfilter3,y_demodulated1);

y_demodulated_after2 = 2*filter(myfilter3,y_demodulated2);



Y_demodulated_after1=fft(y_demodulated_after1);

Y_demodulated_after2=fft(y_demodulated_after2);



%% plot demodulated signal



nexttile

plot(f,abs(fftshift(Y_demodulated_after1))/N);

title('input 1 demodulated');

xlabel('Frequency(Hz)');

ylabel('magnitude');

nexttile

plot(f,abs(fftshift(Y_demodulated_after2))/N);

title('input 2 demodulated');

xlabel('Frequency(Hz)');

ylabel('magnitude');



%% writing output



audiowrite('output1.wav', y_demodulated_after1, fs);

audiowrite('output2.wav', y_demodulated_after2, fs);