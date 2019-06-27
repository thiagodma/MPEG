function output = getU_V_FromMVs(MVs,X,N,m,n) 

Blocks_in = getBlocks(N,X);
Blocks_out = cell(size(Blocks_in));

MVs = round(MVs/2);

for i=1:length(Blocks_in) 
    Blocks_out{i} = Blocks_in{MVs(i)};
end

output = getImageFromBlocks(Blocks_out,m,n);
output = double(output);
end