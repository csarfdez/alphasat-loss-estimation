%%Script para obtener las estadísticas mensuales, a partir de los ficheros
%diarios de atenuación total
%Autor: César Fernández Muñoz


clear all;

bins=[-5:0.1:60];
hist_mes = zeros(1,length(bins));

prompt = '\n Introducir numero año (aaaa) \n';
anio = upper(input(prompt,'s'));

prompt = '\n Introducir numero mes (mm) \n';
mes = upper(input(prompt,'s'));

for i=1:31
    if i<10
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Atenuacion total\',anio,'_',mes,'\UPM_ALP_',anio,mes,'0',num2str(i),'_ATOT.mat');
    else 
        ruta=strcat('C:\Users\César\Desktop\Uni\4º\Semestre 2\Trabajo Fin de Grado\Medidas\Atenuacion total\',anio,'_',mes,'\UPM_ALP_',anio,mes,num2str(i),'_ATOT.mat'); 
    end
    
    if (strcmp(mes,'04') || strcmp(mes,'06') ||  strcmp(mes,'09') || strcmp(mes,'11')) && i == 31
        dias_mes = 30;
        break
    elseif strcmp(mes,'02') && i==29
        dias_mes = 28;
        break
    end
    
    load(ruta)
    
    atenuacion = referencia_exp-vector_potencia_norm;

    for i=1:length(vector_flag)
        if vector_flag(i) == 1 || vector_flag(i) == 3
            atenuacion(i)=NaN;
        end
    end
       
    hist=histc(atenuacion,bins);
        
    hist_mes = hist_mes + hist;
       
    dias_mes = 31;
    
end

disponibilidad = sum(hist_mes)/(dias_mes*1622592);

figure

dist=cumsum(hist_mes)/sum(hist_mes);
dist=1-dist;

semilogx(dist,bins,'LineWidth',2);
title('Función de distribución complementaria P(X>x)');
xlabel('Probabilidad');
ylabel('Atenuación');
ylim([-5 40])

grid

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

figure

bar(bins,hist_mes);
title('Histograma');
xlabel('Atenuación');
ylabel('Número de muestras');
xlim([-5 40])

grid

figure

semilogx(prob_norm*100,aten_norm_mes,'r','LineWidth',2);
title('Porcentaje de tiempo de atenuación superada');
xlabel('% de tiempo');
ylabel('Atenuacion');
xlim([0.001 100])
ylim([-5 40])
grid

uisave({'anio','mes','bins','hist_mes','disponibilidad'},strcat('UPM_ALP_',anio,mes,'_HS.mat'))
