% %{
% 
% file name = main_file
% 
% time:
% Start_date = 16.12.2021
% End_date = 03.11.2022
% 
% 
% Desciption: This code is used to classify different materials whose dataset
% has been acquired using the Time-of-Flight camera at NearInfrared
% wavelength and at 20 Mhz to 160 Mhz temporal frequency.
% 
% Author: Rajababu Udainarayan Singh
% Matriculation number: 1530580
% 
% 
% Supervisor: Dr.-Ing Miguel Heredia Conde
% 
% %}
% 
% 
% %% clear all the variables which has been prestored in the MATLAB workspace
% 
% clc
% clear
% 
% %% Please provide information about the actual path of the stored dataset from your local machine
% 
% %base_path = "C:\Users\rajas\Downloads\Mr_Singh_Material_Imaging_20_11_2022\Mr_Singh_Material_Imaging\"; % change this path according to you
% % base_path = "/tmp/.x2go-g064348/media/disk/_Users_navtegh_Documents_MATLAB_Mr_Singh_Material_Imaging/"; % change this path according to you
% base_path = "/Users/navtegh/Documents/MATLAB/Mr_Singh_Material_Imaging/";
% dataset_path = 'datasets/';
% results_path = 'results/';
% branch_path = "dataset_3"; % call different dataset from here
% full_path_dataset = base_path+dataset_path+branch_path+"/";
% full_path_result = base_path+results_path+branch_path+'/';
% 
% mat_files = dir(full_path_dataset+'*.mat');
% dataset_name = extractfield(mat_files, 'name'); % extract all the availabel .mat file names
% 
% xlsx_files = dir(full_path_dataset+'*.xlsx');
% xlsx_name = extractfield(xlsx_files, 'name'); % extract all the availabel .xlsx file names
% 
% if branch_path == "dataset_1" % keep adding ranges based on the dataset in this conditional loop
%     mat_name_range = 'A1:A16';
%     pixel_range = 'C2:AF8';
%     height_window = 120; % to balance dataset
%     width_window = 180;
% 
% elseif branch_path == "dataset_2"
%     mat_name_range = 'A1:A15';
%     pixel_range = 'C2:AD8';
%     height_window = 60;
%     width_window = 80;
% 
% elseif branch_path == "dataset_3"
%     mat_name_range = 'A1:A6';
%     pixel_range = 'C2:L142';
%     height_window = 60;
%     width_window = 80;
% 
% elseif branch_path == "dataset_4"
%     mat_name_range = 'A1:A15';
%     pixel_range = 'C2:AD8';
%     height_window = 60;
%     width_window = 80;
% 
% elseif branch_path == "dataset_5"
%     mat_name_range = 'A1:A11';
%     pixel_range = 'C2:V12';
%     height_window = 36;
%     width_window = 28;
% 
% elseif branch_path == "dataset_6"
%     mat_name_range = 'A1:A3';
%     pixel_range = 'C2:V12';
%     height_window = 36;
%     width_window = 28;
% end
% 
% mat_list_names = readtable(full_path_dataset+xlsx_name{1,1},'Range',mat_name_range);
% pix_ranges = readtable(full_path_dataset+xlsx_name{1,2},'Range',pixel_range);
% 
% if branch_path == 'dataset_6'
%     load(full_path_dataset+'skin_dataset_for_binary_classification.mat', 'skin_class_1st_row_and_bucket_class_2nd_row_dataset');
%     train_val_test = skin_class_1st_row_and_bucket_class_2nd_row_dataset;
% else
% %% Normalize data
% 
%     new_dataset = normalization(full_path_dataset+dataset_name, pix_ranges);    % call function normalization
% 
%     if branch_path == 'dataset_1'
% 
%         new_dataset(7,:) = []; % we are removing 7th material
%         new_dataset(10,:) = []; % we are removing 11th material
%         new_dataset(12,:) = []; % we are removing 14th material
% 
%         mat_list_names(7,:) = []; % we are removing 7th material
%         mat_list_names(10,:) = []; % we are removing 11th material
%         mat_list_names(12,:) = []; % we are removing 14th material
% 
%     end
% 
%     disp("Imbalanced Percentage of pixels per material :")
%     data_imbalance(new_dataset)    % print imbalance data by calling function data imbalance
% 
%     %% Downsample data
% 
%     % size of each image
% 
%     train_val_test = downSample_dataset(new_dataset, height_window, width_window);    % call downSample_dataset function --"convert imbalance dataset to balance dataset"
%     disp("Balanced Percentage of pixels per material :")
%     data_imbalance(train_val_test)    % print imbalance data by calling function data imbalance
% 
% 
% 
% end
% %%
% sigma = find_sigma1(train_val_test);
% std_Dev = std_deviation(sigma);
% std_dev = vertcat(std_Dev{:});
% std_dev = reshape(mean(std_dev), 1, 1, 8, 2);
% 
% %sig = find_sigma1(train_val_test);
% %[sigma, dist_parameters, normal_parameter, weibull_parameter, gamma_parameter, lognormal_parameter, kernel_parameter] = find_sigma(train_val_test);
% 
% %%
% 
% if branch_path == 'dataset_5' || branch_path == 'dataset_6'
%    train_val = train_val_test;
% else
%     train_val_test = breakdown(train_val_test);    % call function breakdown to divide image into equal parts
% 
%     random_shuffle_for_train_val_test = randperm(size(train_val_test, 2));
%     train_val_test = train_val_test(:, random_shuffle_for_train_val_test);
% 
%     train_val = train_val_test(:,1:end-2);
%     test = train_val_test(:,end-1:end);
% 
% end
% num_pca=16;
% % train_val_r=reshape(train_val,[],1);
% % new_train_val=cell2mat(train_val_r);
% % train_val_r_final=reshape(new_train_val,[],16);
% % disp(size(train_val_r_final));
% % [coeff,score,latent,tsquared,explained,mu]=pca(train_val_r_final,'NumComponents',num_pca);
% % score_r=reshape(score,[],20,8,2);
% % new_score=mat2cell(score_r,4190,20,8,2);
% train_v
% 
% 
% 
% 
% % train_val_r=reshape(train_val,[],16);
% % disp(size(train_val))
% 
% %% Training and Validation image patch and label dataset
% 
window_rows = 5;
window_colms = 5;
window_stride = 1;
k_nearest = 9;
% weight_mat = weight_matrix(window_rows, window_colms);

 [x_train, y_train] = images_and_labels2(final, window_rows, window_colms, window_stride, mat_list_names, k_nearest, std_dev); % Extract images and labels for training


