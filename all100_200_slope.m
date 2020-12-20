
% 1. Find the average of alpha 1 (4-16) and alpha 2 (new ticks)
% 2. Reloop through the subjects to find a subject that has
%    the least deviation from the average
% 3. Plot the graphs



%% 1. Find the average of alpha 1 (4-16) and alpha 2 (new ticks)
data_100 = readmatrix('all_100.csv','OutputType','double');
data_200 = readmatrix('all_200.csv', 'OutputType','double');
data_100 = data_100.';
data_200 = data_200.';

% window sizes
upper_bound = size(data_100);
windows_alph1 = 4:16;
windows_alpha2 = 17:(upper_bound * 0.10);
d2_windows_alpha2 = 17:(size(data_200)*0.1);

% subject 100s initialization
% alpha 1
subject100_num = 31;
ind_data_alpha1 = zeros(subject100_num, 2);
subject200_num = 33;
d2_ind_data_alpha1 = zeros(subject200_num, 2);

% alpha 2
% subject 100s
ind_data_alpha2 = zeros(subject100_num, 2);
a2_start_x = log10(17);
a2_end_x = log10(windows_alpha2(end));
delta_x = 1/13; % 13 data points in each window.
a2_num_points = ceil((a2_end_x-a2_start_x)/delta_x);

% subject 200s
d2_ind_data_alpha2 = zeros(subject200_num, 2);
d2_a2_end_x = log10(d2_windows_alpha2(end));
d2_a2_num_points = ceil((d2_a2_end_x-a2_start_x)/delta_x);

% this the new window size n to run DFA on,
% providing evenly spaced graph
progress_x = zeros(1, a2_num_points);
progress_x(1) = 17;

d2_progress_x = zeros(1, d2_a2_num_points);
d2_progress_x(1) = 17;

for i = 2:a2_num_points
    temp = 10^(a2_start_x + delta_x*(i-1));
    progress_x(i) = floor(temp);
end

for i = 2:d2_a2_num_points
    temp = 10^(a2_start_x + delta_x*(i-1));
    d2_progress_x(i) = floor(temp);
end

for subject_count = 1:subject100_num
    temp_data1 = data_100(2:end,subject_count);
    temp_data1 = rmmissing(temp_data1);
    
%  collecting alpha 1
    [alpha1, f1] = DFA_fun(temp_data1, windows_alph1);
    ind_data_alpha1(subject_count, 1) = data_100(1, subject_count);
    ind_data_alpha1(subject_count, 2) = alpha1(1);
    
%  collecting alpha 2
    [alpha2, f2] = DFA_fun(temp_data1, progress_x);
    ind_data_alpha2(subject_count, 1) = data_100(1, subject_count);
    ind_data_alpha2(subject_count, 2) = alpha2(1);
    
%   plot(log10(progress_x), log10(f2), "o");
end

for subject_count = 1:subject200_num
    temp_data1 = data_200(2:end,subject_count);
    temp_data1 = rmmissing(temp_data1);
    
%  collecting alpha 1
    [alpha1, f1] = DFA_fun(temp_data1, windows_alph1);
    d2_ind_data_alpha1(subject_count, 1) = data_200(1, subject_count);
    d2_ind_data_alpha1(subject_count, 2) = alpha1(1);
    
%  collecting alpha 2
    [alpha2, f2] = DFA_fun(temp_data1, d2_progress_x);
    d2_ind_data_alpha2(subject_count, 1) = data_200(1, subject_count);
    d2_ind_data_alpha2(subject_count, 2) = alpha2(1);
    
%   plot(log10(progress_x), log10(f2), "o");
end




%% 2. Find a subject that has the least deviation from the average

d1_alpha1_avg = mean(ind_data_alpha1(:,2));
d1_alpha2_avg = mean(ind_data_alpha2(:,2));
d2_alpha1_avg = mean(d2_ind_data_alpha1(:,2));
d2_alpha2_avg = mean(d2_ind_data_alpha2(:,2));

