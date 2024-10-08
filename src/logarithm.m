function [log_transformed] = logarithm(I, c)
    % Mengganti nilai setiap pixel dengan rumus di bawah ini
    % Hasil diletakkan dalam log_transformed
    log_transformed = c * log10(double(1 + I));
    log_transformed = uint8(log_transformed);
end