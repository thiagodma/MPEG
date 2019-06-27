function outImg = getImageFromBlocks(qBlocks,m,n) %m é o numero de linhas da imagem, n é o numero de colunas da imagem

outImg = ones(m,n)*-1;
j=1;
k=1;
i=1;

while (i <= length(qBlocks))
    
    [m1,n1] = size(qBlocks{i});
    while(k+m1-1 <= n)
        outImg(j:j+(m1-1),k:k+(n1-1)) = qBlocks{i};
        k = k+m1;
        i = i+1;
    end
    j = j+m1;
    k = 1;

end

end