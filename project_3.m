%Tshepo Yane 
%Project 3 
clc
%clear all
load('air500.mat');
G = digraph(air500matrix,air500labels);
%plot(D)

%%
%Centrality mesasurements
% an attempt to find the most important airports,

%degrees
C_outdegree= centrality(G,"outdegree");
C_outdegree_avg=mean(C_outdegree);
C_outdegree_std=std(C_outdegree);
%
C_outdegree_quantile = quantile(C_outdegree,[0.25 0.50 0.75]);
C_outdegree_iqr = iqr(C_outdegree);
%
%assiging rankings to elements
[~,idx]=ismember(C_outdegree,sort(C_outdegree,'descend'));
%combine the labels and rankings
%sort based on the dimension of the ranks
outdegree_rank=[array2table(idx) cell2table(air500labels) array2table(C_outdegree)];
outdegree_rankings=sortrows(outdegree_rank,1);

C_indegree= centrality(G,"indegree");
C_indegree_avg=mean(C_indegree);
C_indegree_std=std(C_indegree);

C_indegree_quantile = quantile(C_indegree,[0.25 0.50 0.75]);
C_indegree_iqr = iqr(C_indegree);

 %assiging rankings to elements
[~,idx]=ismember(C_indegree,sort(C_indegree,'descend'));
%combine the labels and rankings
%sort based on the dimension of the ranks
indegree_rank=[array2table(idx) cell2table(air500labels) array2table(C_indegree)];
indegree_rankings=sortrows(indegree_rank,1);

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


%% power law %****don't include****
figure
loglog(sort(C_indegree,"descend"),[1:1:500],"r*")
xlabel("In-Degree",'Interpreter','latex','FontSize',15)
ylabel("Number of nodes",'Interpreter','latex','FontSize',15)
grid on
grid minor
figure
plot(sort(C_indegree,"descend"),[1:1:500],"r*")
xlabel("In-Degree",'Interpreter','latex','FontSize',15)
ylabel("Number of nodes",'Interpreter','latex','FontSize',15)
grid on
grid minor

%% betweeness centrality
C_betweenees=centrality(G,"betweenness");

%assiging rankings to elements
[~,idx]=ismember(C_betweenees,sort(C_betweenees,'descend'));
%combine the labels and rankings
%sort based on the dimension of the ranks
C_betweenees_rank=[array2table(idx) cell2table(air500labels) array2table(C_betweenees)];
C_betweenees_rankings=sortrows(C_betweenees_rank,1);

%check if data is normally distributed 
histogram(C_betweenees,'FaceAlpha',0.7,'EdgeAlpha',0.1);
histfit(C_betweenees);
m = mean(C_betweenees);
s = std(C_betweenees);
xline([m-s],'--','-1 Standard Dev.','LineWidth',2)
xline([m],'-','Mean','LineWidth',2)
xline([m+s],'--','+1 Standard Dev.','LineWidth',2)
xlabel("Q value",'Interpreter','latex','FontSize',15)
% grid on 
% grid minor 
ax1 = gca;                   % gca = get current axis
ax1.YAxis.Visible = 'off';   % remove y-axis

%non normnally distributed!!!


C_betweenees_quantile = quantile(C_betweenees,[0.25 0.50 0.75]);
C_betweenees_iqr = iqr(C_betweenees);

%% pagerank centrality centrality
C_page_rank=centrality(G,"pagerank");

%assiging rankings to elements
[~,idx]=ismember(C_page_rank,sort(C_page_rank,'descend'));
%combine the labels and rankings
%sort based on the dimension of the ranks
C_pagerank_rank=[array2table(idx) cell2table(air500labels) array2table(C_page_rank)];
C_pagerank_rankings=sortrows(C_pagerank_rank,1);

%check if data is normally distributed 
histogram(C_page_rank,'FaceAlpha',0.7,'EdgeAlpha',0.1);
histfit(C_page_rank);
m = mean(C_page_rank);
s = std(C_page_rank);
xline([m-s],'--','-1 Standard Dev.','LineWidth',2)
xline([m],'-','Mean','LineWidth',2)
xline([m+s],'--','+1 Standard Dev.','LineWidth',2)
xlabel("Q value",'Interpreter','latex','FontSize',15)
% grid on 
% grid minor 
ax1 = gca;                   % gca = get current axis
ax1.YAxis.Visible = 'off';   % remove y-axis

