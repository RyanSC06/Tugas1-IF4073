function [new_I, minValue, maxValue] = contrast_stretching(I)
    % Membuat histogram dari I
    hist = make_histogram(I);

    % Mempersiapkan matriks citra keluaran seukuran I
    [M, N, C] = size(I);
    new_I = zeros(M, N, C);
    minValue = zeros(C);
    maxValue = zeros(C);
    
    % ITERASI CHANNEL
    for k = 1 : C
        % Menemukan nilai pixel maksimum dan minimum
        % di setiap channel, yang jumlahnya != 0
        minValue(k) = 0;
        maxValue(k) = 0;
    
        for j = 1 : size(hist,2)
            if hist(k,j) > 0
                minValue(k) = j-1;
                break;
            end
        end
    
        for j = size(hist,2) : -1 : 1
            if hist(k,j) > 0
                maxValue(k) = j-1;
                break;
            end
        end
        
        % Iterasi baris dan kolom untuk mengganti nilai pada I
        % dengan nilai yang didapat dari rumus di bawah ini
        % Hasil disimpan di new_I
        for i = 1 : M
            for j = 1 : N
                new_I(i,j,k) = 255 * (double(I(i,j,k)) - minValue(k)) / (maxValue(k) - minValue(k));
            end
        end
    end

    new_I = uint8(new_I);
end