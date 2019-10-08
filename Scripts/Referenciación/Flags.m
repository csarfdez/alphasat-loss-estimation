%%Script que permite referenciar tramos no v�lidos de atenuaci�n.

%%Autor: C�sar Fern�ndez Mu�oz

eje_tiempo_2 = 0:(24/1622592):(24-24/1622592); %Eje para el caso de representar la potencia real, no media

atenuacion = vector_potencia_norm-referencia_exp;

subplot(2,1,1)
plot(eje_tiempo_2,atenuacion);
xlim([0 24]);
title('Atenuaci�n total');
xlabel('Tiempo (horas)')
ylabel('Atenuaci�n (dB)')

set(gca,'XTick',[0:1:24])
grid on

subplot(2,1,2)
plot(eje_tiempo_2,vector_flag,'ro');
xlabel('Tiempo (horas)')
xlim([0 24]);
title('Flags de validaci�n');

set(gca,'XTick',[0:1:24])
grid on

str = 'S';

while str == 'S' 
    
    prompt = '\n Seleccione una opci�n: \n 1) Marcar tramos inv�lidos \n 2) Marcar tramos v�lidos \n';
    str = upper(input(prompt,'s'));
    n=str2num(str);
    
    zoom on
    disp('Haga zoom sobre el �rea de inter�s y presione una tecla');
    pause
    
    disp('Pinchar en el principio y en el final del tramo, en dicho orden');

    puntos = ginput(2);
    hold on

    muestra_inf = round(puntos(1,1)/(24/1622592)); %Se calculan la muestras m�s cercanas a lo puntos pinchados por el usuario
    muestra_sup = round(puntos(2,1)/(24/1622592));

    switch n
        case 1
            if muestra_sup > 1622592
                vector_flag(1,muestra_inf:end) = 1;
            elseif muestra_inf <= 0
                vector_flag(1,1:muestra_sup) = 1;
            else
                vector_flag(1,muestra_inf:muestra_sup) = 1;
            end
        case 2
            vector_flag(1,muestra_inf:muestra_sup) = 0;
    end
    
    subplot(2,1,2)
    plot(eje_tiempo_2,vector_flag,'ro');
    xlabel('Tiempo (horas)')
    xlim([0 24]);
    title('Flags de validaci�n');

    prompt = '\n �Volver a marcar alg�n otro tramo?: [S/N]';
    str = upper(input(prompt,'s'));
    
end

uisave({'referencia_exp','att_gases_dia','tiempo_inicial','vector_flag','vector_potencia_norm'},datestr(tiempo_inicial,'yyyymmdd'))
