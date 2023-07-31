%%%% lecture 7 %%%%
%%%%% @tpoly  %%%% lspb trajectory
%%% HP Phan

close all; clear variables; clc;
startup_rvc;
dbstop if error
time = 0:0.1:18;

figure
[S,SD,SDD] = lspb(0, 1, time);
subplot(3,1,1)
plot(S)
subplot(3,1,2)
plot(SD)
subplot(3,1,3)
plot(SDD)



%%
[S1,SD1,SDD1] = lspb(0, 1, time,0.11);
figure
subplot(3,1,1)
plot(S1)
subplot(3,1,2)
plot(SD1)
subplot(3,1,3)
plot(SDD1)