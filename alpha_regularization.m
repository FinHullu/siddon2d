function x = alpha_regularization(A,b,alpha)
    grid = sqrt(size(A,2));
    A = [A; alpha*eye(grid^2)];
    b = [b; zeros(grid^2,1)];
    x = A \ b;
end