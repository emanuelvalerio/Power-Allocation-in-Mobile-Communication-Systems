% implementation the result of  Lagrange Multiplications aplication in capacity equation ; 

function powerAllo = powerAllocation(tPower,SNR,numberSubChannel)
    powerAllo = (tPower + sum(1./SNR))/numberSubChannel - 1./SNR; 
end
