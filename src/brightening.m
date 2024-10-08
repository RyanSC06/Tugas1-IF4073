function [bright] = brightening(I, a, b)
    [M, N, C] = size(I);

    % Menyiapkan matriks citra keluaran seukuran I
    bright = zeros(M, N, C);

    % Iterasi setiap nilai pada semua channel matriks I untuk
    % mengganti nilai tersebut dengan rumus di bawah ini.
    % Hasil diletakkan dalam bright
    for i = 1 : M
        for j = 1 : N
            for k = 1 : C
                bright(i,j,k) = a * I(i,j,k) + b;
                
                % OPERASI CLIPPING
                % Nilai pixel yang lebih dari 255 diubah jadi 255
                if bright(i,j,k) > 255
                    bright(i,j,k) = 255;
                % Nilai pixel yang kurang dari 0 diubah jadi 0
                elseif bright(i,j,k) < 0
                    bright(i,j,k) = 0;
                end
            end
        end
    end
    
    bright = uint8(bright);
end