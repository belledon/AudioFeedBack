function [trials] = genTrials(stims, ordering)

	% Goal is to produce trials according to the random order
	% and the given interstitiary

	numStims = length(ordering);
	
	% Apply the ordering and create trial structure
	for i = 1:numStims
		ind = ordering[i];
		trials(i).stim = stims{1}{ind};
		trials(i).delay = stims{2}[ind];
		trials(i).volume = stims{3}[ind];
		trials(i).pitch = stims{4}[ind];
	end

end