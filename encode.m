%function bitstream = encoder(Ab,C,msg)
%
%   Codifica uma mensagem com um c�digo VLC.
%
% - Recebe como par�metro:
%   Ab: O alfabeto poss�vel para a fonte. � uma matriz.
%   C : O c�digo bin�rio que ser� utilizado para codificar a fonte. � uma
%       c�lula (cell). 
%   msg: A mensagem a ser enviada.
%
% - Retorna: 
%   bitstream: o bitstream gerado. O bitstream gerado est� no formato char.
%   
% - Exemplo:
%     Ab = ['A' 'B' 'C' 'D'];
%      C = {'0','10','110','111'}; 
%    msg = 'ABBACDDAAABCCCAAAAD';
%    bitstream = encode(Ab,C,msg);
function bitstream = encode(Ab,C,msg)

for i=1:length(Ab)
    Abx(i) = Ab{i};
end

Ab = Abx;

n = length(msg);
bitstream = [];

%Para todos os elementos da mensagem.
for (i = 1:1:n)
    %Encontra o index do elemento atual (msg(i)) no c�digo.
    idx = (msg(i) == Ab);
    
    %Anexa ao bitstream o c�digo bin�rio referente ao elemento atual.
    bitstream = [bitstream C{idx}];
end

