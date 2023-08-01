function plot_assign(handle,opt)
%PLOT_ASSIGN Assign the option to a plot handle
%   Given the option in the structure opt, assign them to  the plot passed
%   trough the handle 
%   Probably it is useless since this behavior is native in the plot
%   function

assert(ishandle(handle),'Input ax must be a graphic obejct corresponing to a plot');

if exist('opt','var') && ~isempty(opt)
   names = fields(opt);
   for i=1:length(names)
       handle.(names{i}) = opt.(names{i});
   end
else
    warning('No option are available to be assigned to the plot!')
end
end

