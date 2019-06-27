function outImg = getImageFromMsg(msg,type,m,n)

Q1 = [16 14 13 15 19 28 37 55;   %matriz utilizada para fazer a quantização de Y
    14 13 15 19 28 37 55 64;
    13 15 19 28 37 55 64 83;
    15 19 28 37 55 64 83 103;
    19 28 37 55 64 83 103 117;
    28 37 55 64 83 103 117 117;
    37 55 64 83 103 117 117 111;
    55 64 83 103 117 117 111 90];

Q2 = [18 18 23 34 45 61 71 92;   %matriz utilizada para fazer a quantização de U/V
    18 23 34 45 61 71 92 92;
    23 34 45 61 71 92 92 104;
    34 45 61 71 92 92 104 115;
    45 61 71 92 92 104 115 119;
    61 71 92 92 104 115 119 112;
    71 92 92 104 115 119 112 106;
    92 92 104 115 119 112 106 100];

if(type == 1)
    Q = Q1;
else
    Q = Q2;
end

zzBlocks_matrix = getzzBlocks(msg);
Blocks = invZigZag(zzBlocks_matrix);
for i=1:length(Blocks)
    
    Blocks{i} = Blocks{i}.*Q;
    Blocks{i} = idct2(Blocks{i});
    Blocks{i} = Blocks{i} + 128;
    
end
outImg = double(getImageFromBlocks(Blocks,m,n));

end