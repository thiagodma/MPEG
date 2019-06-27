function Blocks = getBlocks(N,img)  %essa função gera os blocos que serão quantizados

nBlocks = ceil((size(img,1)*size(img,2))/(N^2));
Blocks = cell(nBlocks,1);

m = size(img,1);
n = size(img,2);

x=m;
y=n;

if(mod(m,N) ~= 0)
   x = m+(N-mod(m,N));
end

if(mod(n,N) ~= 0)
   y = n+(N-mod(n,N));
end
    
auxImg = zeros(x,y);
auxImg(1:m,1:n) = img;
img = auxImg;

i=1;
j=1;
k=1;

while(i <= nBlocks)
    
    while(k+N-1 <= size(img,2))
        Blocks{i} = img(j:j+(N-1),k:k+(N-1));
        k = k+N;
        i = i+1;
    end
    
    j = j+N;
    k = 1;
end

end