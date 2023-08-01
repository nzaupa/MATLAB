function export_fig(fig_handle,filename)
%EXPORT_FIG Export a figure in pdf and dave the also *.fig
%   

if ~ishandle(fig_handle)
    warning('First argument must be a validi handle for a figure')
end

exportgraphics(fig_handle,strcat(filename,'.pdf'))

savefig(fig_handle,filename)


end

