%avPresent.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is designed to present a set of 
% trials containing a set of text and variables 
% for real-time audio manipulation on the subjects
% voice. The trials are given a random order and
% no stimuli are preloaded prior to presentation. 
% This reduces RAM usage but may include a time
% variance of <20ms 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    %% I/O settings
    % keyboard
    KbName('UnifyKeyNames');
    numberKeys = 97:105;
    keySpace = KbName('space');
    keyEsc = KbName('escape');
    RestrictKeysForKbCheck([numberKeys, keySpace, keyEsc]);
    LoadPsychHID;
    % screen
    windowOpts.screenRect = [];
    windowOpts.xstart = 10;
    windowOpts.ystart = 10;
    if ~isempty(windowOpts.screenRect)
        windowOpts.space = windowOpts.screenRect(3)*0.03;
    else
        windowOpts.space = 1920*0.03;
    end
    windowOpts.textColor = [0,0,0];
    close all;
    % audio
    InitializePsychSound;
%     Screen('Preference', 'SkipSyncTests', 1);
%     Screen('Preference', 'VisualDebugLevel',   1);
    %% Log settings
    fmtNames = 'trial\tresponse\tanswer\ttime\tstimuli\n';
    
    %% Experiment settings
    rand('seed', sum(100*clock));
    dir  = cd;
    dataDir = strrep(cd, 'ptb_scripts','ptb_data');
    typeDir = dataDir; stimDir = dataDir; interDir = dataDir; audioDir = dataDir; msgDir = dataDir;
    
    
    stimfrmt = '%s\t%d\t%d\t%d';
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Subject
    prompt = {'Please enter your name:' ,'and age:'};
    dlg_title = '';
    answer = inputdlg(prompt,dlg_title);
    if isempty(answer{1})
        name = 'test';
        age = 99;
    else
        name = answer{1};
        age = answer{2};
    end
    
    %% Get stimuli
    
    stimFile = fopen(fullfile(typeDir, 'stims.txt'), 'r');
    stims = textscan(stimFile, '%s\t%d\t%d\t%d');
    fclose(stimFile);
    numStims = size(stims,1);

    % for the intersitial image
    inter = 'blank';
    %% Generate random ordering
    ordering = randPerm(numStims)';


    %% Generate trials
    trials = genTrials(stims, ordering);

    %% Create screen for PsychToolBox
    
    screen = Screen('Screens');
    window = Screen('OpenWindow', screen, [255,255,255], windowOpts.screenRect);
      
    
    %% Consent/Greeting
    greetingFn = fullfile(msgDir, 'greeting_consent.txt');
    yPos = seqPresentMessage(window, greetingFn, 'windowOpts', windowOpts);
    Screen('Flip', window);
    rKey = checkKey(0.01);
    if eqKey(keyEsc, rKey)
        fprintf('aborted at consent \n');
        Screen('CloseAll');
        return
    elseif eqKey(keySpace, rKey)
        fprintf('Consent granted \n');
    else
        Screen('CloseAll')
        fprintf('Subject pressed the wrong key \n')
        
        return
    end
    
    %% Begin testing
    
    iTestingFn = fullfile(msgDir, 'instructions_testing.txt');
    
    
    seqPresentMessage(window, iTestingFn, 'windowOpts', windowOpts);
    Screen('Flip', window);
    rKey = checkKey(0.01);
    if eqKey(keySpace, rKey)
        fprintf('accepted testing instructions, beginning... \n');
        testTrials = DATester(trials, subject); %todo (finish subject)
        fprintf('finished trials, exiting... \n');
    else
        fprintf('aborted at testing instructions, quitting... \n');
        Screen('CloseAll')
    end
    Screen('CloseAll')
    PsychPortAudio('Close', []);
    ShowCursor;
    
catch ME
    Screen('CloseAll')
    PsychPortAudio('Close', []);
    ShowCursor;
    rethrow(ME)
end
