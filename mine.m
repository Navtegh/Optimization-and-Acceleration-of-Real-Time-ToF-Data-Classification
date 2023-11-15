clc
clear all

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


mat_name_range = 'A1:A6';
pixel_range = 'C2:L142';
height_window = 60;
width_window = 80;

mat_list_names = readtable(full_path_dataset+xlsx_name{1,1},'Range',mat_name_range);
pix_ranges = readtable(full_path_dataset+xlsx_name{1,2},'Range',pixel_range);

new_dataset = normalization(full_path_dataset+dataset_name, pix_ranges);    % call function normalization


disp("Imbalanced Percentage of pixels per material :")
data_imbalance(new_dataset)    % print imbalance data by calling function data imbalance

%% Downsample data

% size of each image

train_val_test = downSample_dataset(new_dataset, height_window, width_window);    % call downSample_dataset function --"convert imbalance dataset to balance dataset"
disp("Balanced Percentage of pixels per material :")
data_imbalance(train_val_test)    % print imbalance data by calling function data imbalance

sigma = find_sigma1(train_val_test);
std_Dev = std_deviation(sigma);
std_dev = vertcat(std_Dev{:});
std_dev = reshape(mean(std_dev), 1, 1, 8, 2);

train_val_test = breakdown(train_val_test);    % call function breakdown to divide image into equal parts

random_shuffle_for_train_val_test = randperm(size(train_val_test, 2));
train_val_test = train_val_test(:, random_shuffle_for_train_val_test);

train_val = train_val_test(:,1:end-2);
test = train_val_test(:,end-1:end);

window_rows = 5;
window_colms = 5;
window_stride = 1;
k_nearest = 9;
% weight_mat = weight_matrix(window_rows, window_colms);

[x_train, y_train] = images_and_labels(train_val, window_rows, window_colms, window_stride, mat_list_names, k_nearest, std_dev); % Extract images and labels for training

