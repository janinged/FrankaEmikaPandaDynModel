datafolder = 'build/';

time = readtable([datafolder, 'exciting_traj_time.txt']).Var1;
N = length(time);
tau = reshape(readtable([datafolder, 'exciting_traj_torques.txt']).Var1, 7, N);

figure
plot(time, tau)
title('Joint torques')
legend('$\tau_1$', '$\tau_2$', '$\tau_3$', '$\tau_4$', '$\tau_5$', '$\tau_6$', '$\tau_7$', 'interpreter','latex')