function image_array = load_images_to_array(folder_path, image_size)
    file_names = dir(fullfile(folder_path, '*.png'));
    num_images = numel(file_names);
    image_array = zeros(num_images, image_size, image_size);
    for i = 1:num_images
        file_path = fullfile(folder_path, file_names(i).name);
        image = imread(file_path);
        image=rgb2gray(image);
        image = imresize(image, [image_size image_size]);
        image_array(i,:,:) = image;
        
    end
end
