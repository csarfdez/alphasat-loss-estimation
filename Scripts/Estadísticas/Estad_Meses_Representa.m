%%Script para representar conjuntamente las estadísticas mensuales, 
%a partir de los histogramas mensuales
%Autor: César Fernández Muñoz


clear all;

for i=4:7
           
    ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_2014','0',num2str(i),'_HST.mat');

    load(ruta)
    
    dist=cumsum(hist_mes)/sum(hist_mes);
    dist=1-dist;
    
    prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
    aten_norm_mes = [];
    
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
        aten_norm_mes(i)=interpolacion;
    end
      
    semilogx(prob_norm*100,aten_norm_mes,'LineWidth',2);
    title('Porcentaje de tiempo de atenuación superada');
    xlabel('% de tiempo');
    ylabel('Atenuacion');
    xlim([0.001 5])
    ylim([-5 40])
    grid
    
    hold all
    
end

legend('Abril 2014','Mayo 2014','Junio 2014','Julio 2014');
grid

figure

for i=8:11
    
    if i>9
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_2014',num2str(i),'_HST.mat');
    else
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_2014','0',num2str(i),'_HST.mat');
    end
        
    load(ruta)
    
    dist=cumsum(hist_mes)/sum(hist_mes);
    dist=1-dist;
    
    prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
    aten_norm_mes = [];
    
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
        aten_norm_mes(i)=interpolacion;
    end
      
    semilogx(prob_norm*100,aten_norm_mes,'LineWidth',2);
    title('Porcentaje de tiempo de atenuación superada');
    xlabel('% de tiempo');
    ylabel('Atenuacion');
    xlim([0.001 100])
    ylim([-5 40])
    grid
    
    hold all
    
end

legend('Agosto 2014','Septiembre 2014','Octubre 2014','Noviembre 2014');
grid

figure

load('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_201412_HST.mat')
    
dist=cumsum(hist_mes)/sum(hist_mes);
dist=1-dist;

prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
aten_norm_mes = [];

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
    aten_norm_mes(i)=interpolacion;
end

semilogx(prob_norm*100,aten_norm_mes,'LineWidth',2);
title('Porcentaje de tiempo de atenuación superada');
xlabel('% de tiempo');
ylabel('Atenuacion');
xlim([0.001 100])
ylim([-5 40])

hold all

for i=1:3
      
    ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_2015','0',num2str(i),'_HST.mat');

    load(ruta)
    
    dist=cumsum(hist_mes)/sum(hist_mes);
    dist=1-dist;
    
    prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
    aten_norm_mes = [];
    
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
        aten_norm_mes(i)=interpolacion;
    end
      
    semilogx(prob_norm*100,aten_norm_mes,'LineWidth',2);
    title('Porcentaje de tiempo de atenuación superada');
    xlabel('% de tiempo');
    ylabel('Atenuacion');
    xlim([0.001 100])
    ylim([-5 40])
    hold all
    
end

legend('Diciembre 2014','Enero 2015','Febrero 2015','Marzo 2015');
grid