function plot_signature_comparison(originalXY, modifiedXY, referenceXY, title1, title2, title3)
%PLOT_SIGNATURE_COMPARISON Plot three XY trajectories for visual comparison.

    subplot(3,1,1);
    plot(originalXY(:,1), originalXY(:,2), 'k', 'LineWidth', 1.2);
    grid on;
    axis equal;
    title(title1);
    xlabel('X');
    ylabel('Y');
    set(gca, 'FontSize', 12);

    subplot(3,1,2);
    plot(modifiedXY(:,1), modifiedXY(:,2), 'b', 'LineWidth', 1.2);
    grid on;
    axis equal;
    title(title2);
    xlabel('X');
    ylabel('Y');
    set(gca, 'FontSize', 12);

    subplot(3,1,3);
    plot(referenceXY(:,1), referenceXY(:,2), 'r', 'LineWidth', 1.2);
    grid on;
    axis equal;
    title(title3);
    xlabel('X');
    ylabel('Y');
    set(gca, 'FontSize', 12);
end
