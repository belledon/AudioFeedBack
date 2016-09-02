function [audio, time] = DAPresTrial(trial, window, tbt, inter)

	
	% Present the text on screen
	DrawFormattedText(window, trial.stim, 'center', 'center');
	Screen('Flip', window);

	% Open the audio channel and record
	audio = DelayedSoundFeedback(trial.delay);

	% Present the interstitial trial for alloted time
	if strcmp(inter, 'blank')
		Screen('Flip', window);
		WaitSecs(tbt);
	end
	
end

