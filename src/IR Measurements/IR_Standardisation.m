% Script to realign and crop all .wav files to remove reverb 
% Main file to use to generate .mat data for
% Interpolation_horizontal_plane.m 

% Initialisation: 
addpath(genpath('/home/bngzl/Documents/Final Year Project/final_year_project/src/Past Measurements/909b Horizontal Plane 1/Audio/rvrb_sweep_909b'))
addpath(genpath('Impulse Response Conversion'))

clear all; 
in.signal_opts.settings = {20, 24000, 0.6, 48000};
in.gain_opts.gain = 1;

nDirections = 72; % 72 directions from azimuth 0 to 355 
time_before_rvrb = 501; % To determine this using 20logabs plots 
nChannels = 4; 

% Initialise matrix ir_standardised
% ir_standardised will be an aligned and trimmed matrix consisting of audio
% info from all nChannels and nDirections 
ir_standardised = zeros(time_before_rvrb, nChannels, nDirections); 

for i = 0:(nDirections-1) % last direction 355 indexed at 71 
    index = i; 
    audioFileName = sprintf('/home/bngzl/Documents/Final Year Project/final_year_project/src/Past Measurements/909b Horizontal Plane 1/Audio/rvrb_sweep_909b/rvrb_sweep_azimuth_%d.wav', index); 
    [in.rawResponse in.fs] = audioread(audioFileName);
    ir = recover_RIR_from_recorded_sweep(in); 
    
    % Align signal according to Loopback delay 
    % Need to remove the computational delay introduced by the DSP chip 
    loopback_channel = ir(:,5); 
    [~, x_align] = max(loopback_channel); % Find sample with largest response 
                                          % i.e time index of the impulse response of the loopback channel
    
    % Short script to visually determine where to trim reverb (use 20log10
    % plot) - Obtain time_before_rvrb variable visually 
    % Comment out once figured where to trim reverb signal 
%     ir_aligned = ir(x_align+1:x_align+time_before_rvrb,1:4); % 500 is arbitrary to ensure arrays are same sized
%     figure;
%     plot(20*log10(abs(ir_aligned)))
    
    % ir_standardised is a matrix of aligned and trimmed signals for all
    % nChannels 
    % Use this to generate .mat data:
    ir_standardised(:,:,i+1) = ir(x_align+1:x_align+501,1:4); % after loopback delay (x_align+1) to end 
    % i+1 to start matlab index at 1
end
save ('ir_standardised_horizontal_plane_909b.mat', 'ir_standardised'); 