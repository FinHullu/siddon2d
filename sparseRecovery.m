function f = sparseRecovery(g, A, lambda, num_iter, alpha)
    % Function to recover a sparse signal f from measurements g using
    % L1 norm regularization (sparsity prior)
    %
    % INPUT:
    % g - measurement vector
    % A - system matrix
    % lambda - regularization parameter (controls sparsity level)
    % alpha - step size (learning rate) for the gradient descent
    % num_iter - number of iterations
    %
    % OUTPUT:
    % f - recovered sparse signal

    % Initialize f to zero or a small random vector
    f = ones(size(A, 2), 1);

    % Main loop for iterative update
    for k = 1:num_iter
        % % Gradient of the data fidelity term (least squares)
        % grad_fidelity = A' * (A * f - g);
        %
        % % Soft thresholding for L1 regularization
        % f = f - alpha * grad_fidelity;  % Gradient descent step
        % f = sign(f) .* max(abs(f) - lambda, 0);  % Soft thresholding
        f = f - alpha * A' * (A * f - g);
        f = sign(f) .* max(abs(f) - alpha * lambda, 0);
    end

    return;
end