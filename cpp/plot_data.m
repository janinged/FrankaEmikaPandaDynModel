%% Plot a comparison of the model and the real data
figure
subplot(211)

%% Plot torques calculated from identified model
datafolder = 'build/';

time = readtable([datafolder, 'exciting_traj_time.txt']).Var1;
N = length(time);
tau = reshape(readtable([datafolder, 'exciting_traj_torques.txt']).Var1, 7, []);
mass = reshape(readmatrix([datafolder, 'exciting_traj_mass.txt']), 7,[],7);
mass = shiftdim(mass, 2);

plot(time, tau)
title('Joint torques')
legend('$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$', '$\tau_7$', 'interpreter','latex')
hold on

%% Plot measured torques obtained from experiment
% datafolder = '../matlab/data/Exciting_Traj/Trajectory_1/rbt_log/';

% time_exp = readtable([datafolder, 'exciting_traj_time.txt']).Var1;
% N_exp = length(time_exp);
% tau_exp = reshape(readtable([datafolder, 'exciting_traj_torques.txt']).Var1, 7, N_exp);

datafolder = '../../Ulin_VK/data/exciting_trajectory/';

datatable = readtable([datafolder, 'exciting_trajectory.csv']);
time_exp = datatable.time;
N_exp = length(time_exp);
tau_exp = [datatable.tau_J_1 datatable.tau_J_2 datatable.tau_J_3 datatable.tau_J_4 datatable.tau_J_5 datatable.tau_J_6 datatable.tau_J_7]';

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

%% Plot norm of the difference in mass matrices from libfranka and model identified by Gaz et al.
M_exp = [datatable.m_11 datatable.m_21 datatable.m_31 datatable.m_41 datatable.m_51 datatable.m_61 datatable.m_71
    datatable.m_12 datatable.m_22 datatable.m_32 datatable.m_42 datatable.m_52 datatable.m_62 datatable.m_72
    datatable.m_13 datatable.m_23 datatable.m_33 datatable.m_43 datatable.m_53 datatable.m_63 datatable.m_73
    datatable.m_14 datatable.m_24 datatable.m_34 datatable.m_44 datatable.m_54 datatable.m_64 datatable.m_74
    datatable.m_15 datatable.m_25 datatable.m_35 datatable.m_45 datatable.m_55 datatable.m_65 datatable.m_75
    datatable.m_16 datatable.m_26 datatable.m_36 datatable.m_46 datatable.m_56 datatable.m_66 datatable.m_76
    datatable.m_17 datatable.m_27 datatable.m_37 datatable.m_47 datatable.m_57 datatable.m_67 datatable.m_77];
M_exp = reshape(M_exp, [], 7,7);
M_exp = shiftdim(M_exp, 1);

diff_mass = mass(:,:,ind_comp)-M_exp;
norm_diff_mass = reshape(pagenorm(diff_mass, 2), [],1);
figure
plot(norm_diff_mass)
