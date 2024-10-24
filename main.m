clc
clear
n_havainnot = 170;
for grid = 10
    % Neli�ruudukon sivun pituus
    tic
    
    A = zeros(n_havainnot, grid*grid); % Alustetaan tyhjä havaintomatriisi
    % b = ... % Havainnot
    b = [0.199832; 0.271462; 0.394208; 0.273114; 0.357574; 0.494193; 0.18006; 0.187619; 0; ...
        0.694406; 0.366607; 0.424513; 0.0609391; 0.0254791; 0.388627; 0.0689929; 0.619219; ...
        0.352193; 0.605298; 0.41685; 0.381233; 0.451805; 0.48598; 0.436119; 0; 0.977899; ...
        0.48598; 0.481898; 0.242192; 0.218438; 0.578023; 0.205996; 0.190658; 0.20137; ...
        0.13443; 0.858259; 0.555849; 0.457752; 0.355777; 0.231036; 0.549292; 0.212197; ...
        0.409246; 0.390484; 0.151847; 0.168084; 0.131557; 0.0703415; 0.13443; 0.457752; ...
        0.712195; 0.434175; 0.494193; 0.255095; 0.184588; 0.609917; 0.148923; 0.394208; ...
        0.445894; 0.166597; 0.124409; 0.151847; 0.664627; 0.372067; 0.714763; 0.41685; ...
        0.420675; 0.281412; 0.318768; 0.366607; 0.153312; 0.449831; 0.348621; 0.91944; ...
        0.496257; 0.614557; 0.424513; 0.293148; 0.56466; 0.341516; 0.377556; 0.654895; ...
        0.399821; 0.362984; 0.580268; 0.390484; 0.350405; 0.455766; 0.311872; 0.506642; ...
        0.964609; 0.596123; 0.396075; 0.48598; 0.432235; 0.451805; 0.350405; 0.418761; ...
        0.370244; 0.311872; 0.551473; 1.07992; 0.598409; 0.519247; 0.48598; 0.525609; ...
        0.473784; 0.689381; 0.68189; 0.434175; 0.348621; 0.323972; 0.445894; 0.506642; ...
        1.01538; 0.34684; 0.238992; 0.571319; 0.571319; 0.496257; 0.422592; 0.325713; ...
        0.430299; 0.76214; 0.496257; 0.479863; 0.288101; 0.494193; 0.477833; 0.578023; ...
        0.525609; 0.350405; 0.357574; 0.441973; 0.411142; 0.638087; 0.141651; 0.209092; ...
        0.226293; 0.390484; 0.432235; 0.451805; 0.418761; 0.394208; 0.626253; 0.504556; ...
        0.461736; 0.269813; 0.392344; 0.432235; 0.455766; 0.540615; 0.352193; 0.434175; ...
        0.492133; 0.366607; 0.48598; 0.465736; 0.532013; 0.498325; 0.477833; 0.483937; ...
        0.34684; 0.584772; 0.555849; 0.355777; 0.598409; 0.508731; 0.426438; 0.63097];
    
    xs = [];
    xe = [];
    
    for z = 1:4
        for korkeus = 0:(8 - 1)
            if z == 1
                xs = [xs, [korkeus; 0]];
                xe = [xe, [korkeus + 0.00000000001; 8]];
            elseif z == 2
                xs = [xs, [0; korkeus]];
                xe = [xe, [8; korkeus]];
            elseif z == 3
                xs = [xs, [korkeus; 0]];
                xe = [xe, [korkeus + 1; 8]];
            else
                xs = [xs, [0; korkeus]];
                xe = [xe, [8; korkeus + 1]];
            end
        end
    end
    
    alutx = [];
    loputx = [1:8-1];
    for h = 1:8
        alutx = [alutx 0];
        loputx = [loputx 8];
    end
    alutx = [alutx 1:8-1];
    alut = [alutx; loputx];
    loput = [loputx; alutx];
    for g = 1:length(alut)
        xs = [xs, alut(:,g)];
        xe = [xe, loput(:,g)];
    end
    
    alut2 = [fliplr(alutx); alutx];
    loput2 = [fliplr(loputx); loputx];
    for g = 1:length(alut)
        xs = [xs, alut2(:,g)];
        xe = [xe, loput2(:,g)];
    end
    
    for loppu = (8 - 2):-1:1
        for i = 1:2
            for korkeus = 0:loppu
                if i == 1
                    startpos = [0; korkeus];
                    endpos = [8; korkeus + (-loppu + 8)];
                else
                    startpos = [korkeus; 0];
                    endpos = [korkeus + (-loppu + 8); 8];
                end
                for s = 1:2
                    if s == 2
                        startpos(2)=8-startpos(2);
                        endpos(2)=8-endpos(2);
                    end
                    xs = [xs, startpos];
                    xe = [xe, endpos];
                end
            end
        end
    end
    
    for ii = 1:n_havainnot
        % xi = ... % Säteen alkupiste [x; y]
        % xf = ... % Säteen loppupiste [x; y]
        xi = xs(:,ii);
        xf = xe(:,ii);  
    
        A(ii, : ) = siddon2D(xi, xf, grid);
    end
    
    objective = @(params) -evaluate_image_quality(b,A,params.lambda, params.num_iter, params.alpha, params.sigma, params.noise_threshold, params.reduction_factor);
    
    params = struct('lambda', optimizableVariable('lambda', [0.01, 10], 'Type', 'real', 'Transform', 'log'), ...
                    'alpha', optimizableVariable('alpha', [0.0005, 0.5], 'Type', 'real', 'Transform', 'log'), ...
                    'num_iter', optimizableVariable('num_iter', [500, 2500], 'Type', 'integer'), ...
                    'sigma', optimizableVariable('sigma', [0.1, 5], 'Type', 'real', 'Transform', 'log'), ...
                    'noise_threshold', optimizableVariable('noise_threshold', [0.001, 0.1], 'Type', 'real', 'Transform', 'log'), ...
                    'reduction_factor', optimizableVariable('reduction_factor', [0.01, 1], 'Type', 'real', 'Transform', 'log'));
    
    results = bayesopt(objective, [params.lambda, params.alpha, params.num_iter, params.sigma, params.noise_threshold, params.reduction_factor]);
    best_params = results.XAtMinObjective;
    
    % x = alpha_regularization(A,b,1e-4);
    
    x = kohinan_poisto(sparseRecovery(b,A,best_params.lambda,best_params.num_iter,best_params.alpha),best_params.sigma,best_params.noise_threshold,best_params.reduction_factor);
    
    %evaluate_image_quality(x,grid)
    
    %x = kohinan_poisto(x)
    
    %x = actual_image-x;
    
    kuva = reshape(x, grid, grid);
    
    % kuva2 = konvoluutio(x);
    
    % kuva2 = kohinan_poisto(kuva2)
    
    % kuva = kuva2
    
    kuva(grid+1,grid+1) = 0;
    colormap('bone')
    h = pcolor(kuva);
    
    % for k = 1:length(h)
    %     zdata = h(k).ZData;
    %     h(k).CData = zdata;
    %     h(k).FaceColor = 'interp';
    % end
    
    % axis square
    % toc
end
function ssim_value = evaluate_image_quality(b,A,lambda, num_iter, alpha, sigma, noise_threshold, reduction_factor)
    x = kohinan_poisto(sparseRecovery(b,A,lambda,num_iter,alpha),sigma,noise_threshold,reduction_factor);
    grid = sqrt(size(A,2));
    x=x.*(1/max(x));
    max_val = 1;
    actual_image = zeros(64,1);
    actual_image(4) = max_val;
    actual_image(11) = max_val;
    actual_image(18) = max_val;
    actual_image(23) = max_val;
    actual_image(26) = max_val;
    actual_image(34) = max_val;
    actual_image(42) = max_val;
    actual_image(47) = max_val;
    actual_image(51) = max_val;
    actual_image(60) = max_val;
    actual_image = scaleSmiley(actual_image,grid);
    ssim_value = ssim(actual_image,x);
end