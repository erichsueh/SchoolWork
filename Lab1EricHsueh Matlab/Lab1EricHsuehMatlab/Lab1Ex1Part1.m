%hit run and compare the two things, the first one that's vectorized is
%clearly faster
tic
i = 2*[1:1:1000];
y = sin(i);
toc
clear;

tic
for i = 1:1000
    t(i) = 2*i;
    y(i) = sin (t(i));
end
toc
clear;