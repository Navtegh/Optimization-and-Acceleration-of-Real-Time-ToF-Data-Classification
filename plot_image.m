function plot_image(image_cat, mat_list_names, Accuracy, jhj)

    image = zeros(size(image_cat));
    for i = 1:numel(mat_list_names)
        image(image_cat == mat_list_names{i,1}) = i;
    end

    imagesc(image);

    h = findobj(gcf,'type','image');
    xdata = get(h, 'XData');
    ydata = get(h, 'YData');
    M = size(get(h,'CData'), 1);
    N = size(get(h,'CData'), 2);

    if M > 1
        pixel_height = diff(ydata) / (M-1);
    else
        % Special case. Assume unit height.
        pixel_height = 1;
    end
    
    if N > 1
        pixel_width = diff(xdata) / (N-1);
    else
        % Special case. Assume unit width.
        pixel_width = 1;
    end
    
    y_top = ydata(1) - (pixel_height/2);
    y_bottom = ydata(2) + (pixel_height/2);
    y = linspace(y_top, y_bottom, M+1);

    x_left = xdata(1) - (pixel_width/2);
    x_right = xdata(2) + (pixel_width/2);
    x = linspace(x_left, x_right, N+1);

    xv = zeros(1, 2*numel(x));
    xv(1:2:end) = x;
    xv(2:2:end) = x;
    
    yv = repmat([y(1) ; y(end)], 1, numel(x));
    yv(:,2:2:end) = flipud(yv(:,2:2:end));
    
    xv = xv(:);
    yv = yv(:);
    
    yh = zeros(1, 2*numel(y));
    yh(1:2:end) = y;
    yh(2:2:end) = y;
    
    xh = repmat([x(1) ; x(end)], 1, numel(y));
    xh(:,2:2:end) = flipud(xh(:,2:2:end));
    
    xh = xh(:);
    yh = yh(:);

    box = [0.5 0.5; 0.5 60.5; 80.5 60.5; 80.5 0.5; 0.5 0.5];

    a = [20.5 0.5; 20.5 60.5];
    b = [40.5 0.5; 40.5 60.5];
    c = [60.5 0.5; 60.5 60.5];

    d = [0.5 20.5; 20.5 20.5];
    e = [0.5 40.5; 20.5 40.5];

    f = [20.5 15.5; 40.5 15.5];
    g = [20.5 30.5; 40.5 30.5];
    h_h = [20.5 45.5; 40.5 45.5];

    i = [40.5 20.5; 60.5 20.5];
    j = [40.5 40.5; 60.5 40.5];

    k = [60.5 15.5; 80.5 15.5];
    l = [60.5 30.5; 80.5 30.5];
    m = [60.5 45.5; 80.5 45.5];
    

    h = imagesc(image);
    colorbar('Ticks', unique(image), ...
        'TickLabels', mat_list_names{:,1})
    title(['HETEROGENEOUS MATERIAL (Accuracy is ',num2str(Accuracy),'%)'], '14 Materials')
    
    map = [1 1 0; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 1 1 1;
        0.3 0.4 0; 0.9 1 0.5; 0.2 0.1 0.5; 1 0 1;
        0.1 0.5 0.8; 0.2 0.7 0.6; 0.8 0.7 0.3; 0.5 0 0.5 ];
    colormap(map)

    xticks([1 20 40 60 80])
    yticks([1 15 20 30 40 45 60])
    xticklabels({'pixel = 1','pixel = 20','pixel = 40', 'pixel = 60', 'pixel = 80'})
    yticklabels({'pixel = 1', 'pixel = 15', 'pixel = 20', 'pixel = 30', 'pixel = 40', 'pixel = 45', 'pixel = 60'})

    ax = ancestor(h, 'axes');
    line('Parent', ax, 'XData', xh, 'YData', yh, ...
        'Color', 'k', 'LineWidth', 0.1,'LineStyle', ':', 'Clipping', 'off');
    line('Parent', ax, 'XData', xv, 'YData', yv, ...
        'Color', 'k', 'LineWidth', 0.1,'LineStyle', ':', 'Clipping', 'off');

    line('Parent', ax, 'XData', box(:,1), 'YData', box(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData',a(:,1) , 'YData', a(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData',b(:,1), 'YData', b(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', c(:,1), 'YData', c(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', d(:,1), 'YData', d(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', e(:,1), 'YData', e(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData',f(:,1) , 'YData', f(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', g(:,1), 'YData', g(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', h_h(:,1), 'YData', h_h(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');
    
    line('Parent', ax, 'XData', i(:,1), 'YData', i(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

     line('Parent', ax, 'XData', j(:,1), 'YData', j(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');
    
    line('Parent', ax, 'XData', k(:,1), 'YData', k(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', l(:,1), 'YData', l(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

    line('Parent', ax, 'XData', m(:,1), 'YData', m(:,2), ...
        'Color', 'k', 'LineWidth', 2, 'Clipping', 'off');

end