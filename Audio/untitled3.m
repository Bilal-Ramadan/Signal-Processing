r1=audiorecorder(8000,8,1);
disp('speak')
recordblocking(r1,10);
q1=getaudiodata(r1);
audiowrite('input1.wav',q1,8000);
play(r1);