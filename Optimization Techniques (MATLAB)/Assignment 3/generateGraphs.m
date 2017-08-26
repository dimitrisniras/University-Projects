PlotContour
figure(2)
hold on
names = { 'Constant Step' 'Step Optimization' 'Heuristic Strategy'};
Steepest = { @alg_meg_kathodou1 @alg_meg_kathodou2 @alg_meg_kathodou3};
origin = [ [-0.5 -0.5]' [0.5 0.5]' [-2 -1]' [-3 3]' ];
epsilon = 10^(-8);

for j=1:length(origin(1,:))
    for i = 1:length(Steepest)
        plotTitle = sprintf('Steepest Descent %s' ,names{i});
        x = Steepest{i}(epsilon,origin(:,j));        
        h = plot(x(1,:),x(2,:),'rx--', 'MarkerSize', 10, 'LineWidth', 2);
        ylabel('y')
        xlabel('x')
        title(plotTitle);
        point = sprintf('Origin : [%s %s]', ...
                num2str(origin(1,j)) , num2str(origin(2,j)));
        t = text(1,-3,point);
        legendComment = sprintf('Points');
        legend(h,legendComment,'Location','BestOutside');
        name = sprintf('Steepest_Descent_%s_%d',names{i},j);
        saveas(h, [pwd '\Graphs\' name],'jpg');
        delete(h)
        delete(t)
    end
end

Newton = { @alg_newton1 @alg_newton2 @alg_newton3};

for i = 1:length(Newton)
    plotTitle = sprintf('Newton %s' ,names{i});
    for j=1:length(origin(1,:))
        x = Newton{i}(epsilon,origin(:,j));        
        h = plot(x(1,:),x(2,:),'rx--', 'MarkerSize', 10, 'LineWidth', 2);
        ylabel('y')
        xlabel('x')        
        title(plotTitle);
        point = sprintf('Origin : [%s %s]', ...
                num2str(origin(1,j)) , num2str(origin(2,j)));
        t = text(1,-3,point);
        legendComment = sprintf('Points');
        legend(h,legendComment,'Location','BestOutside');
        name = sprintf('Newton %s_%d',names{i},j);
        saveas(h, [pwd '\Graphs\' name],'jpg');
        delete(h)
        delete(t)
    end
end

Levenberg = { @alg_levenberg1 @alg_levenberg2 @alg_levenberg3};

for i = 1:length(Levenberg)
    plotTitle = sprintf('Levenberg Marquadt %s' ,names{i});
    for j=1:length(origin(1,:))
        x = Levenberg{i}(epsilon , origin(:,j));        
        h = plot(x(1,:),x(2,:),'rx--', 'MarkerSize', 10, 'LineWidth', 2);
        ylabel('y')
        xlabel('x')
        title(plotTitle);
        point = sprintf('Origin : [%s %s]', ...
                num2str(origin(1,j)) , num2str(origin(2,j)));
        t = text(1,-3,point);
        legendComment = sprintf('Points');
        legend(h,legendComment,'Location','BestOutside');
        name = sprintf('Levenberg Marquadt %s_%d',names{i},j);
        saveas(h, [pwd '\Graphs\' name],'jpg');
        delete(h)
        delete(t)
    end
end

ConjGrad = { @alg_suz_klisewn1 @alg_suz_klisewn2 ...
    @alg_suz_klisewn3};

for i = 1:length(ConjGrad)
    plotTitle = sprintf('Conjugate Gradient %s' ,names{i});
    for j=1:length(origin(1,:))
        x = ConjGrad{i}(epsilon , origin(:,j));        
        h = plot(x(1,:),x(2,:),'rx--', 'MarkerSize', 10, 'LineWidth', 2);
        ylabel('y')
        xlabel('x')
        title(plotTitle);
        point = sprintf('Origin : [%s %s]', ...
                num2str(origin(1,j)) , num2str(origin(2,j)));
        t = text(1,-3,point);
        legendComment = sprintf('Points');
        legend(h,legendComment,'Location','BestOutside');
        name = sprintf('Conjugate Gradient %s_%d',names{i},j);
        saveas(h, [pwd '\Graphs\' name],'jpg');
        delete(h)
        delete(t)
    end
end

QuasiNewton = { @alg_quasiNewton1 @alg_quasiNewton2 ...
    @alg_quasiNewton3};

for i = 1:length(QuasiNewton)
    plotTitle = sprintf('Quasi Newton %s' ,names{i});
    for j=1:length(origin(1,:))
        x = QuasiNewton{i}(epsilon , origin(:,j));        
        h = plot(x(1,:),x(2,:),'rx--', 'MarkerSize', 10, 'LineWidth', 2);
        ylabel('y')
        xlabel('x')
        title(plotTitle);
        point = sprintf('Origin : [%s %s]', ...
                num2str(origin(1,j)) , num2str(origin(2,j)));
        t = text(1,-3,point);
        legendComment = sprintf('Points');
        legend(h,legendComment,'Location','BestOutside');
        name = sprintf('Quasi Newton %s_%d',names{i},j);
        saveas(h, [pwd '\Graphs\' name],'jpg');
        delete(h)
        delete(t)
    end
end