%not normnally distributed!!!


C_pageRank_quantile = quantile(C_page_rank,[0.25 0.50 0.75]);
C_pageRank_iqr = iqr(C_page_rank);

%% hub centrality centrality
clc
C_hubs=centrality(G,"hubs");


%assiging rankings to elements
[~,idx]=ismember(C_hubs,sort(C_hubs,'descend'));
%combine the labels and rankings
%sort based on the dimension of the ranks
C_hubs_rank=[array2table(idx) cell2table(air500labels) array2table(C_hubs)];
C_hubs_rankings=sortrows(C_hubs_rank,1);
C_hubs_iqr=iqr(C_hubs);

h_store=[];

C_hubs_mid = quantile(C_hubs,.50); % the median
for i=1:100
R=random_directed_graph(500);
R = digraph(R);
C_hubs_rand=centrality(R,"hubs");
C_hubs_rand_iqr=iqr(C_hubs_rand,"all");
h_store(i)=C_hubs_rand_iqr;
end
Z_score=(C_hubs_iqr-mean(h_store))/std(h_store)
%% removing rows and coums based on hub
%All_labels={'ABJ','ABQ','ABZ','ACA','ACC','ACE','ADB','ADD','ADL','AEP','AGP','AKL','ALB','ALC','ALG','AMA','AMD','AMM','AMS','ANC','ANU','ARN','ATH','ATL','AUA','AUH','AUS','AYT','BAH','BCN','BDL','BEG','BEL','BEY','BFS','BGI','BGO','BGY','BHD','BHM','BHX','BIL','BIO','BJX','BKI','BKK','BLL','BLQ','BLR','BNA','BNE','BOD','BOG','BOI','BOM','BOO','BOS','BRE','BRI','BRS','BRU','BSB','BSL','BTR','BTV','BUD','BUF','BUR','BWI','BZN','CAE','CAI','CAN','CBR','CCS','CCU','CDG','CEB','CGB','CGH','CGK','CGN','CGO','CGQ','CHC','CHS','CID','CJS','CJU','CKG','CLE','CLO','CLT','CMB','CMH','CMN','CNF','CNS','CNX','COK','COS','CPH','CPQ','CPT','CRP','CSX','CTA','CTS','CTU','CUL','CUN','CUU','CVG','CWB','CWL','DAC','DAL','DAM','DAR','DAY','DCA','DEL','DEN','DFW','DKR','DLA','DLC','DME','DMK','DMM','DOH','DPS','DRS','DRW','DSM','DTW','DUB','DUR','DUS','DXB','EDI','ELP','EMA','ESB','EUG','EWR','EZE','FAI','FAO','FAR','FAT','FCO','FDF','FLL','FLN','FLR','FNC','FNT','FOC','FOR','FRA','FSD','FUE','FUK','GAU','GDL','GEG','GIG','GLA','GMP','GOA','GOI','GOT','GRB','GRO','GRR','GRU','GRZ','GSO','GSP','GUA','GUM','GVA','GYE','GYN','HAJ','HAK','HAM','HAN','HAV','HBA','HEL','HER','HGH','HIJ','HKD','HKG','HKT','HMO','HND','HNL','HOU','HPN','HRB','HRL','HSV','HYD','IAD','IAH','IBZ','ICN','ICT','IND','ISB','ISG','ISP','IST','ITM','ITO','JAN','JAX','JED','JER','JFK','JNB','JNU','KBP','KCH','KEF','KHH','KHI','KIN','KIX','KMG','KMI','KMJ','KMQ','KOA','KOJ','KRK','KRT','KTN','KUL','KWE','KWI','KWL','LAS','LAX','LBA','LBB','LCA','LCG','LCY','LED','LEJ','LEX','LGA','LGB','LGW','LHE','LHR','LHW','LIH','LIM','LIN','LIS','LIT','LJU','LOS','LPA','LPL','LTN','LUX','LYS','MAA','MAD','MAF','MAH','MAN','MAO','MBJ','MCI','MCO','MCT','MDE','MDT','MDW','MEL','MEM','MES','MEX','MFE','MFM','MGA','MHD','MHT','MIA','MID','MKE','MLA','MLE','MLI','MME','MNL','MPL','MRS','MRU','MSN','MSP','MSY','MTY','MUC','MVD','MXP','MYJ','MYR','MZG','MZT','NAN','NAP','NAS','NAT','NBO','NCE','NCL','NGB','NGO','NGS','NKG','NNG','NRT','NTE','NUE','OAK','OGG','OKA','OKC','OMA','ONT','OOL','OPO','ORD','ORF','ORK','ORY','OSL','OTP','OVD','PBI','PDX','PEK','PEN','PER','PHL','PHX','PIT','PLZ','PMI','PMO','PNH','PNQ','PNS','POA','POS','PPT','PRG','PSA','PSP','PTP','PTY','PUJ','PUS','PVD','PVG','PVR','PWM','RAK','RDU','REC','RGN','RIC','RIX','RNO','ROC','RSW','RUH','SAH','SAL','SAN','SAT','SAV','SBA','SBN','SCL','SCQ','SDF','SDJ','SDQ','SDU','SEA','SFO','SGN','SHA','SHE','SHJ','SIN','SJC','SJD','SJO','SJU','SKG','SLC','SLZ','SMF','SNA','SNN','SOF','SOU','SRQ','SSA','STL','STN','STR','STT','SUB','SUF','SVG','SVO','SVQ','SXB','SXF','SXM','SYD','SYR','SYX','SZG','SZX','TAO','TFN','TFS','THR','TIJ','TIP','TLH','TLL','TLS','TLV','TNA','TOS','TPA','TPE','TRD','TRN','TRS','TRV','TSA','TSN','TUL','TUN','TUS','TXL','TYN','TYS','UIO','UKB','UPG','URC','VCE','VER','VGO','VIE','VIX','VLC','VNO','VPS','VRN','VSA','VVI','WAW','WLG','WNZ','WUH','XIY','XMN','XNA','XRY','YEG','YHZ','YLW','YNT','YOW','YUL','YVR','YWG','YYC','YYJ','YYT','YYZ','ZAG','ZRH'};
%Threshold greater than 0.006
bignodes={'JFK','ATL','ORD','LAX','EWR','IAH','DFW','IAD','PHL','SFO','YYZ','DTW','MCO','LAS','MSP','DEN','MIA','BOS','FRA','SEA','PHX','BWI','TPA','CVG','STL','AMS','CLT','SLC','DCA','MCI','RDU','FLL'};
biggernodes={'JFK','ATL','ORD','LAX','EWR','IAH','DFW','IAD','PHL','SFO','YYZ','DTW','MCO','LAS','MSP','DEN','MIA','BOS','FRA','SEA','PHX','BWI','TPA','CVG','STL','AMS','CLT','SLC','DCA','MCI','RDU','FLL','CLE','SAN','CMH','PIT','BNA','PDX','LGA','LHR','CDG','IND','AUS','SDF','BDL','SAT','LGW','OMA','MEM','MDW','MSY','BHM','ABQ','SMF','BUF','PVD','JAX','OAK','MHT','ORF','SJC','OKC','YUL','SNA','HOU','MUC','MKE','ONT','CUN','RSW','TUL','BRU','FCO','MAD','YVR','ELP','BCN','MXP','ZRH','MAN','ALB','RNO','DAL','RIC','MEX','TUS','LIT','JAN','PBI','DUS','DUB','GEG','BOI','BUR','ANC','CHS','ROC','YYC','DAY','LUX','VIE','NRT','SYR','GSO','CPH','SJU','HKG','ICN','AMA','GSP','PRG','IST','MBJ','DXB','ATH','GRR'};

