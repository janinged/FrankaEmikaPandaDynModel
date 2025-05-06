%% Plot a comparison of the model and the real data
subplot(211)

%% Plot torques calculated from identified model
datafolder = 'build/';

time = readtable([datafolder, 'exciting_traj_time.txt']).Var1;
N = length(time);
tau = reshape(readtable([datafolder, 'exciting_traj_torques.txt']).Var1, 7, []);

plot(time, tau)
title('Joint torques')
legend('$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$', '$\tau_7$', 'interpreter','latex')
hold on

%% Plot measured torques obtained from experiment
datafolder = '../matlab/data/Exciting_Traj/Trajectory_1/rbt_log/';

time_exp = readtable([datafolder, 'exciting_traj_time.txt']).Var1;
N_exp = length(time_exp);
tau_exp = reshape(readtable([datafolder, 'exciting_traj_torques.txt']).Var1, 7, N_exp);

hold on 
scatter(time_exp, tau_exp, 1)
title('Joint torques')
legend('$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$', '$\tau_7$', 'interpreter','latex')

%% Plot the norm of the error
subplot(212)

% find the nearest data points
time_comp = zeros(N_exp, 1);
ind_comp = zeros(N_exp, 1);
for i=1:length(time_comp)
    ind_comp(i) = find(time >= time_exp(i), 1);
    time_comp(i) = time(ind_comp(i));
    assert(time_comp(i) - time_exp(i) < 5e-3, ...
        'Difference between time_comp and time_exp larger than threshold! Inaccurate results.')
end

norm_difference = zeros(7, N_exp);
for i=1:7
    norm_difference(i,:) = vecnorm(tau(i,ind_comp)-tau_exp(i,:), 2, 1);
end

plot(time_comp, norm_difference./vecnorm(tau_exp,2,1))  
title('Norm of difference (\% of $\Vert \tau_{exp} \Vert$)', 'Interpreter','latex')
legend('$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$', '$\tau_7$', 'interpreter','latex')
