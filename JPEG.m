function msg = JPEG(img,type)   %type1: Y, type2: U/V

%img = double(imread(filename));
m = size(img,1);
n = size(img,2);

Blocks = getBlocks(8,img);
qBlocks = cell(size(Blocks));   %cell com os blocos quantizados

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

if(type==1)
    Q = Q1;
else
    Q = Q2;
end


for i=1:length(Blocks)
    
    Blocks{i} = Blocks{i} - 128;
    Blocks{i} = dct2(Blocks{i});
    qBlocks{i} = round(Blocks{i}./Q);
    
end

zzBlocks_matrix = zigZag(qBlocks);

msg = getMsg(zzBlocks_matrix);

msg = msg';
%bitstream2 = Compress(filename,msg,quality,m,n);

end