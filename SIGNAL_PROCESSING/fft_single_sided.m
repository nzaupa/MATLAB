function [X,f] = fft_single_sided(x,dt)
%FFT_SINGLE_SIDED Compute the fft and retrieve the single sided spectrum
%   Essentially it's the implementation of the MATLAB help of the fft
%   function

Fs = 1/dt;       % Sampling frequency                    
L = length(x);   % Length of signal

if mod(L,2)
    % L is odd, so we need to cut one sample
    L = L-1;
    x = x(1:end-1);
end

X = fft(x);

P2 = abs(X/L);               % modulus of the fft (magnitude)
P1 = P2(1:L/2+1);            % half-spectrum
P1(2:end-1) = 2*P1(2:end-1); % double except for the DC value

X = P1;
f = Fs*(0:(L/2))/L;

end