function [new_I, change_list] = hist_equalization(I, round)
    hist = make_histogram(I);

    [M, N, C] = size(I);
    
    % Menyiapkan change_list untuk untuk semua channel
    change_list = zeros(size(hist,2));

    for j = 1 : size(hist, 2)
        if j == 1
            change_list(j) = mean(hist(:, j)) / (M*N);
        else
            change_list(j) = change_list(j - 1) + mean(hist(:, j)) / (M*N);
            change_list(j - 1) = change_list(j - 1) * 255;
            if round == 1
                change_list(j - 1) = floor(change_list(j - 1));
            end

            if j == size(hist, 2)
                change_list(j) = change_list(j) * 255;
                if round == 1
                    change_list(j) = floor(change_list(j));
                end
            end
        end
    end

    % MEMBUAT CITRA YANG HISTOGRAMNYA DIRATAKAN
    % Menyiapkan matriks kosong sesuai dengan ukuran I
    new_I = zeros(M, N, C);
    
    % Mengganti setiap nilai pixel pada I dengan di change_list di channel 
    % yang sesuai, pada indeks sesuai dengan nilai pixel tersebut
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                new_I(i,j,k) = change_list(I(i,j,k)+1);
                
                % OPERASI CLIPPING
                % Nilai pixel yang lebih dari 255 diubah jadi 255
                if new_I(i,j,k) > 255
                    new_I(i,j,k) = 255;
                % Nilai pixel yang kurang dari 0 diubah jadi 0
                elseif new_I(i,j,k) < 0
                    new_I(i,j,k) = 0;
                end
            end
        end
    end
    
    new_I = uint8(new_I);
end
