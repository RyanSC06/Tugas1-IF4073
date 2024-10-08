function [neg] = negative(I)
    % Mengganti nilai pada setiap pixel dengan rumus di bawah ini
    neg = 255 - I;
    neg = uint8(neg);
end