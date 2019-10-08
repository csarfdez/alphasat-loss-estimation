%%Script para calcular y representar las estadísticas de un día, 
%a partir de su fichero de atenuación total
%Autor: César Fernández Muñoz


bins=[-5:0.1:60];

atenuacion = referencia_exp-vector_potencia_norm;

for i=1:length(vector_flag)
    if vector_flag(i) == 1 || vector_flag(i) == 3
        atenuacion(i)=NaN;
    end
end

hist=histc(atenuacion,bins);
        
figure

dist=cumsum(hist)/sum(hist);
dist=1-dist;

semilogx(dist,bins,'LineWidth',2);
title('Función de distribución complementaria');
xlabel('Probabilidad');
ylabel('Atenuación');
ylim([-5 40])

grid

prob_norm = [0.001 0.002 0.003 0.005 0.01 0.02 0.03 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 30 50 100]/100;
aten_norm = [];

for i=1:length(prob_norm)
    muestra_sup = find(dist<prob_norm(i));
    muestra_sup = muestra_sup(1);
    muestra_inf = muestra_sup-1;
    interpolacion = interp1([dist(muestra_inf) dist(muestra_sup)],[bins(muestra_inf) bins(muestra_sup)],prob_norm(i));
    aten_norm(i)=interpolacion;
end

figure

bar(bins,hist);
title('Histograma');
xlabel('Atenuación');
ylabel('Número de muestras');
xlim([-5 40])
grid

figure

semilogx(prob_norm*100,aten_norm,'g','LineWidth',2);
title('Porcentaje de tiempo de atenuación superada');
xlabel('% de tiempo');
ylabel('Atenuacion');
xlim([0.001 100])
ylim([-5 40])
grid
