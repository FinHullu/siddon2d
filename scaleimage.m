function scaled_image = scaleimage(smiley, n)
    % Check if the input smiley is 64x1
    if numel(image) ~= 64
        error('Input smiley must be a 64x1 matrix.');
    end

    % Reshape the 64x1 image to 8x8
    image_8x8 = reshape(image, [8, 8]);

    % Create an n x n grid for the new scaled image
    [X, Y] = meshgrid(linspace(1, 8, n), linspace(1, 8, n));

    % Use interp2 to interpolate the image to the new grid
    scaled_image_2d = interp2(image_8x8, X, Y, 'linear');

    % Reshape the n x n matrix to an (n*n)x1 matrix
    scaled_image = scaled_image_2d(:);
end