function [data] = PSIM_readfile(FilePath)
%PSIM_READFILEe Function that read the data from a PSIM file
%   Given as input a file of simulation data from PSIM, recognize the
%   variables and import them all in a structure
%   If the simulation is not parametric, it return a single structure,
%   otherwise it returns an array of structure
%   INPUT
%       - <strong>FilePath</strong>: path of the file to process

if exist(FilePath,'file') ~= 2
    warning('The file %c%s%c do not exist!\n',39,FilePath,39)
    return
end

% opts = detectImportOptions(FilePath);
warning off
A = readtable(FilePath);%,opts);
warning on
% A = A(2:end,:);
% first column have the time vector
t = A.Time;
% recognize the different number of parameter
variable = A.Properties.VariableNames';
variable = variable(2:end); % remove the time field (first)
n_param = max(cellfun('length',strfind(variable,'_01'))); % number of different sweep parameter
parametric = n_param>0;

%identify the number of parameters
 
%  !!! can use a file generated with the simulation to import the data, it
%  has the parameters in the first columns

% if it is parametric, need to isolate the single variable
if parametric
    % find the number of levels for each parameter
%     variable_list = cellfun(@(x) x(1:end-6),variable,'UniformOutput',0);
    n_levels = nan(1,n_param);
    for j=1:n_param
        n_levels(end-j+1) = max(cell2mat(cellfun(@(x) str2num(x(end-3*j+2:end-3*j+3)),variable,'UniformOutput',0)));
    end
    variable_list = cellfun(@(x) x(1:end-3*n_param),variable,'UniformOutput',0);
    variable_list = unique(variable_list);
%     n_levels = length(cell2mat(strfind(variable,variable_list{1})));
    if n_param<1
        warning('No parameter!\n')
        return
    end
    assert(all(n_levels)<100,'Be aware, n_params=%i - dont know how the structure is made',n_levels)
else
    variable_list = variable;
    n_param  = 1;
    n_levels = 1;
end

data = struct;
if parametric
    if n_param == 1
        for j = 1:n_levels
            data(j).(variable_list{i}) = A.(strcat((variable_list{i}),...
                    '_',sprintf('%.2i',j)));
        end
    elseif n_param == 2
        for j = 1:n_levels(1)
            for k = 1:n_levels(2)
                data(j,k).t = t;
                for i=1:length(variable_list)
                    data(j,k).(variable_list{i}) = A.(strcat((variable_list{i}),...
                        '_',sprintf('%.2i_%.2i',j,k)));
                end
            end
        end
    else
        warning('Number of parameters higher than 2: %d',n_param)
    end

else
    for i=1:length(variable_list)
        data.(variable_list{i}) = A.(strcat((variable_list{i})));
    end
end


    
end
