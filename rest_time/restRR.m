
addpath '/Users/ivan/Documents/MATLAB/R_locs_mats_deadtime'

start_stop = dir('R_locs_mats_deadtime/*.mat');
sub_100_num = 31;
sub_200_num = 34;
windows_alpha1 = 4:16;

%% subject 100s
diff_100_alpha1 = zeros(1, sub_100_num);
diff_100_name = zeros(sub_100_num, 1);

diff_100_alpha2 = zeros(1, sub_100_num);

for index=1:sub_100_num
    list1 = load(start_stop(index).name);
    person_name = start_stop(index).name(3:5);
    diff_100_name(index) = str2double(person_name);
%     this loads the data in as the field is called r_loc_matrix
    raw_data = list1.r_loc_matrix;
    
    %% Do the following for each subject:
        % find the difference during each break and make a new array
    ind_diff = [];
    for i = 1:size(raw_data, 2)
        ind_data = nonzeros(raw_data(:,i));
        difference = diff(ind_data);
%         this allows to skip over the empty diff array
        ind_diff(end+1:end+numel(difference))= difference;
    end
    
%     alpha 1
    [alpha1,f] = DFA_fun(ind_diff, windows_alpha1);
    diff_100_alpha1(index) = alpha1(1);
    
%     alpha 2
    a2_start_x = log10(17);
    upper_bound = size(ind_diff);
    a2_end_x = log10(0.1*upper_bound(2));
    delta_x = 1/13; % 13 data points in each window.
    a2_num_points = ceil((a2_end_x-a2_start_x)/delta_x);
    % this the new window size n to run DFA on,
    % providing evenly spaced graph
    progress_x = zeros(1, a2_num_points);
    progress_x(1) = 17;
    
    for i = 2:a2_num_points
    temp = 10^(a2_start_x + delta_x*(i-1));
    progress_x(i) = floor(temp);
    end
    
    [alpha2, f2] = DFA_fun(ind_diff, progress_x);
    diff_100_alpha2(index) = alpha2(1);
end
diff_100_alpha1 = diff_100_alpha1.';
deadtime_100_alpha1(:,1) = diff_100_name;
deadtime_100_alpha1(:,2) = diff_100_alpha1;

deadtime_100_alpha2(:,1) = diff_100_name;
deadtime_100_alpha2(:,2) = diff_100_alpha2;

%% subject 200s
diff_200_alpha1 = zeros(1, sub_200_num);
diff_200_name = zeros(sub_200_num, 1);

diff_200_alpha2 = zeros(1, sub_200_num);

counter = 1;
for index=1+sub_100_num:sub_100_num+sub_200_num
    list1 = load(start_stop(index).name);
    person_name = start_stop(index).name(3:5);
    diff_200_name(counter) = str2double(person_name);

%     this loads the data in as the field is called r_loc_matrix
    raw_data = list1.r_loc_matrix;
    
    %% Do the following for each subject:
        % find the difference during each break and make a new array
    ind_diff = [];
    for i = 1:size(raw_data, 2)
        ind_data = nonzeros(raw_data(:,i));
        difference = diff(ind_data);
%         this allows to skip over the empty diff array
        ind_diff(end+1:end+numel(difference))= difference;
    end
    
    %     alpha 1
    [alpha1,f] = DFA_fun(ind_diff, windows_alpha1);
    diff_200_alpha1(counter) = alpha1(1);
    
    %     alpha 2
    a2_start_x = log10(17);
    upper_bound = size(ind_diff);
    a2_end_x = log10(0.1*upper_bound(2));
    delta_x = 1/13; % 13 data points in each window.
    a2_num_points = ceil((a2_end_x-a2_start_x)/delta_x);
    % this the new window size n to run DFA on,
    % providing evenly spaced graph
    d2_progress_x = zeros(1, a2_num_points);
    d2_progress_x(1) = 17;
    
    for i = 2:a2_num_points
        temp = 10^(a2_start_x + delta_x*(i-1));
        d2_progress_x(i) = floor(temp);
    end
    
    [d2_alpha2, d2_f2] = DFA_fun(ind_diff, d2_progress_x);
    diff_200_alpha2(counter) = d2_alpha2(1);
    counter = counter + 1;

end

diff_200_alpha1 = diff_200_alpha1.';
deadtime_200_alpha1(:,1) = diff_200_name;
deadtime_200_alpha1(:,2) = diff_200_alpha1;

deadtime_200_alpha2(:,1) = diff_200_name;
deadtime_200_alpha2(:,2) = diff_200_alpha2;
