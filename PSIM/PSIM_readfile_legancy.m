function [data] = PSIM_readfile_legancy(FilePath)
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
A = readtable(FilePath);%,opts);
A = A(2:end,:);
% first column have the time vector
t = A.Time;
% recognize the different number of parameter
variable = A.Properties.VariableNames';
variable = variable(2:end); % remove the time (first)
% parametric = ~isempty(cell2mat(strfind(variable,'_01_01')));   % ! to make it work with old version of PSIM 9.1.1 !
parametric = ~isempty(cell2mat(strfind(variable,'_01')));   % ! PSIM 2022 !
    
% if it is parametric, need to isolate the single variable
if parametric
%     variable_list = cellfun(@(x) x(1:end-6),variable,'UniformOutput',0);
    variable_list = cellfun(@(x) x(1:end-3),variable,'UniformOutput',0);
    variable_list = unique(variable_list);
    n_params = length(cell2mat(strfind(variable,variable_list{1})));
    if n_params<1
        warning('No parameter!\n')
        return
    end
    assert(n_params<100,'Be aware, n_params=%i - dont know how the structure is made',n_params)
else
    variable_list = variable;
    n_params = 1;
end

data(1:n_params) = struct;
for j = 1:n_params
    data(j).t     = t;
    for i=1:length(variable_list)
        if parametric
%             data(j).(variable_list{i}) = A.(strcat((variable_list{i}),...
%                 '_',sprintf('%.2i',j),'_01'));
            data(j).(variable_list{i}) = A.(strcat((variable_list{i}),...
                '_',sprintf('%.2i',j)));
        else
            data(j).(variable_list{i}) = A.(strcat((variable_list{i})));
        end
    end
end
    
end