indexes=[];
for i = 1:length(biggernodes)
    GI=biggernodes(i);
    tf=strcmp(GI,air500labels);
    indexes(i)=find(tf);
end
A=air500matrix;
A(indexes,:)=[];
A(:,indexes)=[];% now we have adajeceny matrix that has the hub removed with a threshold of 0.006
A_new=A;

%% global effiency
clc

[ L, EGlob, CClosed, ELocClosed, COpen, ELocOpen, Dist ] = graphProperties( air500matrix );
[ L_new, EGlob_new, CClosed_new, ELocClosed_new, COpen_new, ELocOpen_new, Dist_new ] = graphProperties( A_new );
%% diffusion_efficiency
[GEdiff,Ediff,mfpt] = diffusion_efficiency(air500matrix); % normal network 
A_new(122,:)=[];
A_new(:,122)=[];
[GEdiff_new,Ediff_new,mfpt_new] = diffusion_efficiency(A_new);% network with only top hubs removed

mean(mfpt,"all")
mean(mfpt_new,"all")


%%
%check if data is normally distributed 
histogram(C_hubs,'FaceAlpha',0.7,'EdgeAlpha',0.1);
histfit(C_hubs);
m = mean(C_hubs);
s = std(C_hubs);
xline([m-s],'--','-1 Standard Dev.','LineWidth',2)
xline([m],'-','Mean','LineWidth',2)
xline([m+s],'--','+1 Standard Dev.','LineWidth',2)
xlabel("Q value",'Interpreter','latex','FontSize',15)
% grid on 
% grid minor 
ax1 = gca;                   % gca = get current axis
ax1.YAxis.Visible = 'off';   % remove y-axis

