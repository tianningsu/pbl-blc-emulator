function d = find_height(a, b, c)
    % Find the index i such that a(i) <= c < a(i+1)
    i = find(a <= c & c < circshift(a, -1), 1);

    % Check if i is found
    if isempty(i)
        error('Value c is out of range');
    else
        % Use linear interpolation to find the specific height 'd'
        d = interp1([a(i), a(i+1)], [b(i), b(i+1)], c);
    end
end