[res, index] = min(abs(ind_data_alpha1(:,2) - d1_alpha1_avg) + abs(ind_data_alpha2(:,2) - d1_alpha2_avg));
d1_rep = rmmissing(data_100(2:end,index));    

% find subjects clests to the mean values

[res2, index2] = min(abs((d2_ind_data_alpha1(:,2) - d2_alpha1_avg) + (d2_ind_data_alpha2(:,2) - d2_alpha2_avg)));
d2_rep = rmmissing(data_200(2:end,index2));

% find a 200 subject that is most different from the 100 subject
d1_rep_alpha1 = ind_data_alpha1(index,2);
d1_rep_alpha2 = ind_data_alpha2(index,2);

[res3, index3] = max(abs(d2_ind_data_alpha1(:,2) - d1_rep_alpha1) + abs(d2_ind_data_alpha2(:,2) - d1_rep_alpha2));

d2_rep2 = rmmissing(data_200(2:end,index3));

%% 3. Plot the graphs

% 100 subject
d1_windows = windows_alph1;
d1_windows(end+1:end+numel(progress_x))= progress_x;
[alpha,f] = DFA_fun(d1_rep, d1_windows);

p1 = plot(log10(d1_windows), log10(f), "^", "Color", [0 0 0], 'DisplayName','100 subject');
hold on

% plotting the slopes
% alpha1 fit
fit_range1 = 1:13;
xfit1 = log10(windows_alph1);
yfit1 = log10(f(fit_range1));

d1_fit_alpha1 = polyfit(xfit1, yfit1, 1);
d1_fit_y = polyval(d1_fit_alpha1, xfit1);

plot(xfit1,d1_fit_y, 'LineWidth',1)

% add text box
txt = "\leftarrow alpha1 = " + d1_fit_alpha1(1);
text(xfit1(5),d1_fit_y(5),txt)
hold on

% alpha2 fit
fit_range2 = 14:numel(d1_windows);
xfit2 = log10(progress_x);
yfit2 = log10(f(fit_range2));
d1_fit_alpha2 = polyfit(xfit2, yfit2, 1);
d1_fit_y2 = polyval(d1_fit_alpha2, xfit2);
plot(xfit2,d1_fit_y2, 'LineWidth',1)

% add text box
txt = "\leftarrow alpha2 = " + d1_fit_alpha2(1);
text(xfit2(5),d1_fit_y2(5),txt)
hold on

% 200 subject
d2_windows = windows_alph1;
d2_windows(end+1:end+numel(d2_progress_x))= d2_progress_x;

% cloest to avg
% [d2_alpha,d2_f] = DFA_fun(d2_rep, d2_windows);

% furthest from the 100 subject
[d2_alpha,d2_f] = DFA_fun(d2_rep2, d2_windows);

% modified
d2_f = 10.^(log10(d2_f)-0.8);

p2 = plot(log10(d2_windows), log10(d2_f), "o", "Color", [0 0 0], 'DisplayName','200 subject');

hold on

% alpha1 fit

d2_yfit1 = log10(d2_f(fit_range1));

d2_fit_alpha1 = polyfit(xfit1, d2_yfit1, 1);
d2_fit_y = polyval(d2_fit_alpha1, xfit1);

plot(xfit1,d2_fit_y, 'LineWidth',1)

% add text box
txt = "\leftarrow alpha1 = " + d2_fit_alpha1(1);
text(xfit1(5),d2_fit_y(5),txt)
hold on

% alpha2 fit
fit_range2 = 14:numel(d2_windows);
d2_xfit2 = log10(d2_progress_x);
d2_yfit2 = log10(d2_f(fit_range2));
d2_fit_alpha2 = polyfit(d2_xfit2, d2_yfit2, 1);
d2_fit_y2 = polyval(d2_fit_alpha2, xfit2);
plot(xfit2,d2_fit_y2, 'LineWidth',1)

% add text box
txt = "\leftarrow alpha2 = " + d2_fit_alpha2(1);
text(xfit2(5),d2_fit_y2(5),txt)
hold off

title("All segements Comparison")
legend([p1,p2])
