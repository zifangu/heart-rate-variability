% Sometimes a particular segment needs to be rerun so that the majority of
% the peaks are identified.
% Change the variables to locate and run the particular segements.
% Only put one start_stop/.txt file belong to the subject you want to run
% in the rerun folder.

global DATA_CUT 
DATA_CUT = '4500'; % 4 -> 0.4 = min peak height, 500 = min peak distance

MIN_PEAK_HEIGHT = 0; % Sometimes data drift. Change this accordingly
MIN_PEAK_DISTANCE = 500;
MIN_PEAK_DISTANCE_FLAG = 500;
MAX_PEAK_DISTANCE_FLAG = 1500;

start_stop = dir('rerun/*.txt');

list1 = load(start_stop(1).name);
person_name = start_stop(1).name(1:5);

data = load(strcat('input/',person_name,'.mat')); %loads exp file
data = data.exp_matrix;

for BREAK_TO_RUN = 1:10 % You can change this accordingly
%     fid37 = fopen(strcat('rerun_data/',person_name,'_break', int2str(BREAK_TO_RUN),'image_ekgdata37.txt'),'w+');
%     fidmiss = fopen(strcat('rerun_data/',person_name,'_break', int2str(BREAK_TO_RUN),'missed_interval.txt'),'w+');
%     fidfast = fopen(strcat('rerun_data/',person_name,'_break', int2str(BREAK_TO_RUN),'fast_interval.txt'),'w+');
    fidRwave = fopen(strcat('peaks_modified/',person_name,'_break', int2str(BREAK_TO_RUN),'_Rwave_interval.txt'),'w+');
%     fidECG = fopen(strcat('rerun_data/',person_name,'_break', int2str(BREAK_TO_RUN), 'ECGpersegment.txt'),'w+');
%     fidTimes = fopen(strcat('rerun_data/',person_name,'_break', int2str(BREAK_TO_RUN),'timepersegment.txt'),'w+');


    segment_start=list1(BREAK_TO_RUN, 1); 
    segment_stop=list1(BREAK_TO_RUN, 2);
    im_data = zeros(segment_start-segment_stop,2);
    for i = segment_start:segment_stop
        q = i - segment_start;
        im_data(q+1,1) = i;
        im_data(q+1,2) = data(i);
    end

    %scale y axis
        im_data(:,2) = -1 + 2.*(im_data(:,2) - min(im_data(:,2)))./(max(im_data(:,2)) - min(im_data(:,2)));

        %filer row of ecg data from image
        im_data(:,2) = sgolayfilt(im_data(:,2), 7, 41);
        %find peaks in data from single image
        [~,locs_Rwave1] = findpeaks(im_data(:,2),'MinPeakHeight',MIN_PEAK_HEIGHT,'MinPeakDistance',MIN_PEAK_DISTANCE);    

        for i  = 1:length(locs_Rwave1)
            time_of_rwave(i) = im_data(locs_Rwave1(i),1);
            locs_Rwave1(i) = time_of_rwave(i);
        end

        locs_miss = zeros(1,1); %places in data where interval missed
        locs_fast = zeros(1,1); %places in data where Q or S wave mistaken for R wave
        for i = 1:length(locs_Rwave1)-1
            if locs_Rwave1(i+1)-locs_Rwave1(i) > MAX_PEAK_DISTANCE_FLAG % && locs_Rwave1(i+1)-locs_Rwave1(i) <5000
                locs_miss(i,1) = round((locs_Rwave1(i+1)+locs_Rwave1(i))/2,0);
            end
            if locs_Rwave1(i+1)-locs_Rwave1(i) < MIN_PEAK_DISTANCE_FLAG% && locs_Rwave1(i+1)-locs_Rwave1(i) <5000
                locs_fast(i,1) = round((locs_Rwave1(i+1)+locs_Rwave1(i))/2,0);
            end
        end
        locs_miss((locs_miss == 0)) = [];
        locs_fast((locs_fast == 0)) = [];

%         for z = 1:length(locs_fast)
%             fprintf(fidfast,'%f\n',locs_fast(z));
%         end
% 
%         for z = 1:length(locs_miss)
%             fprintf(fidmiss,'%f\n',locs_miss(z));
%         end

        for z = 1:length(locs_Rwave1)
            fprintf(fidRwave,'%f\n',locs_Rwave1(z));
        end
% 
%         for z = 1:length(im_data(:,2)) 
%             fprintf(fidECG,'%f\n',im_data(z,2));
%         end
% 
%         for z = 1:length(im_data(:,2)) 
%             fprintf(fidTimes,'%f\n',im_data(z,1));
%         end

        %%%%%%%%%%%%%%%%%%%%
    %     ECG_dat = load(strcat('rerun_data/',person_name,'_break', int2str(BREAK_TO_RUN), 'ECGpersegment.txt'));
        f = figure('visible','off');
        hold on
        time = segment_start:segment_stop;
        temp = im_data(:,2);
    %     plot(t,ECG_dat);
        plot(time, temp);

        for i = 1:length(time)
            for j = 1:length(locs_Rwave1)
                if time(i) == locs_Rwave1(j)
                    plot(locs_Rwave1(j), temp(i), 'rv','MarkerFaceColor','r');
                end
            end
        end

    if length(locs_miss) > 0   
        plot(locs_miss,0,'gv','MarkerFaceColor','g');
    end

    if length(locs_fast) > 0    %#ok<*ISMT>
        plot(locs_fast,0,'bv','MarkerFaceColor','b');
    end

    set(f, 'Visible', 'on')
    dcmObj = datacursormode;
    saveas(f, strcat('peaks_modified/',person_name,'_break', int2str(BREAK_TO_RUN), '_ekg_image.fig'))
    hold off
end











