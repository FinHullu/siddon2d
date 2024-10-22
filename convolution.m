function x = convolution(x)
    % Take the n^2x1 vector and turn it into a nxn matrix
    grid = sqrt(size(x,1));
    img = reshape(x,grid,grid);
    
    % Adding zeros to each side of the matrix in order to perform summation
    % without errors
    img = [zeros(size(img,1),1), img];
    img = [zeros(1,size(img,2)); img];
    img(grid+2,grid+2)=0;
    img_out = zeros(size(img,1)-2);
    
    % Iterating through the grid and adding 3x3 matrix of numbers together
    for i = 2:grid + 1
        for j = 2:grid + 1
            img_out(j-1,i-1) = sum(img(j-1,i-1:i+1)) + ...
                sum(img(j,i-1:i+1)) + ...
                sum(img(j+1,i-1:i+1));
        end
    end
    % reshaping the nxn matrix back to a n^2x1 vector
    x = reshape(img_out, [], 1);
end