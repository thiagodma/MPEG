function output = getYFromMVs(MVs,Y,N,m,n) 

Blocks_in = getBlocks(N,Y);
Blocks_out = cell(size(Blocks_in));

for i=1:length(Blocks_in) 
    Blocks_out{i} = Blocks_in{MVs(i)};
end

output = getImageFromBlocks(Blocks_out,m,n);
output = double(output);
end