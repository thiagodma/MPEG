function [m,n] = getmnFromFilename(filename)

i=1;

while(i<= length(filename))
    if(filename(i) == '_')
        break;
    end 
    i = i+1;
end
i = i+1;
while(i<=length(filename))
    if(filename(i) == '_')
        break;
    end
    i = i+1;
end

m = filename(i+1:i+3);
n = filename(i+5:i+7);
        
m = str2num(m);
n = str2num(n);

end