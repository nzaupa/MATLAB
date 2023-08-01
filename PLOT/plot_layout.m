function [] = plot_layout(ax,font,width_height,ratio)
%PLOT_LAYOUT standardized the plot done with the same style
%   Take as input the axes of a figure and adapt them
%   Also activated the latex interpreter 
%   width_height set the windows size in point [bidimensional vector]

if( ~exist('font','var') || isempty(font) )
    font=10;
end

if( ~exist('ratio','var') || isempty(ratio) )
    ratio=false;
end

%% properties
set(ax, 'TickDir'   , 'in');
set(ax, 'XMinorTick', 'on');
set(ax, 'YMinorTick', 'on');
% try to save the x tick position

% set(ax, 'FontWeight', 'bold');
set(ax, 'FontSize'  , font);
set(ax, 'box'       , 'on');
grid(ax,'on')
grid(ax,'minor')
set(ax, 'TickLabelInterpreter', 'latex');
% put all like a row vector
ax = ax(:);

for i=1:length(ax)
    % legend in latex format
    xlabel(ax(i),ax(i).XLabel.String,'Interpreter','latex');
    ylabel(ax(i),ax(i).YLabel.String,'Interpreter','latex');
    zlabel(ax(i),ax(i).ZLabel.String,'Interpreter','latex');
    title(ax(i),ax(i).Title.String,'Interpreter','latex','FontSize',font);
    if(~isempty(ax(i).Legend))
%         legend(ax(i),ax(i).Legend.String,'Interpreter','latex');
        set(ax(i).Legend,'Interpreter','latex');
    end
    % aspect ratio for square
    if(ratio)
        ax(i).PlotBoxAspectRatio = [ax(i).XLim(2)-ax(i).XLim(1),ax(i).YLim(2)-ax(i).YLim(1),1];
    end
end

%% figure windows and resize

% detect monitors
% monitors = get(groot,'MonitorPositions');

if ( exist('width_height','var') && ~isempty(width_height) && ~all(isnan(width_height)))
    fig = ax.Parent;
    fig.Units = 'centimeters';
    ax.Units  = 'centimeters';
    dx = [ax.Position(1) fig.Position(3)-ax.Position(1)-ax.Position(3)];
    dy = [ax.Position(2) fig.Position(4)-ax.Position(2)-ax.Position(4)];

    % axes adjustment
    if(isnan(width_height(2)))    % set only width (height depend on the aspect ratio)
        ax.Position = [ax.Position(1:2) width_height(1) ...
            ax.Position(4)/ax.Position(3)*width_height(1)];
    elseif(isnan(width_height(1)))% set only height (width depend on the aspect ratio)
        ax.Position = [ax.Position(1:2)  ...
            ax.Position(3)/ax.Position(4)*width_height(2) width_height(2)];
    else
        ax.Position = [ax.Position(1:2) width_height(:)'];
    end
    % figure adjustment
    fig.Position = [fig.Position(1:2) ...
        dx(1)+ax.Position(3)+dx(2) ...
        dy(1)+ax.Position(4)+dy(2) ];
    
    % figure desktop limit
    fig.Units = 'normalized';
%     if (fig.OuterPosition(1)+fig.OuterPosition(3) > 1.0)
%         fig.Position(1) = 1.0-fig.OuterPosition(3);
%     end
    if (fig.OuterPosition(2)+fig.OuterPosition(4) > 1.0)
        fig.OuterPosition(2) = 1.0-fig.OuterPosition(4);
    end
    fig.Units = 'centimeters';
end

end

%% black BG
% fig.Color = [0.1 0.1 0.1];
% set(ax,'color',[0.1 0.1 0.1])
% ax.YColor = [1 1 1];
% ax.XColor = [1 1 1];



