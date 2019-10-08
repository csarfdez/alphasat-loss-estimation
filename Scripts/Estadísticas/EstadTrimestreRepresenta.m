%%Script para representar las estad�sticas trimestrales, a partir de los histogramas
%trimestrales
%Autor: C�sar Fern�ndez Mu�oz


clear all;

bins=[-5:0.1:60];

    
for i=1:4

    switch i
        case 1
            ruta=strcat('C:\Users\C�sar\Desktop\Uni\4�\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_Invierno_HST.mat');
        case 2
            ruta=strcat('C:\Users\C�sar\Desktop\Uni\4�\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_Oto�o_HST.mat');
        case 3
            ruta=strcat('C:\Users\C�sar\Desktop\Uni\4�\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_Verano_HST.mat');            
        case 4
            ruta=strcat('C:\Users\C�sar\Desktop\Uni\4�\Semestre 2\Trabajo Fin de Grado\Medidas\Histogramas\UPM_ALP_Primavera_HST.mat');
    end
        
    load(ruta)
    
    dist=cumsum(hist_trimes)/sum(hist_trimes);
    dist=1-dist;
              
    semilogx(dist*100,bins,'LineWidth',2);
    title('Atenuaci�n superada');
    xlabel('% de tiempo');
    ylabel('Atenuacion (dB)');
    xlim([0.001 100])
    ylim([-5 40])
    grid
    
    hold all
    
end

legend('Invierno','Oto�o','Verano','Primavera');
grid
