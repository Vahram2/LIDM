function Options = fc_LidmAntsOptions
%--------------------------------------------------------------------------
%Options.Ants:
        %n_ants : number of ants
        %p_eva : pheromone evaporation
        %alfa and beta: are two parameters referred to as pheromone and
        %...heuristic sensitivity parameter.
%--------------------------------------------------------------------------        
%Options.Ants.Tmax_min
%      |->parameters for calculating Tmax &Tmin(max & min pheromone values
%      ....................................................................
%      |->Pdec: is the probability that an ant constructs each component of
%      |...the globalbest solution again
%      |->pbest: the probability that current global-best solution is
%      |...constructed again
%      |->n: is the number of decision points
%      |->k: constant number of options available
%---------------------------------Options.---------------------------------
Options.max_tree = ...
[1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18 ...
19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37;
1	1	1	2	2	2	3	3	4	4	5	5	9	6	7	7	8	8 ...
9	9	11	10	11	16	11	12	12	13	14	14	14	15	16	16	18	18 	20;
2	4	6	3	5	6	5	7	8	9	7	10	6	10	12	13	9	15 ...
11	14	10	12	12	11	18	13	17	17	15	16	19	19	18	19	17	20	19;
760,520,890,1120,610,680,680,870,860,980,890,750,620,800,730,680,480,...
860,800,770,350,620,670,790,1150,750,550,700,500,450,750,720,540,700,...
850,750,970];
Options.node = ...
[1,2,3,4,6,7,8,9,10,11,12,13,14,15,17,18,19,20,5,16;
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,102,96;
 75,74,73,72,73,67,72,70,69,71,70,64,73,73,67,70,70,67,0,0;
 0.165,0.22,0.145,0.165,0.14,0.175,0.18,0.14,0.16,0.17,0.16,...
 0.19,0.2,0.15,0.165,0.14,0.185,0.165,0,0];
Options.nnodes = 20;
Options.tank_id = [5,16];
Options.tank_head= [102,96];
%---------------------------------Options.Ants.----------------------------
Options.Ants.n_ants = 10;
Options.Ants.Iterations = 30;
Options.Ants.p_eva = 0.85;
Options.Ants.alfa = 1;
Options.Ants.beta = 0.25;
%---------------------------------Options.Ants.Tmax_min--------------------
Options.Ants.Tmax_min.pbest = 0.1;
Options.Ants.Tmax_min.n = 37;%number of links
Options.Ants.Tmax_min.k = 4;
Options.Ants.Tmax_min.Q = 10^4;
%**************************************************************************
%LIDM_input
%--------------------------------------------------------------------------
%-> input
Options. LIDM_input. input. vmin_max = [0.2,5];
Options. LIDM_input. input.c_heyzen = 130;
Options. LIDM_input. input.standard_d =...
              [150,200,250,300,350,400,450,500,550,600,650,700,800,900,1000,1100,1200,1300;
               62,71.7,88.9,112.3,138.7,169,207,248,297,347,405,470,2000,3000,4000,5000,6000,7000];
Options. LIDM_input. input.nnodes = [];
Options. LIDM_input. input.nlinks = [];
Options. LIDM_input. input.tank_id = [];
Options. LIDM_input. input.Z0 = [];
Options. LIDM_input. input.node = [];
Options. LIDM_input. input.tree = [];
%**************************************************************************








