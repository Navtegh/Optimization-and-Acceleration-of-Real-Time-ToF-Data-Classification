function  sigma = find_sigma1_bp(data,num_pca)

    for i = 1:size(data,1)
        for j = 1:size(data,2)          
            
            data{i,j} = permute(data{i,j}, [3 1 2]);
            data{i,j} = reshape(data{i,j}, num_pca, []);
            data{i,j} = permute(data{i,j}, [2 1]);
            data{i,j} = reshape(data{i,j}, size(data{i,j}, 1), []);
            
        end
        sigma{i,1} = cat(1, data{i,:});
        sigma{i,1} = sigma{i,1} - min(sigma{i,1});
    end

end