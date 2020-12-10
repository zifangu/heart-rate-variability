% read in data
data = readmatrix('twenty_four.csv','OutputType','double');

% window sizes
windows_alph1 = 4:16;
windows_alph2 = 50:200;

%% 100 subject
subject100_num = 12;
ind_data_100_alpha1 = zeros(subject100_num, 2);
ind_data_100_alpha2 = zeros(subject100_num, 2);

for subject_count = 1:subject100_num
    subject_100_data = data(2:end,subject_count);
    subject_100_data = rmmissing(subject_100_data);
    len_100 = numel(subject_100_data);
    
    %     collect individual data    
%     [alpha1_100, f1_100] = DFA_fun(subject_100_data, windows_alph1);
%     ind_data_100_alpha1(subject_count, 1) = data(1, subject_count);
%     ind_data_100_alpha1(subject_count, 2) = alpha1_100(1);
    
% [alpha2_100, f2_100] = DFA_fun(subject_100_data, windows_alph2);
%     ind_data_100_alpha2(subject_count, 1) = data(1, subject_count);
%     ind_data_100_alpha2(subject_count, 2) = alpha2_100(1);

end

%% 200 subject
subject200_num = 15;
ind_data_200_alpha1 = zeros(subject200_num, 2);
ind_data_200_alpha2 = zeros(subject200_num, 2);


for subject_count = (1+subject100_num):(subject100_num+subject200_num)
    subject_200_data = data(2:end,subject_count);
    subject_200_data = rmmissing(subject_200_data);
    len_200 = numel(subject_200_data);
    
    %     collect individual data    
%     [alpha1_200, f1_200] = DFA_fun(subject_200_data, windows_alph1);
%     ind_data_200_alpha1(subject_count-subject100_num, 1) = data(1, subject_count);
%     ind_data_200_alpha1(subject_count-subject100_num, 2) = alpha1_200(1);
%  
%     [alpha2_200, f2_200] = DFA_fun(subject_200_data, windows_alph2);
%     ind_data_200_alpha2(subject_count-subject100_num, 1) = data(1, subject_count);
%     ind_data_200_alpha2(subject_count-subject100_num, 2) = alpha2_200(1);



end