                                  %         DEVELOPMENT BY EMANUEL VALERIO PEREIRA              %

nSubCarrier = 10; % Number of subcarriers 
channel = 10*rand(1,nSubCarrier); % Generating the subcarriers with characteristics randomly
B = 100; % System bandwidth in Hz
f = B/nSubCarrier; % Subcarrier bandwidth in Hz
Pn = 10; % Noise power
Pmax = 200; % Maximum power in Watts
SNR =  calculationSNR(channel,Pn); % Calculating the Signal-To-Noise-Ratio
tic
initPowerAllocation = powerAllocation(Pmax,SNR,nSubCarrier); % Allocating initial powers
while (length(find(initPowerAllocation < 0)) > 0)  % while there's negative power alocated ...
    indxNeg = find(initPowerAllocation < 0);       % store the indice of negative power allocated
    indxPos = find(initPowerAllocation >= 0);      % store the indice of positive or null power allocated
    nPositiveSubChannel = length(indxPos);         % stores the number of positive power allocated
    initPowerAllocation(indxNeg) = 0;              % change the value of negative power to zero.
    newSNR  = SNR(indxPos);                        % takes only the SNRs in which the positive power was allocated
    auxPowerAllocation = powerAllocation(Pmax,newSNR,nPositiveSubChannel); % updates the values of power allocated 
    initPowerAllocation(indxPos) = auxPowerAllocation; % adds to the vector of powers allocated from the current positive index
end
t1 = toc;
powerAllocated = initPowerAllocation';
capacityEachWF = f*(log2(1 + initPowerAllocation.*SNR)); % calculating the Capacity in each subcarrier
capacityWF = sum(capacityEachWF); % Calculating the Total Capacity of the system   
tic
equalPowerAllocation = zeros(1,nSubCarrier); % Divides the power equally on all subcarriers 
for i = 1:nSubCarrier
    equalPowerAllocation(i) = Pmax/nSubCarrier;
end

capacityEachEPA = (f*(log2(1 + equalPowerAllocation.*SNR))); % calculating the Capacity in each subcarrier
capacityEPA = sum(capacityEachEPA); % Calculating the Total Capacity of the system
t2 = toc;

% Definição da função objetivo a ser maximizada
% Definition of target function to be maximized
tic
fun = @(x) -f*sum(log2(1 + (x.*SNR))); % Capacity of system, in this case the variable x represents the power allocated
% Definition of constraintes, and others parameters
Aeq = ones(1, nSubCarrier);
beq = Pmax;
lb = zeros(1, nSubCarrier);
ub = Pmax * ones(1, nSubCarrier);
x0 = (lb+ub) / 2;
opts = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
% fmincon function call
[powerAllocationFmincon CapacityFminconT] = fmincon(fun, x0, [], [], Aeq, beq, lb, ub, [], opts);

CapacityFmincon = (f*(log2(1 + powerAllocationFmincon.*SNR)));% Calculating the capacity with each power allocated in each subcarrier
CapacityFmincon = sum(CapacityFmincon); % The total capacity is equal to the sum each capacity of subcarriers
t3 = toc;
% Plotting the results 

f1 = figure(1);
    clf;
    set(f1,'color',[1 1 1]);
    bar((initPowerAllocation + 1./SNR),1,'b');
    hold on
    bar(1./SNR,1);
    xlabel('Subchannel Indices');
    title('Algoritm Water Filling');
    legend("Potência alocada em cada subPortadora", ...
        "Noise to Carrier Ratio");
f2 = figure(2);
    % Plotagem do resultado
    bar((powerAllocationFmincon + 1./SNR), 1, 'b');
    hold on
    bar(1./SNR, 1);
    xlabel('Subchannel Indices');
    title('Algoritm Water Filling');
    legend("Potência alocada em cada subPortadora", "Noise to Carrier Ratio");

% Displaying the capacity of the three forms tested 
disp(['Capacity of System - Water Filling: ' num2str(capacityWF)]);
disp(['Capacity of System - Equal Power Allocation: ' num2str(capacityEPA)]);
disp(['Capacity of System - fmincon: ' num2str(CapacityFmincon)]);
disp(['Time Processing - Water Filling: ' num2str(t1)]);
disp(['Time Processing - Equal Power Allocation: ' num2str(t2)]);
disp(['Time Processing - fmincon: ' num2str(t3)]);

   
