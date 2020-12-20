# Heart Rate Variability Among College Students Using Detrended Fluctuation Analysis (DFA)

This repository contains a demonstration of the ongoing research , including raw data, sample code, and sample results.  Majority of the study subjects data are omitted to protect the integrity of the study as well as the privacy of the participants.

Faculty Sponsor:
* Dr. Carolyn Martsberger

Code Authors:
* David Aguillard
* Ivan Gu

The raw data collected on subjects has two major categories: 
* Unbounded 24-hour data on a college campus
* Controlled 2-hour data in classrooms/laboratories

During the controlled environment, subjects are asked to view images for a certain time. A short break is taken after each image. A major break is taken after every 20 images. The length of the major break is at the subjects' discretion. 

The RR intervals are first collected by using functions from the [signal processing toolbox](https://www.mathworks.com/products/signal.html) provided by Matlab. After which a strict hand cleaning protocol is implemented to obtain clean RR data. DFA is then performed on cleaned data to substantiate the hypothesis. 

error_data contains time intervals of the potential errors from identifying peaks. 

input contains the raw data collected from subjects.

peaks_modified contains the initial signal processed graphs. A team member uses the .fig graphs to manually correct the misidentified peaks in the corresponding .txt file.

rest_time contains subject data that refers to the short breaks after the subjects see each image.

start_stop contains subject data that refers to the major breaks after each segment is completed. 

DFA_fun.m: Martin Magris (2020). Detrended fluctuation analysis (DFA) (https://www.mathworks.com/matlabcentral/fileexchange/67889-detrended-fluctuation-analysis-dfa), MATLAB Central File Exchange. Retrieved September 15, 2020.