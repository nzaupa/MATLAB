function plot_line_old(ax,theta,opt,q)
%PLOT_LINE plot a tilted line of angle theta
%   ...
if(ishold(ax))
    hold_prev = 'on';
else
    hold_prev = 'off';
end

if ~exist('q','var') || isempty(q)
   q = 0;
end

% get current axes limit
x = ax.XLim;
y = ax.YLim;

hold on

if theta ~= pi/2
    p = plot(x+q,x*tan(theta));
else
    p = plot([q,q],y);
end
xlim(x)
ylim(y)

if exist('opt','var') && ~isempty(opt)
   plot_assign(p,opt)
end

hold(ax,hold_prev)

end

