%%Script para obtener las estadísticas trimestrales, a partir de los histogramas
%mensuales
%NOTA: Para calcular los distintos trimestres ha de modificarse el código
%Autor: César Fernández Muñoz


clear all;

bins=[-5:0.1:60];
hist_trimes = zeros(1,length(bins));

ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_201503_HST.mat');

load(ruta)

hist_trimes = hist_trimes + hist_mes;
    
for i=4:5

    ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\\UPM_ALP_2014','0',num2str(i),'_HST.mat');
    
    load(ruta)
                 
    hist_trimes = hist_trimes + hist_mes;
           
end

disponibilidad = sum(hist_trimes)/(31*2*1622592+30*1622592);

figure

dist=cumsum(hist_trimes)/sum(hist_trimes);
dist=1-dist;

semilogx(dist,bins,'LineWidth',2);
title('Función de distribución complementaria P(X>x)');
xlabel('Probabilidad');
ylabel('Atenuación');
ylim([-5 40])

grid

prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
aten_norm_trimes = [];

for i=1:length(prob_norm)
    muestra_sup = find(dist<prob_norm(i));
    muestra_sup = muestra_sup(1);
    muestra_inf = muestra_sup-1;
    if muestra_inf == 0
        muestra_sup = find(dist<0.99);
        muestra_sup = muestra_sup(1);
        muestra_inf = muestra_sup-1;
        interpolacion = interp1([dist(muestra_inf) dist(muestra_sup)],[bins(muestra_inf) bins(muestra_sup)],0.99);
    else
        interpolacion = interp1([dist(muestra_inf) dist(muestra_sup)],[bins(muestra_inf) bins(muestra_sup)],prob_norm(i));
    end
    aten_norm_trimes(i)=interpolacion;
end

figure

bar(bins,hist_trimes);
title('Histograma');
xlabel('Atenuación');
ylabel('Número de muestras');
xlim([-5 40])

grid

figure

semilogx(prob_norm*100,aten_norm_trimes,'g','LineWidth',2);
title('Porcentaje de tiempo de atenuación superada');
xlabel('% de tiempo');
ylabel('Atenuacion');
xlim([0.001 100])
ylim([-5 40])
grid

uisave({'bins','hist_trimes','disponibilidad'},'UPM_ALP_Verano_HST.mat')
