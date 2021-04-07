close all
clear all
clc

filename = 'Chris_o.txt';
fid = fopen(filename,'rt');
for x=1:5
    tline = fgetl(fid);
end
[Re,n] = fscanf(fid,'%i');
fclose(fid);

filename = 'Chris_n.txt';
fid = fopen(filename,'rt');
for x=1:5
    tline = fgetl(fid);
end
[Im,n] = fscanf(fid,'%i');
fclose(fid);
Fs=20000.0;
NFFT=256;
tc = complex(Re,Im);
w  = window(@hann,NFFT);
start=1;

%% Set up the movie.
writerObj = VideoWriter('cholinger_-2k_Qdemod_2_-2kHz.avi'); % Name it.
writerObj.FrameRate = 30; % How many frames per second.
open(writerObj); 

for i=1:500
    cdop = tc(start:start+255);
    [Pxx,F] = periodogram(cdop,w,NFFT,Fs);
    Pxx = log10(Pxx);
    plot(F-10e3,[Pxx(129:256); Pxx(1:128)]);
    axis([-1e4 1e4 -10 3])
    grid on;
    xlabel('Frequenz in Hz');
    ylabel('log(Power)');
    %A(:,i)=getframe(fig1,winsize); 
    start=start+128;
    frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
    writeVideo(writerObj, frame);
end

close(writerObj); % Saves the movie.

