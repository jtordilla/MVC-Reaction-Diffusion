size = 300;

Ac = zeros(size,size); %A concentration
Ac(:) = 1;
Bc = zeros(size,size); %B concentration

t = 0; %time
dt = 1; %length of time step

smdmap = linspace(-pi,pi,10);
smd1 = 1;
smd2 = 1;
while smd1 < 11
    while smd2 < 11
    smoothP(smd1,smd2) = (sin(smdmap(smd1)+pi/2)+1)*(sin(smdmap(smd2)+pi/2)+1)/4;
    smd2 = smd2 + 1;
    end
    smd2 = 1;
    smd1 = smd1 + 1;
end

%Bc(46:55,46:55) = 1; %peturbance
Bc(146:155,146:155) = smoothP;

Da = 1; %A diffusion rate
Db = .5; %b diffusion rate
f = .0545; %feed rate
k = .062; %kill rate

ratioindex = zeros(size,size,floor(t/dt)); %keeps track of data for visualizing

iteration = 0;

while t < 6000
    iteration = iteration + 1;
    
    NAc = zeros(size,size); %new A concentration
    NAc(:,:) = 1;
    NBc = zeros(size,size); %new B concentration

    idx1 = 2;
    idx2 = 2;

    while idx1 < size
        idx2 = 2;
        while idx2 < size
            %LaplaceA = Ac(idx1-1,idx2)*.25+Ac(idx1+1,idx2)*.25-Ac(idx1,idx2)+Ac(idx1,idx2-1)*.25+Ac(idx1,idx2+1)*.25;
            LaplaceA = -Ac(idx1,idx2)+Ac(idx1-1,idx2)*.2+Ac(idx1+1,idx2)*.2+Ac(idx1,idx2-1)*.2+Ac(idx1,idx2+1)*.2+Ac(idx1-1,idx2+1)*.05+Ac(idx1-1,idx2-1)*.05+Ac(idx1+1,idx2-1)*.05+Ac(idx1+1,idx2+1)*.05;
            NAc(idx1,idx2) = Ac(idx1,idx2)+(Da*LaplaceA-Ac(idx1,idx2)*Bc(idx1,idx2)*Bc(idx1,idx2)+f*(1-Ac(idx1,idx2)))*dt;

            %LaplaceB = Bc(idx1-1,idx2)*.25+Bc(idx1+1,idx2)*.25-Bc(idx1,idx2)+Bc(idx1,idx2-1)*.25+Bc(idx1,idx2+1)*.25;
            LaplaceB = -Bc(idx1,idx2)+Bc(idx1-1,idx2)*.2+Bc(idx1+1,idx2)*.2+Bc(idx1,idx2-1)*.2+Bc(idx1,idx2+1)*.2+Bc(idx1-1,idx2+1)*.05+Bc(idx1-1,idx2-1)*.05+Bc(idx1+1,idx2-1)*.05+Bc(idx1+1,idx2+1)*.05;
            NBc(idx1,idx2) = Bc(idx1,idx2)+(Db*LaplaceB+Ac(idx1,idx2)*Bc(idx1,idx2)*Bc(idx1,idx2)-(k+f)*Bc(idx1,idx2))*dt;
           
            if NAc(idx1,idx2) > 1
                NAc(idx1,idx2) = 1;
            end
            
            if NAc(idx1,idx2) < 0
                NAc(idx1,idx2) = 0;
            end
            
            if NBc(idx1,idx2) > 1
                NBc(idx1,idx2) = 1;
            end
            
            if NBc(idx1,idx2) < 0
                NBc(idx1,idx2) = 0;
            end
            
            idx2 = idx2 + 1;
           
        end
    idx1 = idx1 + 1;
    end
    Ac = NAc;
    Bc = NBc;
    
    ratioindex(:,:,iteration) = Bc./(Ac+Bc);
    
    t = t+dt;
end

figure(1)
surf(Ac)
shading interp
view(2)
figure(2)
surf(Bc)
shading interp
view(2)
figure(3)
surf(ratioindex(:,:,iteration))
shading interp
view(2)