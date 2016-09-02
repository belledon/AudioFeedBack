function [results] = DATester(trials, options)

	givenOptions = fieldnames(options)

	% Check to see if the window is provided
	if any(strcmp('window', givenOptions))
		window = options.window;
	else
		window = 0;
	end

	% Check to see if the time between trials is given
	if any(strcmp('tbt', givenOptions))
		tbt = options.tbt;
	else
		tbt = 1.0;
	end

	% Check to see if the interstitial trial is given
	if any(strcmp('inter', givenOptions))
		inter = option.inter;
	else
		inter = 'blank';
	end

	% Run the trials and record audio
	numTrials = length(trials);
	
	for i = 1:numTrials
		trials(i).audio = DAPresTrial(trials(i), tbt, inter);
	end

	results = trials;
end