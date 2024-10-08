function [hist] = make_histogram(I)
    [M, N, C] = size(I);
    
    % Menyiapkan matriks seukuran channel x #pixel_level
    hist = zeros(C, 256);
    
    % Iterasi setiap nilai pixel pada I kemudian nilai pada hist pada
    % channel yang sesuai, pada indeks sesuai dengan nilai pixel I yang
    % sedang disorot, ditambahkan dengan 1
    for k = 1 : C
        for i = 1 : M
            for j = 1 : N
                hist(k, (I(i,j,k) + 1)) = hist(k, (I(i,j,k) + 1)) + 1;
            end
        end
    end
end