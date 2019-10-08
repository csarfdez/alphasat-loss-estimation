%%Script para obtener las estadísticas anuales, a partir de los histogramas
%mensuales
%Autor: César Fernández Muñoz

clear all;

bins=[-5:0.1:60];
hist_anual = zeros(1,length(bins));

disponibilidad_grafica = zeros(1,12);

for i=1:12
    if i<4
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\\UPM_ALP_20150',num2str(i),'_HST.mat');
    elseif i<10 
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\\UPM_ALP_20140',num2str(i),'_HST.mat'); 
    else
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\\UPM_ALP_2014',num2str(i),'_HST.mat');
    end
    
    load(ruta)
                 
    hist_anual = hist_anual + hist_mes;
    
    disponibilidad_grafica(i)=disponibilidad;
    
end

disponibilidad = sum(hist_anual)/(365*1622592);

plot(1:12,disponibilidad_grafica);
title('Disponbilidad');
xlabel('Mes');
ylabel('Atenuacion');
grid

figure

dist=cumsum(hist_anual)/sum(hist_anual);
dist=1-dist;

semilogx(dist*100,bins,'LineWidth',2);
title('Atenuación superada');
xlabel('% de tiempo');
ylabel('Atenuación (dB)');
ylim([-5 40])
xlim([10^(-3) 100])

grid

prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
aten_norm_anio = [];

for i=1:length(prob_norm)
    muestra_sup = find(dist<prob_norm(i));
    muestra_sup = muestra_sup(1);
    muestra_inf = muestra_sup-1;
    if muestra_inf == 0
        muestra_sup = find(dist<0.999999);
        muestra_sup = muestra_sup(1);
        muestra_inf = muestra_sup-1;
        interpolacion = interp1([dist(muestra_inf) dist(muestra_sup)],[bins(muestra_inf) bins(muestra_sup)],0.999999);
    else
        interpolacion = interp1([dist(muestra_inf) dist(muestra_sup)],[bins(muestra_inf) bins(muestra_sup)],prob_norm(i));
    end
    aten_norm_anio(i)=interpolacion;
end

figure

bar(bins,hist_anual);
title('Histograma');
xlabel('Atenuación');
ylabel('Número de muestras');
xlim([-5 40])

grid

figure

semilogx(prob_norm*100,aten_norm_anio,'r','LineWidth',2.5);
title('Porcentaje de tiempo de atenuación superada');
xlabel('% de tiempo');
ylabel('Atenuacion');
xlim([0.001 100])
ylim([-5 40])
grid

uisave({'bins','hist_anual','disponibilidad'},'UPM_ALP_20142015_HST.mat')
