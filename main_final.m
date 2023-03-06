%Tshepo Yane
%Project 1
%BE 566
clc
%clear all
%load data
load('air500.mat');

%plot a directed graph of 500 largest airports
G=digraph(air500matrix,air500labels);
%figure
plot(G,'EdgeAlpha',0.08,'NodeColor','r')


%% Centrality mesurements
%degrees
C_outdegree= centrality(G,"outdegree");
C_outdegree_avg=mean(C_outdegree);
C_outdegree_std=std(C_outdegree);


C_indegree= centrality(G,"indegree");
C_indegree_avg=mean(C_indegree);
C_indegree_std=std(C_indegree);

%Plot of the out degree of the network
subplot(2,1,1)
histogram(C_outdegree,50,"FaceColor","r")
xlabel("Out Degree",'Interpreter','latex','FontSize',15)
ylabel("Number of nodes",'Interpreter','latex','FontSize',15)
title("Distribution of out-degree of network",'Interpreter','latex','FontSize',20)
grid on
grid minor

%Plot of the out degree of the network
subplot(2,1,2)
histogram(C_indegree,50,"FaceColor","m")
xlabel("Out Degree",'Interpreter','latex','FontSize',15)
ylabel("Number of nodes",'Interpreter','latex','FontSize',15)
title("Distribution of in-degree of network",'Interpreter','latex','FontSize',20)
grid on
grid minor

% results mean this is a small world network
%%

%betweeness 
C_betweenees=centrality(G,"betweenness");
C_betweenees_avg=mean(C_betweenees);
C_betweenees_std=std(C_betweenees);

%pathlength
d = distances(G);
d_avg=mean(d,"all");
d_std=std(d);
d_mean=mean(d_std);


%Clustering coefficient calculation .
clust_C  = clustering_coef_bu(air500matrix);
clust_C_avg=mean(clust_C);
clust_C_std=std(clust_C);

%% Apendend all calculation  into cells
DATA=array2table([C_outdegree,C_indegree,C_betweenees,clust_C]);
labels_table=cell2table(air500labels);
DATA_w_labels=[labels_table,DATA];

%% plot a graph of outdegree and in degree
ennd=50;
plot(C_outdegree(1:ennd),"-o")
xtickangle(90)
xticks([1:1:ennd])
xticklabels(air500labels(1:ennd))
xlabel("Airport")
ylabel("Out degree")
%% rank airports using different metrics
Sorted_out_deg=sortrows(DATA_w_labels,"Var1",'descend');
Sorted_in_deg=sortrows(DATA_w_labels,"Var2",'descend');
Sorted_in_betwe=sortrows(DATA_w_labels,"Var3",'descend');
Sorted_in_clust=sortrows(DATA_w_labels,"Var4",'descend');

%% removing top 10% of nodes
Sorted_out_deg_rem=Sorted_out_deg(51:end,:);
%Sorted_in_deg=sortrows(DATA_w_labels,"Var2",'descend');
%Sorted_in_betwe=sortrows(DATA_w_labels,"Var3",'descend');
%Sorted_in_clust=sortrows(DATA_w_labels,"Var4",'descend');
%% 
total = convertCharsToStrings(air500labels);
random=convertCharsToStrings(table2cell(Sorted_out_deg_rem(:,1)));
sorted = sort(random); 
store_index = zeros(1, length(sorted)); 
for i = 1:length(sorted)
    store_index(i) = find(strcmp(total, sorted(i)));
end
%% find top 50
% sort top 50 
ennd=50;
out_deg_top=Sorted_out_deg(1:ennd,:);
Sorted_out_deg_top=sortrows(out_deg_top,"air500labels");

%% find adjency matr of 450
New_mat=air500matrix(store_index,store_index);

%com= find((Sorted_out_deg_top(:,1) = DATA_w_labels(:,1)));
%% plot new network
% use old labels to make new adjancey matrix
% match new labels to old labels
%labels_rem=find(Sorted_out_deg_rem{:,1}

%% 
%plot a directed graph of 500 largest airports with top 10% removed
G=digraph(air500matrix,air500labels);
figure
%plot(G,'EdgeAlpha',0.08,'NodeColor','r')
%% *******************RANDOM NETWORK********************************
% randomize network
ITER=10;
[Random,eff] = randmio_dir_connected(air500matrix, ITER);

%%
% Random=air500matrix(:, randperm(size(air500matrix, 2)));
% G_random=digraph(Random,air500labels);
% %figure
% plot(G,'EdgeAlpha',0.08,'NodeColor','r')

%% Run Centrality mesurements on random network

%plot a directed graph of 500 largest airports
G_random=digraph(Random,air500labels);
%figure
%plot(G_random,'EdgeAlpha',0.08,'NodeColor','r')

%degrees
C_outdegree_rand= centrality(G_random,"outdegree");
C_indegree_rand= centrality(G_random,"indegree");

%betweeness 
C_betweenees_rand=centrality(G_random,"betweenness");

%pathlength
d_rand = distances(G_random);

%Clustering coefficient calculation .
clust_C_rand  = clustering_coef_bu(Random);

%% Apendend all calculation  into cells fopr random network
DATA_rand=array2table([C_outdegree_rand,C_indegree_rand,C_betweenees_rand,clust_C_rand]);
DATA_w_labels_rand=[labels_table,DATA_rand];

%% comparing the 2 networks

subplot(1,2,1)
boxplot(clust_C,'Notch','on','Labels',{'Clustering Coeffeint'})
ylabel("Clustering Coeffeint",'Interpreter','latex','FontSize',15)
grid on
grid minor
subplot(1,2,2)
boxplot(C_betweenees,'Notch','on','Labels',{'Betweeness centrality'})
ylabel("Betweeness centrality",'Interpreter','latex','FontSize',15)
grid on
grid minor

%%


