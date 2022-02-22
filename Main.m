clear;
%Step1
%Image division
ext='*.gif; *.jpg; *.png; *.tif';
folder='C:\Users\Maahi\Desktop\Images';
image=uigetfile([folder '\' ext]);
old_image=fullfile(folder,image);
copyfile(old_image,['C:\Users\Maahi\Desktop\Sample\' image]);
figure(1);
imshow(old_image);
whos old_image;
N = numel(old_image);

%Arnold Transform:
%N specifies the number of Iterations for the Arnold Transform
[LL,LH,HL,HH] = dwt2(old_image,'db5');
disp(LL);

%disp(LH);
%disp(HL);
%disp(HH);
im = LL;
arnold(im,N); % <- call the other function
figure(2);
imshow(im);

function arnold(LLimage,N)
[rown,coln]=size(LLimage);
newim = zeros;
for inc=1:N
for row=1:rown
    for col=1:coln
        nrowp = row;
        ncolp = col;
        for ite=1:inc
            newcord =[1 1;1 2]*[nrowp ncolp]';
            nrowp=newcord(1);
            ncolp=newcord(2);
        end
        newim(row,col)=LLimage((mod(nrowp,rown)+1),(mod(ncolp,coln)+1));
        
     end
end
end


%Step2
N1 = numel(newim);
J = imresize(newim, [256 256]);
[r c]=size(J);
bs=32; % Block Size (32x32)
nob=64; % Total number of 32x32 Blocks
% Dividing the image into 32x32 Blocks
kk=0;
l=0;
[F]=zeros(1,64);
%[B0]=zeros(32,32);
for i=1:(r/bs)
  for j=1:(c/bs)    
    B0=J((bs*(i-1)+1:bs*(i-1)+bs),(bs*(j-1)+1:bs*(j-1)+bs));      
  end
  kk=kk+(r/bs);
end
whos newim;
whos B0;
Eim = imresize(B0,[8,8]);
%skewtent map
r=0.1000;
Vn=0.5000;
%initial
%Random number generation
for a=1:65536
if (Vn>=0)&&(Vn<=r)
    V=Vn/r;
end

if (Vn>r)&&(Vn<=1)
    V=(1-Vn)/(1-r);
end
end
Z=V*(power(10,14));
%Modulo operation
P=mod(Z,256);
disp(P);
p = typecast(P, 'uint8');

%disp(p);
%4D mapping
a = 45:55;
b = 20:24;
c = 13;
d = 7.8;
e = 35;
f = 29;
x1 = -2.510;
x2 = 10.3215;
x3 = -8;
x4 = -7.8;
disp(x4);
X1 = a*(x2-x1)+x2*x3;
X2 = b*(x2+x1)+x1*x2;
X3 = -c*x3-e*x4+x1*x2;
X4 = -d*x4+f*x3+x1*x2;
x4 = typecast(X4 , 'uint8');
K1 = bitxor(p,x4);
disp(K1);
E = xor(K1,Eim);
E = imresize(E,[32,32]);
whos E;
figure(3);
imshow(E);
end
