function [predictedY,MVs] = ME(frame1,frame2,N)

m = size(frame1,1);
n = size(frame1,2);

Blocks1 = getBlocks(N,frame1);
Blocks2 = getBlocks(N,frame2);
Blocks_out = cell(size(Blocks1));
x = ones(length(Blocks1),1)*-1;
MVs = zeros(size(Blocks1));

[a,b] = size(Blocks1{1});

for i=1:length(Blocks1)
    for j=1:length(Blocks2)
        
        if((size(Blocks1{j}) == size(Blocks1{1})) & (size(Blocks2{i}) == size(Blocks1{1})))
            x(j) = MSE(Blocks2{i},Blocks1{j});
        else
            Blocks_out{j} = Blocks1{j};
            MVs(j) = j;
        end
        
    end
    
    if(isempty(Blocks_out{i}))
        x(x==-1) = max(x)+1;
        
        [Y,I] = min(x);
        Blocks_out{i} = Blocks1{I};
        MVs(i) = I;
    end
    
end

predictedY = getImageFromBlocks(Blocks_out,m,n);
predictedY = double(predictedY);
end