clear all
clc

p = 2;
N_cut = [0.3, 0.6, 1];
N_frac = [0.3, 0.3, 0.4];
K = length(N_frac);
MaxIter = 500;

a0 = [0.4, 1.6; 1, 1; 1.6, 0.4];


correct_ratio = zeros(30, 6);
se_record = zeros(30, 6);
time_cvx = zeros(30, 6);

c = 0;
for N = [100, 200]
    
    if N == 100
        group0 = [ones(1, 30), 2*ones(1, 30), 3*ones(1, 40)];
    else
        group0 = [ones(1, 60), 2*ones(1, 60), 3*ones(1, 80)];
    end
    
    for T = [15, 25, 50]
        
        c = c + 1;
        
        for r = 1:30
            
            disp([N, T, r]);
        
            file_name = strcat('../simu_data/pls_data_N_', num2str(N), '_T_', ...
                                num2str(T), '_r_', num2str(r), '.csv');
            D = csvread(file_name, 1, 0);
            
            y = D(:, 1);
            X = D(:, 2:3);
            lambda = 0.5 * var(y) / (T^(1/3));
            
            tic
            [b_out, a_out, group_out] = SSP_PLS_est(N, T, y, X, K, lambda, MaxIter);
            time_cvx(r, c) = toc;
            disp(time_cvx(r, c))
            [ratio, weighted_se, a_est, group] = result_gen(group_out, a_out, group0, a0, N, N_frac, K, p);
            correct_ratio(r, c) = ratio;
            se_record(r, c) = weighted_se;
            
        end
    end
end

Result = [correct_ratio, se_record, time_cvx];

save('CVX_PLS_Result.mat', 'Result')
csvwrite('CVX_PLS_Result.csv', Result)