%% new pca
% flat_xtrain=reshape(x_train,1,9,16,1072640);
% x_train=single(x_train);
% x_train_rea=permute(x_train,[5,4,3,2,1]);
% x_train=reshape(x_train_rea,1072640,144);
% 
% num_pca=60;
% [coeff,score,latent,tsquared,explained,mu]=pca(x_train,'NumComponents',num_pca);
% 
% 
% % % %% pca
% % % % x_train=single(x_train);
% % % 
% % % x_train_real=x_train(:,:,:,1,:);
% % % % x_train_img=x_train(:,:,:,2,:);
% % % 
% % % flat_xtrain_real=reshape(x_train_real,9653760,8);
% % % flat_xtrain_img=reshape(x_train_img,9653760,8);
% % % [coeff1,score1,latent1,tsquared1,explained1,mu1]=pca(flat_xtrain_real);
% % % [coeff2,score2,latent2,tsquared2,explained2,mu2]=pca(flat_xtrain_img);
% % % selected_pc_real=coeff1(:,1:3);
% % % selected_pc_img=coeff2(:,1:3);
% % % final_real=score1*selected_pc_real;
% % % final_img=score2*selected_pc_img;
% % % 
% % % clear x_train
% % % 
% % % x_train(:,:,:,1,:)=reshape(final_real,1,9,3,1072640);
% % % x_train(:,:,:,2,:)=reshape(final_img,1,9,3,1072640);
% % % 
% % % 
% % %%
% rand = randperm(size(y_train, 1));
% shuffle_x_train =score(rand,:);
% shuffle_y_train = y_train(rand, :);
% 
% %%
% 
% n_inst_per_mat = size(shuffle_x_train, 1);
% 
% % davide data into training and validation set
% train_and_val_ratio = 0.85;
% 
% x_train = shuffle_x_train(1:floor(n_inst_per_mat*train_and_val_ratio),:);
% x_val = shuffle_x_train (floor(n_inst_per_mat*train_and_val_ratio) + 1 : end,:);
% 
% %%
% y_train = shuffle_y_train(1:floor(n_inst_per_mat*train_and_val_ratio), :);
% y_val = shuffle_y_train(floor(n_inst_per_mat*train_and_val_ratio) + 1 : end, :);
% 
% 
% 
% % save('y_train.mat','y_train')
% % save('y_val.mat','y_val')
% 
% % 
% % ytrain= matfile('y_train.mat');
% % y_train = ytrain.y_train;
% % yval= matfile('y_val.mat');
% % y_val = yval.y_val;
% % xtrain= matfile('x_train.mat');
% % x_train = xtrain.x_train;
% % xval= matfile('x_val.mat');
% % x_val = xval.x_val;
% 
% % call Deep learning network (all accuracy are not fixed, it changes everytime due to random initialization)
% 
% %network = algorithm_cnn1(x_train, x_val, y_train, y_val); % (98% classifier accuracy)
% % network = algorithm_cnn2(x_train, x_val, y_train, y_val); % (98% classifier accuracy)
% %network = algorithm_cnn4(x_train, x_val, y_train, y_val, n_mats); 
% %network = algorithm_fcnn(x_train, x_val, y_train, y_val); % (98% classifier accuracy)
% %network = algorithm_cnn5(x_train, x_val, y_train, y_val); % (98% classifier accuracy)
% %network = algorithm_fcnn_5(x_train, x_val, y_train, y_val); % (98% classifier accuracy)
% %network = algorithm_ResNet(x_train, x_val, y_train, y_val);
% 
% x_train_t=x_train';
% x_val_t=x_val';
% x_train_r=reshape(x_train,1,num_pca,1,[]);
% x_val_r=reshape(x_val,1,num_pca,1,[]);
% x_train_rt=reshape(x_train_t,1,num_pca,1,[]);
% x_val_rt=reshape(x_val_t,1,num_pca,1,[]);
% 
% % x_train_rt=half(x_train_rt);
% % x_val_rt=half(x_val_rt);
% 
% % x_train_t=reshape(x_train_t,1,32,[]);
% % half
% % pca 60
% network = algorithm_cnn2_new(x_train_rt, x_val_rt, y_train, y_val,num_pca);
% 
% 
% % 
% % % cnn2 has been depicted in research paper
% % 
% % %% calculate accuracy
% % 
% % [train_accuracy, ~] = accuracy(network, x_train, y_train);
% % [validation_accuracy, ~] = accuracy(network, x_val, y_val);
% % 
% % sprintf('training accuracy = %d', train_accuracy)    % print training accuracy
% % sprintf('validation accuracy = %d', validation_accuracy)    % print validation accuracy
% % 
% % %% call heterogeneous_test_Set (multiple run in this section can give the maximun test accuracy)
% % if branch_path == 'dataset_5' || branch_path == 'dataset_6'
% % 
% % else
% %     average_test_accuracy = 0;
% %     for i = 1:10
% %         [img_test, label_test] = heterogeneous_mat_test(branch_path, test, window_rows, window_colms, window_stride, mat_list_names, k_nearest, std_dev);
% %         [heterogeneous_test_accuracy, heterogeneous_test_label] = accuracy(network, img_test, label_test);
% %         sprintf('heterogeneous material accuracy = %d', heterogeneous_test_accuracy)    % print accuracy for heterogeneous material
% %         average_test_accuracy = average_test_accuracy + heterogeneous_test_accuracy;
% %     end
% %     average_test_accuracy = average_test_accuracy/10;
% %     disp('Average Test Accuracy:')
% %     disp(average_test_accuracy)
% % 
% %     %% Print confusion matrix and plot artificial heterogeneous image
% %     cm = confusionchart(label_test, heterogeneous_test_label);    % plot confusion matrix
% %     if branch_path == 'dataset_1'
% %         cm.XLabel = 'Predicted Class (15-Materials)';
% %         cm.YLabel = 'True Class (15-Materials)';
% %         image_height = 60;
% %         image_width = 80;
% %         cm.FontName = 'Times New Roman';
% %         cm.FontSize = 11;
% %         cm.ColumnSummary = 'total-normalized';
% %         cm.RowSummary = 'total-normalized';
% % 
% % 
% % 
% %         figure
% %         plot_image1(reshape(label_test, image_height, image_width), mat_list_names)    % plot composite material
% % 
% %         figure
% %         plot_image1(reshape(heterogeneous_test_label, image_height, image_width), mat_list_names)    % plot classified heterogeneous material
% % 
% %     elseif branch_path == 'dataset_2'
% %         cm.XLabel = 'Predicted Class (14-Materials)';
% %         cm.YLabel = 'True Class (14-Materials)';
% %         image_height = 60;
% %         image_width = 80;
% %         cm.FontName = 'Times New Roman';
% %         cm.FontSize = 11;
% %         cm.ColumnSummary = 'total-normalized';
% %         cm.RowSummary = 'total-normalized';
% % 
% % 
% %         figure
% %         plot_image2(reshape(label_test, image_height, image_width), mat_list_names)    % plot composite material
% % 
% %         figure
% %         plot_image2(reshape(heterogeneous_test_label, image_height, image_width), mat_list_names)    % plot classified heterogeneous material
% % 
% %     elseif branch_path == 'dataset_3'
% %         cm.XLabel = 'Predicted Class (05-Materials)';
% %         cm.YLabel = 'True Class (05-Materials)';
% %         image_height = 40;
% %         image_width = 40;
% %         cm.FontName = 'Times New Roman';
% %         cm.FontSize = 11;
% %         cm.ColumnSummary = 'total-normalized';
% %         cm.RowSummary = 'total-normalized';
% % 
% %         figure
% %         plot_image3(reshape(label_test, image_height, image_width), mat_list_names)    % plot composite material
% % 
% %         figure
% %         plot_image3(reshape(heterogeneous_test_label, image_height, image_width), mat_list_names)    % plot classified heterogeneous material
% %     end
% % 
% % 
% % end
% % 
% % %% save important variables
% % 
% % %save(full_path_result+'trained_model','x_train', 'x_val', 'y_train', 'y_val', 'network', '-v7.3');
% % %save('var_mat_14_patch_size_5.mat', 'train', 'val', 'x_train', 'x_val', 'y_train', 'y_val', 'network', '-v7.3');