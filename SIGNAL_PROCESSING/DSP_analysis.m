function [X_out,Y_out,phase] = DSP_analysis(t,x,y)
%DSP_ANALYSIS Estimate amplitude, frequency and phase shift
%   Detailed explanation goes here
% created 18 July 2023
% Nicola ZAUPA
% 
% NEED to increase the robusteness
% 
% X_out = [amp_1st_harm,freq_1st_harm,DC]
% 
%  the resolution of the DSP processing depends on the sampling frequency
%  and on the period. It can be calculated as
%  f_res = samplig_freq/number_samples = 1/acquisition_interval


% analysis of X
[X,f] = fft_single_sided(x,t(2)-t(1));
[pks,loc] = findpeaks(X,'MinPeakProminence',max(abs(x))/20);


if loc(1)~=1
    X_out(1) = pks(1);
    X_out(2) = f(loc(1));
    X_out(3) = X(1);
else % DC component is read as a peak
    X_out(1) = pks(2);
    X_out(2) = f(loc(2));
    X_out(3) = X(1);
end


% analysis of Y
[Y,f] = fft_single_sided(y,t(2)-t(1));
[pks,loc] = findpeaks(Y,'MinPeakProminence',max(abs(y))/20);


if loc(1)~=1
    Y_out(1) = pks(1);
    Y_out(2) = f(loc(1));
    Y_out(3) = Y(1);
else % DC component is read as a peak
    Y_out(1) = pks(2);
    Y_out(2) = f(loc(2));
    Y_out(3) = Y(1);
end


%% IMPROVE frequency estimation of x

% T_est = 1/ X_out(2);
% N = floor(t(end)/T_est);


% phase shift
% phase(1,1) = phdiffmeasure(x,y);
% approximated
% remove the offset
x = x-mean(x);
y = y-mean(y);
phase = acos(dot(x,y)/(norm(x)*norm(y)));
% phase(2,1) = acos(dot(x,y)/(norm(x)*norm(y)));

% return
% 
% % if ~exist('ratio','var') || isempty(ratio)
% %     ratio = 10;
% % % ratio = 2;  %% for tank analysis
% % % ratio = 10; %% for other analysis
% % end
% % 
% % if ~exist('absolute','var') || isempty(absolute)
% %     absolute = false;
% % % ratio = 2;  %% for tank analysis
% % % ratio = 10; %% for other analysis
% % end
% % m
% % 
% % 
% % if ~exist('y','var') || isempty(y)
% %     Y = [];
% %     phase = [];
% %     flag = false;
% %     assert(length(t)==length(x),'vector must have the same size')
% % else
% %     flag = true;
% %     assert(length(t)==length(x) && length(t)==length(y),'vector must have the same size')
% % end
% % 
% % 
% % if absolute
% %     x = abs(x);
% %     y = abs(y);
% % end
% % 
% % % findpeaks(x,'MinPeakProminence',max(abs(x))/10)
% % [pks,loc] = findpeaks(x,'MinPeakProminence',max(abs(x))/ratio);
% % 
% % if nargout == 4
% %     % compute the mean value of the first signal
% %     [pks2] = -findpeaks(-x,'MinPeakProminence',max(abs(x))/ratio);
% %     if length(pks2)>length(pks)
% %         average = mean([pks ;pks2(1:length(pks))]);
% %     else
% %         average = mean([pks(1:length(pks2)) ;pks2]);
% %     end
% % end
% % 
% 
% 
% %% 
% % amplitute
% X(1,1) = mean(pks);
% X(2,1) = std(pks);
% 
% % frequency
% f = t(loc);
% f = f(2:end)-f(1:end-1);
% f = 1./f;
% 
% X(1,2) = mean(f)/2;  % half because we are analyzing the mean value
% 
% if flag
%     [pks,loc] = findpeaks(y,'MinPeakProminence',max(abs(y))/ratio);
%     Y(1,1) = mean(pks);
%     Y(2,1) = std(pks);
%     % frequency
%     f = t(loc);
%     f = f(2:end)-f(1:end-1);
%     f = 1./f;
% 
%     Y(1,2) = mean(f);
%     
%     % FFT
%     phase(1,1) = phdiffmeasure(x,y);
%     % approximated
%     % remove the offset
%     x = x-mean(x);
%     y = y-mean(y);
%     phase(2,1) = acos(dot(x,y)/(norm(x)*norm(y)));
%     
%     phase = phase(2,1);
% end

end

