function plot_line(ax,arg,opt,mode,eqmode)
%PLOT_LINE plot a tilted line of angle theta
%   ...
%   How can we define a line:
%    - a*y + b*x + c = 0   --> arg = [a b c]
%    - y = tan(theta)*x    --> arg = [theta x0 y0] 
%                                      => a = cos(theta)
%                                      => b = -sin(theta)
%                                      => c = x0*sin(theta)-y0*cos(theta)
% 
%   mode define the type of line:
%    - 'full' line
%    - 'half' half-line
% 
%   eqmode define the type of input equation:
%    - 'implicit' => arg = [a b c]
%    - 'angle'    => arg = [theta x0 y0]
% 

if(ishold(ax))
    hold_prev = 'on';
else
    hold_prev = 'off';
    clf
end

if ~exist('mode','var') || isempty(mode)
   mode = 'full';
end

if ~exist('eqmode','var') || isempty(eqmode)
   eqmode = 'angle';
end

if ~exist('opt','var') || isempty(opt)
   opt = [];
end

% get current axes limit
x_lim = ax.XLim;
y_lim = ax.YLim;

x = x_lim + [-1 1]*(x_lim(2)-(x_lim(1)));
y = y_lim + [-1 1]*(y_lim(2)-(y_lim(1)));


hold on

if size(arg,2)==1
    eqmode = 'angle';
    % only theta set the point in the origin
    arg = [arg zeros(size(arg,1),2)];
end

switch lower(eqmode)
    case 'angle'
        a = +cos(arg(:,1));
        b = -sin(arg(:,1));
        c = arg(:,2).*sin(arg(:,1)) - arg(:,3).*cos(arg(:,1));
        a(abs(a)<eps) = 0;
        b(abs(b)<eps) = 0;
        c(abs(c)<eps) = 0; 
    case 'implicit'
        % remove BAD lines -> a,b==0
        bad = (arg(:,1)==0) & (arg(:,2)==0);
        arg(bad,:) = [];
        a = arg(:,1);
        b = arg(:,2);
        c = arg(:,3);
    otherwise
        error('equation mode %s not recognized',eqmode)
end

% identify the different type of lines

% VERTICAL a=0
v = (a==0);
if any(v)
    X_val = -c(v)./b(v);
    X = repmat([X_val X_val],sum(v),1);
    Y = repmat(y,sum(v),1);
    if isempty(opt)
        plot(X',Y')
    else
        plot(X',Y',opt)
    end
end

% HORIZONTAL b=0
h = (b==0);
if any(h)
    Y_val = -c(h)./a(h);
    Y = repmat([Y_val Y_val],sum(h),1);
    X = repmat(x,sum(h),1);
    if isempty(opt)
        plot(X',Y')
    else
        plot(X',Y',opt)
    end
end
% GENERIC
g = ~(v|h);
if any(g)
%     Y(:,1) = (-c(g)-b(g)*x(1))./a(g);
%     Y(:,2) = (-c(g)-b(g)*x(2))./a(g);
    Y = (-c(g)-b(g)*x)./a(g);
    X = repmat(x,sum(g),1);
    if isempty(opt)
        plot(X',Y')
    else
        plot(X',Y',opt)
    end
end


xlim(x_lim)
ylim(y_lim)

hold(ax,hold_prev)

end

