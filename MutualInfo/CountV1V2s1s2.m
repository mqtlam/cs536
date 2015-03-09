function [ nuv ] = CountV1V2s1s2( v1, v2, nStates, samples)
% Returns the count of samples with V1 = s1 and V2 = s2
    % All possible combination of states,
    % Count the number of samples which satisfies the condition
    nuv = zeros(nStates);
    for s1=1:nStates
        for s2=1:nStates
            nuv(s1,s2) = length(find(samples(v1,:) == s1 & samples(v2,:) == s2));
        end
    end
end

