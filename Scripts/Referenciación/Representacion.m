%%Script para representar las señales una vez ya calculadas su referencia
%NOTA: Cargar previamente el fichero mat de atenuación total
%Autor: César Fernández Muñoz


atenuacion = vector_potencia_norm-referencia_exp;

eje_tiempo_1 = linspace(0,24,288); %Calculamos los ejes de tiempos para que indiquen horas
eje_tiempo_2 = linspace(0,24,1622592); %Eje para el caso de representar la potencia real, no media
eje_tiempo_3 = linspace(0,24,90144); 

media_potencia = [];
media_att = [];

frq_muestreo = 1622592/90144;

for i=1:(length(atenuacion)/frq_muestreo)
    if i==1
        media_potencia(i)=mean(vector_potencia_norm(1,1:frq_muestreo*i));
        media_att(i)=mean(atenuacion(1,1:frq_muestreo*i));

    else
        media_potencia(i)=mean(vector_potencia_norm(1,frq_muestreo*(i-1):frq_muestreo*i));
        media_att(i)=mean(atenuacion(1,frq_muestreo*(i-1):frq_muestreo*i));
    end
end

plot(eje_tiempo_3,media_att);
hold on
plot(eje_tiempo_1,att_gases_dia,'r','LineWidth',1.5);
hold off
legend('Atenuación total','Atenuación por gases (GNSS)','Location','southwest')
xlim([0 24]);
title('Atenuación total vs atenuación por gases (GNSS)');
xlabel('Tiempo (horas)')
ylabel('Atenuación (dB)')

set(gca,'XTick',[0:1:24])
grid on

figure

plot(eje_tiempo_3,media_potencia);
hold on
plot(eje_tiempo_2,referencia_exp,'r','LineWidth',2);
xlim([0 24]);
title('Potencia recibida vs Señal de referencia');
xlabel('Tiempo (horas)')
ylabel('Potencia (dBm)')

set(gca,'XTick',[0:1:24])
grid on