function [data] = import_oscilloscope(folder_path,ch_names,filter)
%IMPORT_OSCILLOSCOPE Import a set of homogeneous csv generated from OSC
%   The scpecific model is Tektronix MSO5204 (onboard Windows - lab URV)
%   Import file from a FOLDER
%   Export the data in a structure


% make sure that the string has a proper end '/'
if ~strcmp(folder_path(end),'/')
    folder_path = strcat(folder_path,'/');
end

% check for the filter
if ~exist('filter','var') || isempty(filter)
    %no filter
    filter = nan;
else
    % default filter
    [a,b] = butter(filter(1),filter(2));
end

% find the sub-folders with the files [with sub-folders]
files = dir(strcat(folder_path,'*.csv'));
files = {files.name}';  
if isempty(files)
    warning('No files found in folder %s',folder_path)
    data = [];
    return
end

names    = unique(cellfun(@(x) x(1:end-8),files,'UniformOutput',false));
channels = unique(cellfun(@(x) x(end-6:end-4),files,'UniformOutput',false));

% default name if not specified
if ~exist('ch_names','var') || isempty(ch_names)
    ch_names = channels;
elseif length(ch_names) ~= length(channels)
    warning('The label of the channels is not matching the actual number of channel found')
    ch_names(end+1:end+length(channels)-length(ch_names)) = channels(length(ch_names)+1:end);
end

data(length(names)) = struct;

% loop on all the unique filenames (except for the channel)
for i=1:length(names)
    % loop on the channels
    for j = 1:length(channels)
        % read the csv file
        A = readmatrix(strcat(folder_path,names{i},'_',channels{j},'.csv'));
        % time and general information import
        if j == 1
            data(i).t  = A(:,4); % time scale
            data(i).dt = A(2,2); % OSC sampling time
            data(i).N  = A(1,2); % number of samples
            data(i).f_file = str2double(names{i}(end-2:end))*1e3;
        else
            % double check that time scale is the same for all the files in the series
            assert(all(data(i).t==A(:,4)),'time is not matching!')
        end
        % read the channel
        if all(isnan(filter))
            % no filter needed
            data(i).(ch_names{j}) = A(:,5);
        else
            % apply the filter and save also the raw data 
            data(i).(strcat(ch_names{j},'_raw')) = A(:,5);
            data(i).(ch_names{j}) = filtfilt(a,b,A(:,5));
            % SOME safety check on the filter ???
        end
    end
    % put the initial time to zero
    data(i).t = data(i).t-data(i).t(1);

end




end