function [data] = PSIM_import(FilePath,variable_set,time_window,full)
%PSIM_IMPORT Function that manage the data from a PSIM file
%   Given as input a file of simulation data from PSIM, recognize the
%   variables and import them all in a structure
%   If the simulation is not parametric, it return a single structure,
%   otherwise it returns an array of structure
%   INPUT
%       - <strong>FilePath</strong>: path of the file to process
%       - <strong>time_window</strong>: time span for cutting the data
%       - <strong>full</strong>: flag in order to store the full length of the simulation 

if ~exist('time_window','var') || isempty(time_window)
    time_window = nan;
    full = 0;
end
    
if ~exist('full','var') || isempty(full)
    full = 0;
end

data = PSIM_readfile(FilePath);
variable_list = fieldnames(data);
variable_list = variable_list(2:end); %remove 'time' filed

if ~exist('variable_set','var') || isempty(variable_set)
    variable_set = variable_list;
end

% only the selected variable
data = rmfield(data,setdiff(variable_list,variable_set));
if ~all(ismember(variable_set,variable_list))
    variable_out = variable_set(~ismember(variable_set,variable_list));
    str_tmp = cellfun(@(x) strcat(39,x,39,','), variable_out, 'UniformOutput', false);
    warning('The following fields are not present: %s',[str_tmp{:}])
    variable_set = intersect(variable_list,variable_set);
end

if full
    for i = 1:length(data)
        data(i).full = data(i);
    end
end

if ~isnan(time_window)
    [~,idx1] = min(abs(data(1).t-time_window(1)));
    if time_window(2)==Inf
        idx2 = length(data(1).t);
    else
        [~,idx2] = min(abs(data(1).t-time_window(2)));
    end
    for i = 1:length(data)
        data(i).t = data(i).t(idx1:idx2);
        for j = 1:length(variable_set)
            data(i).(variable_set{j}) = data(i).(variable_set{j})(idx1:idx2);
        end
    end
end

end
