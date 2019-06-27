function [Y,U,V] = MPEG_decoder(filename)
tic

nFrames = 300;

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

fid = fopen(filename,'rb');
N = fread(fid,1,'uint8');
m = fread(fid,1,'uint16');
n = fread(fid,1,'uint16');
tamanhoExtensao = fread(fid,1,'uint8');
extensao = char(fread(fid,tamanhoExtensao,'uint8'));
extensao = extensao';
R = fread(fid, 1, 'uint8');
sizeAb = fread(fid, 1, 'uint16');
sizeAb = sizeAb + 1;
Ab = {};
codes = {};


for i = 1:sizeAb
    Ab{i} = fread(fid, 1, 'int16');
    lengthCodes = fread(fid, 1, 'uint8');
    codes{i} = char(fread(fid, lengthCodes, 'uint8'));
    codes{i} = codes{i}';
end
codes = codes'; %transpor para ficar igual ao cell array do codificador
Ab = Ab';

bitstream = fread(fid,'uint8');
fclose(fid);

%agora já temos tudo que é necessário para decodificar a mensagem

bitstream = dec2bin(bitstream);
bitstream = reshape(bitstream',[1 size(bitstream,1)*size(bitstream,2)]);
bitstream(end-R+1:end) = [];

dmsg = decodifica_v2(Ab,codes, bitstream);

Y = zeros(m,n,nFrames);
U = zeros(m/2,n/2,nFrames);
V = zeros(m/2,n/2,nFrames);
k = 1;

sizeMVs = dmsg(k);
k = k+1;

%---------------------------------------------------------------------------------------------------
coefY = dmsg(k);    %pega o número de coeficientes de Y
k = k+1;
zzBlocks_matrixY = getzzBlocks(dmsg(k:k+coefY-1));  %pega os coeficientes de Y e ja calcula a matriz
k = k+coefY;
BlocksY = invZigZag(zzBlocks_matrixY);
for j=1:length(BlocksY)
    
    BlocksY{j} = BlocksY{j}.*Q1;
    BlocksY{j} = idct2(BlocksY{j});
    BlocksY{j} = BlocksY{j} + 128;
    
end
Y(:,:,1) = round(double(getImageFromBlocks(BlocksY,m,n)));

%----------------------------------------------------------------------------------------------------

coefU = dmsg(k);    %pega o numero de coeficientes de U
k = k+1;
zzBlocks_matrixU = getzzBlocks(dmsg(k:k+coefU-1));  %pega os coeficientes de U e ja calcula a matriz
k = k+coefU;
BlocksU = invZigZag(zzBlocks_matrixU);
for j=1:length(BlocksU)
    
    BlocksU{j} = BlocksU{j}.*Q2;
    BlocksU{j} = idct2(BlocksU{j});
    BlocksU{j} = BlocksU{j} + 128;
    
end
U(:,:,1) = round(double(getImageFromBlocks(BlocksU,m/2,n/2)));

%--------------------------------------------------------------------------------------------------

coefV = dmsg(k);    %pega o numero de coeficientes de V
k = k+1;
zzBlocks_matrixV = getzzBlocks(dmsg(k:k+coefV-1));  %pega os coeficientes de V e ja calcula a matriz
k = k+coefV;
BlocksV = invZigZag(zzBlocks_matrixV);
for j=1:length(BlocksV)
    
    BlocksV{j} = BlocksV{j}.*Q2;
    BlocksV{j} = idct2(BlocksV{j});
    BlocksV{j} = BlocksV{j} + 128;
    
end
V(:,:,1) = round(double(getImageFromBlocks(BlocksV,m/2,n/2)));

%-------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------

for i=1:nFrames-1
    
    
    MVs = dmsg(k:k+sizeMVs-1);  %pega os motion vectors
    k = k+sizeMVs;
    predictedY = getYFromMVs(MVs,Y(:,:,i),N,m,n);
    coefY = dmsg(k);    %pega o número de coeficientes de Y
    k = k+1;
    zzBlocks_matrixY = getzzBlocks(dmsg(k:k+coefY-1));  %pega os coeficientes de Y e ja calcula a matriz
    k = k+coefY;
    BlocksY = invZigZag(zzBlocks_matrixY);
    for j=1:length(BlocksY)
        
        BlocksY{j} = BlocksY{j}.*Q1;
        BlocksY{j} = idct2(BlocksY{j});
        BlocksY{j} = BlocksY{j} + 128;
        
    end
    resY = round(double(getImageFromBlocks(BlocksY,m,n)));
    Y(:,:,i+1) = resY + predictedY;
    
    %----------------------------------------------------------------------------------------------------
    predictedU = getU_V_FromMVs(MVs,U(:,:,i),N/2,m/2,n/2);
    coefU = dmsg(k);    %pega o numero de coeficientes de U
    k = k+1;
    zzBlocks_matrixU = getzzBlocks(dmsg(k:k+coefU-1));  %pega os coeficientes de U e ja calcula a matriz
    k = k+coefU;
    BlocksU = invZigZag(zzBlocks_matrixU);
    for j=1:length(BlocksU)
        
        BlocksU{j} = BlocksU{j}.*Q2;
        BlocksU{j} = idct2(BlocksU{j});
        BlocksU{j} = BlocksU{j} + 128;
        
    end
    resU = round(double(getImageFromBlocks(BlocksU,m/2,n/2)));
    U(:,:,i+1) = resU + predictedU;
    
    %--------------------------------------------------------------------------------------------------
    predictedV = getU_V_FromMVs(MVs,V(:,:,i),N/2,m/2,n/2);
    coefV = dmsg(k);    %pega o numero de coeficientes de V
    k = k+1;
    if((k+coefV-1) < length(dmsg))
        zzBlocks_matrixV = getzzBlocks(dmsg(k:k+coefV-1));  %pega os coeficientes de V e ja calcula a matriz
        k = k+coefV;
        BlocksV = invZigZag(zzBlocks_matrixV);
        for j=1:length(BlocksV)
            
            BlocksV{j} = BlocksV{j}.*Q2;
            BlocksV{j} = idct2(BlocksV{j});
            BlocksV{j} = BlocksV{j} + 128;
            
        end
        resV = round(double(getImageFromBlocks(BlocksV,m/2,n/2)));
        V(:,:,i+1) = resV + predictedV;
    else
        zzBlocks_matrixV = getzzBlocks(dmsg(k:length(dmsg)));  %pega os coeficientes de V e ja calcula a matriz
        k = k+coefV;
        BlocksV = invZigZag(zzBlocks_matrixV);
        for j=1:length(BlocksV)
            
            BlocksV{j} = BlocksV{j}.*Q2;
            BlocksV{j} = idct2(BlocksV{j});
            BlocksV{j} = BlocksV{j} + 128;
            
        end
        resV = round(double(getImageFromBlocks(BlocksV,m/2,n/2)));
        V(:,:,i+1) = resV + predictedV;
    end
        
    end
    
    Y = uint8(Y);
    U = uint8(U);
    V = uint8(V);
    
    outFilename = [];
    
    for i=1:length(filename)
        if(filename(i) == '_')
            break;
        else
            outFilename = [outFilename filename(i)];
        end
    end
    
    outFilename = strcat(outFilename, '_MPEGdecoded_',int2str(N),'.yuv');
    
    writeyuv(outFilename,Y,U,V);
    toc
end