%not normnally distributed!!!


C_hubs_quantile = quantile(C_hubs,[0.25 0.50 0.75])
C_hubs_iqr = iqr(C_hubs)



%% 
xx=air500matrix(:,randperm(size(air500matrix,2)));
G_RANDOM1=digraph(xx,air500labels);
%figure
%plot(G,'EdgeAlpha',0.08,'NodeColor','r')

%degrees
C_outdegree= centrality(G_RANDOM1,"outdegree");

%test the skewness  of the outdregre of the distribution
skewness_out=skewness(C_outdegree);
C_indegree= centrality(G_RANDOM1,"indegree");
skewness_in=skewness(C_indegree);


%Plot of the out degree of the network
subplot(2,2,1)
histogram(C_outdegree,50,"FaceColor","r")
xlabel("Out-Degree",'Interpreter','latex','FontSize',20)
ylabel("Number of nodes",'Interpreter','latex','FontSize',20)



grid on
grid minor

%Plot of the out degree of the network
subplot(2,2,2)
histogram(C_indegree,50,"FaceColor","m")
xlabel("In-Degree",'Interpreter','latex','FontSize',20)
ylabel("Number of nodes",'Interpreter','latex','FontSize',20)


grid on
grid minor
% random
G_RANDOM1=digraph(R,air500labels);
%figure


%degrees

%test the skewness  of the outdregre of the distribution
skewness_out=skewness(C_outdegree_RD);

C_indegree_RD= centrality(G_RANDOM1,"indegree");

%Plot of the out degree of the network
subplot(2,2,3)
histogram(C_outdegree_RD,50,"FaceColor","r")
xlabel("Out-Degree (Random)",'Interpreter','latex','FontSize',20)
ylabel("Number of nodes",'Interpreter','latex','FontSize',20)
%title("Distribution of out-degree of Random network",'Interpreter','latex','FontSize',20)

grid on
grid minor

%Plot of the out degree of the network
subplot(2,2,4)
histogram(C_indegree_RD,50,"FaceColor","m")
xlabel("In Degree (Random)",'Interpreter','latex','FontSize',20)
ylabel("Number of nodes",'Interpreter','latex','FontSize',20)

grid on
grid minor


%% Clustering coefficient calculation .
clust_C  = clustering_coef_bu(air500matrix);

%assiging rankings to elements
[~,idx]=ismember(clust_C,sort(clust_C,'descend'));
%combine the labels and rankings
%sort based on the dimension of the ranks
clust_rank=[array2table(idx) cell2table(air500labels)];
clust_C_rankings=sortrows(clust_rank,1);

%check if data is normally distributed 
histogram(clust_C,'FaceAlpha',0.7,'EdgeAlpha',0.1);
histfit(clust_C);
m = mean(clust_C);
s = std(clust_C);
xline([m-s],'--','-1 Standard Dev.','LineWidth',2)
xline([m],'-','Mean','LineWidth',2)
xline([m+s],'--','+1 Standard Dev.','LineWidth',2)
xlabel("Q value",'Interpreter','latex','FontSize',15)
% grid on 
% grid minor 
ax1 = gca;                   % gca = get current axis
ax1.YAxis.Visible = 'off';   % remove y-axis


clust_C_avg=mean(clust_C);
clust_C_std=std(clust_C);

%%
%pathlength
d = distances(G);
d_avg=mean(d,"all");
d_std=std(d);
d_mean=mean(d_std);
%% invetsigate core perioherey of network

% find the gamma value that gives only  2 groups
% map the 2 groups on a map
% show what happens when you remove the core of the network
% find ways include the nice figures



