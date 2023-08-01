function plot_hybrid(ax,x,y,optA,optB,tol)
%PLOT_HYBRID try to plot a hybrid solution in the plane
%   highligh the jumps with another color

if( ~ishandle(ax))
    error('Input ax must be a graphic obejct corresponing to axes');
end

cmap = colormap(lines); 
if( ~exist('optA','var') || isempty(optA) )
    
    optA.Color     = cmap(1,:);
    optA.LineStyle = '-';
    optA.LineWidth = 1;
    optA.Marker = 'none';
    optA.MarkerSize = 1;
end

if( ~exist('optB','var') || isempty(optB) )
    optB.Color     = cmap(3,:);
    optB.LineStyle = ':';
    optB.LineWidth = 1;
end

if( ~exist('tol','var') || isempty(tol) )
    tol=1.5;
end


if(ishold(ax))
    hold_prev = 'on';
else
    hold_prev = 'off';
end

% vector of distances between successive points

x_nan  = x(1);
y_nan  = y(1);
x_jump = [];
y_jump = [];

for i=2:length(x)
    if sqrt( (x(i)-x(i-1)).^2 + (y(i)-y(i-1)).^2) > tol
        x_nan(end+1:end+2)  = [NaN x(i)];
        y_nan(end+1:end+2)  = [NaN y(i)];
        x_jump(end+1:end+3) = [x(i-1) x(i) NaN];
        y_jump(end+1:end+3) = [y(i-1) y(i) NaN];
    else
        x_nan(end+1)  = x(i);
        y_nan(end+1)  = y(i);
    end
end

hold on
p = [];
plot(ax,x_nan,y_nan,optA);
q = [];
plot(ax,x_jump,y_jump,optB);


% if ~isempty(optA) && ~isempty(p)
%    plot_assign(p,optA)
% %    names = fields(optA);
% %    for i=1:length(names)
% %        p.(names{i}) = optA.(names{i});
% %    end
% end

% if ~isempty(optB) && ~isempty(q)
%     plot_assign(q,optB)
% %     names = fields(optB);
% %     for i=1:length(names)
% %         q.(names{i}) = optB.(names{i});
% %     end
% end

hold(ax,hold_prev);

end

