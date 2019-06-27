function msg = MPEG(filename,N)   %N: tamanho dos blocos de predição
tic
nFrames = 300;
[n,m] = getmnFromFilename(filename);

[Y,U,V] = readyuv(filename, n, m, nFrames);
Y = double(Y);
U = double(U);
V = double(V);

Blocks = getBlocks(N,Y(:,:,1));
sizeMVs = length(Blocks);

msg = ones(m*n*nFrames,1)*1.5;
k = 1;

msg_Y = JPEG(Y(:,:,1),1);
%Y(:,:,1) = getImageFromMsg(msg_Y,1,m,n);
msg_U = JPEG(U(:,:,1),2);
%U(:,:,1) = getImageFromMsg(msg_U,2,m/2,n/2);
msg_V = JPEG(V(:,:,1),2);
%V(:,:,1) = getImageFromMsg(msg_V,2,m/2,n/2);

msg(k) = sizeMVs;   %manda a qtd de vetores de movimento
k = k+1;

msg(k) = length(msg_Y); %manda o numero de coeficientes de Y
k = k+1;
msg(k:k+length(msg_Y)-1) = msg_Y;   %manda os coeficientes de Y
k = k + length(msg_Y);

msg(k) = length(msg_U); %manda o numero de coeficientes de U
k = k+1;
msg(k:k+length(msg_U)-1) = msg_U;   %manda os coeficientes de U
k = k + length(msg_U);

msg(k) = length(msg_V); %manda o numero de coeficientes de V
k = k+1;
msg(k:k+length(msg_V)-1) = msg_V;   %manda os coeficientes de V
k = k + length(msg_V);

for i=1:nFrames-1
    
    [predictedY,MVs] = ME(Y(:,:,i),Y(:,:,i+1),N);
    msg(k:k+sizeMVs-1) = MVs;   %manda os motion vectors
    k = k+sizeMVs;
    resY = Y(:,:,i+1) - predictedY;
    msg_Y = JPEG(resY,1);
    Y(:,:,i+1) = getImageFromMsg(msg_Y,1,m,n) + predictedY;
    msg(k) = length(msg_Y); %manda o numero de coeficientes do resíduo de Y
    k = k+1;
    msg(k:k+length(msg_Y)-1) = msg_Y;   %manda os coeficientes do resíduo de Y
    k = k+length(msg_Y);
    
    predictedU = getU_V_FromMVs(MVs,U(:,:,i),N/2,m/2,n/2);
    resU = U(:,:,i+1) - predictedU;
    msg_U = JPEG(resU,2);
    U(:,:,i+1) = getImageFromMsg(msg_U,2,m/2,n/2) + predictedU;
    msg(k) = length(msg_U); %manda o numero de coeficientes do resíduo de U
    k = k+1;
    msg(k:k+length(msg_U)-1) = msg_U;   %manda os coeficientes do resíduo de U
    k = k+length(msg_U);
    
    predictedV = getU_V_FromMVs(MVs,V(:,:,i),N/2,m/2,n/2);
    resV = V(:,:,i+1) - predictedV;
    msg_V = JPEG(resV,2);
    V(:,:,i+1) = getImageFromMsg(msg_V,2,m/2,n/2) + predictedV;
    msg(k) = length(msg_V); %manda o numero de coeficientes do resíduo de V
    k = k+1;
    msg(k:k+length(msg_V)-1) = msg_V;   %manda os coeficientes do resíduo de V
    k = k+length(msg_V);
end


msg = msg(msg~=1.5);

bitstream2 = Compress(filename,msg,m,n,N);

toc
end