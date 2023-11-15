%{

file name = main_file

time:
Start_date = 16.12.2021
End_date = 03.11.2022


Desciption: This code is used to classify different materials whose dataset
has been acquired using the Time-of-Flight camera at NearInfrared
wavelength and at 20 Mhz to 160 Mhz temporal frequency.

Author: Rajababu Udainarayan Singh
Matriculation number: 1530580


Supervisor: Dr.-Ing Miguel Heredia Conde

%}


%% clear all the variables which has been prestored in the MATLAB workspace

clc
clear

%% Please provide information about the actual path of the stored dataset from your local machine

%base_path = "C:\Users\rajas\Downloads\Mr_Singh_Material_Imaging_20_11_2022\Mr_Singh_Material_Imaging\"; % change this path according to you
base_path = "/Users/navtegh/Documents/MATLAB/Mr_Singh_Material_Imaging/"; % change this path according to you
dataset_path = 'datasets/';
results_path = 'results/';
branch_path = "dataset_3"; % call different dataset from here
full_path_dataset = base_path+dataset_path+branch_path+"/";
full_path_result = base_path+results_path+branch_path+'/';

mat_files = dir(full_path_dataset+'*.mat');
dataset_name = extractfield(mat_files, 'name'); % extract all the availabel .mat file names

xlsx_files = dir(full_path_dataset+'*.xlsx');
xlsx_name = extractfield(xlsx_files, 'name'); % extract all the availabel .xlsx file names

if branch_path == "dataset_1" % keep adding ranges based on the dataset in this conditional loop
    mat_name_range = 'A1:A16';
    pixel_range = 'C2:AF8';
    height_window = 120; % to balance dataset
    width_window = 180;

elseif branch_path == "dataset_2"
    mat_name_range = 'A1:A15';
    pixel_range = 'C2:AD8';
    height_window = 60;
    width_window = 80;

elseif branch_path == "dataset_3"
    mat_name_range = 'A1:A6';
    pixel_range = 'C2:L142';
    height_window = 60;
    width_window = 80;

elseif branch_path == "dataset_4"
    mat_name_range = 'A1:A15';
    pixel_range = 'C2:AD8';
    height_window = 60;
    width_window = 80;

elseif branch_path == "dataset_5"
    mat_name_range = 'A1:A11';
    pixel_range = 'C2:V12';
    height_window = 36;
    width_window = 28;

elseif branch_path == "dataset_6"
    mat_name_range = 'A1:A3';
    pixel_range = 'C2:V12';
    height_window = 36;
    width_window = 28;
end

mat_list_names = readtable(full_path_dataset+xlsx_name{1,1},'Range',mat_name_range);
pix_ranges = readtable(full_path_dataset+xlsx_name{1,2},'Range',pixel_range);

if branch_path == 'dataset_6'
    load(full_path_dataset+'skin_dataset_for_binary_classification.mat', 'skin_class_1st_row_and_bucket_class_2nd_row_dataset');
    train_val_test = skin_class_1st_row_and_bucket_class_2nd_row_dataset;
else
    %% Normalize data

    new_dataset = normalization(full_path_dataset+dataset_name, pix_ranges);    % call function normalization

    if branch_path == 'dataset_1'

        new_dataset(7,:) = []; % we are removing 7th material
        new_dataset(10,:) = []; % we are removing 11th material
        new_dataset(12,:) = []; % we are removing 14th material

        mat_list_names(7,:) = []; % we are removing 7th material
        mat_list_names(10,:) = []; % we are removing 11th material
        mat_list_names(12,:) = []; % we are removing 14th material

    end

    disp("Imbalanced Percentage of pixels per material :")
    data_imbalance(new_dataset)    % print imbalance data by calling function data imbalance

    %% Downsample data

    % size of each image

    train_val_test = downSample_dataset(new_dataset, height_window, width_window);    % call downSample_dataset function --"convert imbalance dataset to balance dataset"
    disp("Balanced Percentage of pixels per material :")
    data_imbalance(train_val_test)    % print imbalance data by calling function data imbalance

end
%%
sigma = find_sigma1(train_val_test);
std_Dev = std_deviation(sigma);
std_dev = vertcat(std_Dev{:});
std_dev = reshape(mean(std_dev), 1, 1, 8, 2);

%sig = find_sigma1(train_val_test);
%[sigma, dist_parameters, normal_parameter, weibull_parameter, gamma_parameter, lognormal_parameter, kernel_parameter] = find_sigma(train_val_test);

%%

if branch_path == 'dataset_5' || branch_path == 'dataset_6'
   train_val = train_val_test;
else
    train_val_test = breakdown(train_val_test);    % call function breakdown to divide image into equal parts

    random_shuffle_for_train_val_test = randperm(size(train_val_test, 2));
    train_val_test = train_val_test(:, random_shuffle_for_train_val_test);

    train_val = train_val_test(:,1:end-2);
    test = train_val_test(:,end-1:end);

end

%% Training and Validation image patch and label dataset

window_rows = 5;
window_colms = 5;
window_stride = 1;
k_nearest = 9;
% weight_mat = weight_matrix(window_rows, window_colms);

[x_train, y_train] = images_and_labels(train_val, window_rows, window_colms, window_stride, mat_list_names, k_nearest, std_dev); % Extract images and labels for training
[coeff,score]=pca(x_train)