function x = kohinan_poisto(x, sigma, noise_threshold, reduction_factor)
    % Parameters for noise reduction
    % sigma = Standard deviation for Gaussian filter
    % noise_threshold = Threshold for identifying noise
    % reduction_factor = Factor to reduce identified noise
    
    % Apply Gaussian smoothing to reduce noise
    h = fspecial('gaussian', [5 5], sigma);
    x = imfilter(x, h, 'symmetric');
    
    % Identify noise by thresholding
    noise_mask = x < noise_threshold;
    
    % Reduce the identified noise
    x(noise_mask) = x(noise_mask) * reduction_factor;
    
    % Clip the pixel values to be within the range [0, 1]
    x = min(max(x, 0), 1);
end
