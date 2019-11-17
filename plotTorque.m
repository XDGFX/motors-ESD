subplot(1, 3, 1)

hold on
plot([0, 1, 0])
plot([1, 2, 2, 3],[1, 1, -1, -1])
grid on
grid minor
ylim([-1.5 1.5])
legend("speed", "torque")

subplot(1, 3, 2)

hold on
plot([0, 1, 1, 0])
plot([1, 2, 2, 3, 3, 4],[0.5, 0.5, 0, 0, -0.5, -0.5])
grid on
grid minor
ylim([-1.5 1.5])
legend("speed", "torque")

subplot(1, 3, 3)

hold on
plot([0 0.1 0.9 1],[0, 1, 1, 0])
plot([0 0.1 0.1 0.9 0.9 1],[5, 5, 0, 0, -5, -5])
grid on
grid minor
ylim([-1.5 1.5])
legend("speed", "torque")
