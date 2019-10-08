%%Script que calcula la atenuación total diaria dada la atenuación por gases
%%mediante el método de GNSS

%%Autor: César Fernández Muñoz

clear all

load('VILL_ATT_2007_2015_39.mat')

prompt = '\n Seleccione una opción: \n 1) Encadenar varios días consecutivos \n 2) Calcular sólo un día \n';
str = upper(input(prompt,'s'));
n=str2num(str);

switch n
    case 1
        
        primera_vez = 1;

        str = 'S';
        
        while str == 'S'
            
            if str == 'S'
                
                if primera_vez == 1
                    
                    disp('Selecciona el fichero del PRIMER día')
                    uiimport('-file')
                    disp('Sobreescriba y presione una tecla para continuar')
                    pause
                    
                    vector_potencia_total = vector_potencia_norm;
                    vector_flag_total = vector_flag;
                    
                end
                
                muestra_gnss_dia = (tiempo_inicial-time(1))*288+1; %Se obtiene el índice de la primera muestra en el fichero de atenuación que pertenece al primer dia
                att_gases_dias = transpose(att_gases_gnss(muestra_gnss_dia:muestra_gnss_dia+575,1)/sin(34.8495*pi/180));
                dia1 = tiempo_inicial;

                if primera_vez == 1
                    
                    disp('Selecciona el fichero del SEGUNDO día')
                    uiimport('-file')
                    disp('Sobreescriba y presione una tecla para continuar')
                    pause
                    
                    vector_potencia_total = horzcat(vector_potencia_total,vector_potencia_norm);
                    vector_flag_total = horzcat(vector_flag_total,vector_flag);
                    
                else
                    
                    disp('Selecciona el fichero del siguiente día')
                    uiimport('-file')
                    disp('Sobreescriba y presione una tecla para continuar')
                    pause
                    
                    vector_potencia_total = horzcat(vector_potencia_total(1,1622593:end),vector_potencia_norm);
                    vector_flag_total = horzcat(vector_flag_total(1,1622593:end),vector_flag);
                    
                end
                
                dia2 = tiempo_inicial;

                %%Cálculo de la media de la potencia recibida. Deben obtenerse 576 muestras
                %%para poder procesar en conjunto con la atenuación.
                
                if primera_vez == 1
                    
                    media_potencia_recibida_1 = [];
                    media_potencia_recibida_2 = [];
                    
                    for i=0:287 %En total hay 288 arrays de 5634 muestras. De cada array se hará una media, proporcionando así en total 288 muestras
                        
                        memoria = [];
                        
                        if i == 0 %La primera muestra 'media' sólo puede calcularse haciendo media con la 'parte derecha' desde el instante inicial
                            
                            memoria = horzcat(memoria,vector_potencia_total(1,1:2817));
                            media_potencia_recibida_1 = horzcat(media_potencia_recibida_1,mean(memoria)); %Se va llenando el array que contendrá las medias
                            
                        else
                            
                            memoria = horzcat(memoria,vector_potencia_total(1,(5634*i-2816):(5634*i+2817)));
                            media_potencia_recibida_1 = horzcat(media_potencia_recibida_1,mean(memoria));
                            
                        end
                        clear memoria;
                    end
                    
                    for i=288:575 %En total hay 288 arrays de 5634 muestras. De cada array se hará una media, proporcionando así en total 288 muestras
                        
                        memoria = [];
                        
                        if i==575 %Igualmente, la última muestra sólo puede calcularse haciendo media entre todas las muestras a la izquierda desde el final
                            
                            memoria = horzcat(memoria,vector_potencia_total(1,(5634*i+2818):end));
                            media_potencia_recibida_2 = horzcat(media_potencia_recibida_2,mean(memoria));
                            
                        else
                            
                            memoria = horzcat(memoria,vector_potencia_total(1,(5634*i-2816):(5634*i+2817)));
                            media_potencia_recibida_2 = horzcat(media_potencia_recibida_2,mean(memoria));
                            
                        end
                        
                        clear memoria;
                        
                    end
                    
                else
                    
                    media_potencia_recibida_1 = media_potencia_recibida(1,289:576);
                    media_potencia_recibida_2 = [];
                    
                    for i=288:575 %En total hay 288 arrays de 5634 muestras. De cada array se hará una media, proporcionando así en total 288 muestras
                        
                        memoria = [];
                        
                        if i==575 %Igualmente, la última muestra sólo puede calcularse haciendo media entre todas las muestras a la izquierda desde el final
                            
                            memoria = horzcat(memoria,vector_potencia_total(1,(5634*i+2818):end));
                            media_potencia_recibida_2 = horzcat(media_potencia_recibida_2,mean(memoria));
                            
                        else
                            
                            memoria = horzcat(memoria,vector_potencia_total(1,(5634*i-2816):(5634*i+2817)));
                            media_potencia_recibida_2 = horzcat(media_potencia_recibida_2,mean(memoria));
                            
                        end
                        
                        clear memoria;
                        
                    end
                    
                end
                
                media_potencia_recibida=horzcat(media_potencia_recibida_1,media_potencia_recibida_2);
                
                deriv_media = diff(media_potencia_recibida);
                deriv2a_media = diff(deriv_media);
                muestras_dudosas = NaN(1,576);
                
                for i=1:574
                    if (deriv2a_media(i)/2)>0.1
                        muestras_dudosas(i+1)=media_potencia_recibida(i+1);
                    end
                end
                
                eje_tiempo_1 = 0:(48/576):(48-48/576); %Calculamos los ejes de tiempos para que indiquen horas
                eje_tiempo_2 = 0:(48/3245184):(48-48/3245184); %Eje para el caso de representar la potencia real, no media
                
                %Representación de las señales
                
                figure(1)
                plot(eje_tiempo_2,vector_potencia_total);
                hold on
                plot(eje_tiempo_1,media_potencia_recibida,'g','LineWidth',1.5,'Marker','o');
                plot(eje_tiempo_1,muestras_dudosas,'mo','linewidth',2);
                hold off
                xlim([0 48]);
                title('Nivel de potencia');
                xlabel('Tiempo (horas)')
                ylabel('Potencia recibida (dBm)')
                
                
                %Inicio de la interfaz para la selección de tramos
                
                str = 'S';
                prompt = '\n ¿Referenciar algún tramo?: [S/N]';
                
                while str == 'S' %Bucle: el programa pregunta si desea referenciar hasta que se diga alguna vez No, en cuyo caso finaliza.
                    str = upper(input(prompt,'s'));
                    if str == 'S'
                                                                                            
                        zoom on
                        disp('Haga zoom sobre el área a interpolar y presione una tecla');
                        pause
                        
                        disp('Pinchar en el principio y en el final del tramo, en dicho orden');
                        
                        puntos = ginput(2);
                        hold on
                        
                        muestra_inf = round(puntos(1,1)/(24/288)); %Se calculan la muestras más cercanas a lo puntos pinchados por el usuario
                        muestra_sup = round(puntos(2,1)/(24/288));
                        
                        muestras_aux = muestra_inf*24/288:24/288:muestra_sup*24/288;
                        
                        interpolacion = interp1([muestra_inf*24/288 muestra_sup*24/288],[puntos(1,2) puntos(2,2)],muestras_aux);
                        plot(muestras_aux,interpolacion,'m','LineWidth',3);
                        
                        media_potencia_recibida(1,muestra_inf:muestra_sup)=interpolacion;
                        
                    end
                    
                    prompt = '\n ¿Volver a referenciar algún otro tramo?: [S/N]';
                    
                end
                
                %Representación
                
                referencia = media_potencia_recibida + att_gases_dias; %Se obtiene la nueva señal de referencia
                
                referencia_exp = [];
                
                for i=2:577
                    if i==577
                        referencia_exp=horzcat(referencia_exp,linspace(referencia(i-1), referencia(i-1), 5634));
                    else
                        referencia_exp=horzcat(referencia_exp,linspace(referencia(i-1), referencia(i), 5634));
                    end
                end
                
                atenuacion = referencia_exp-vector_potencia_total;
                atenuacion = -atenuacion;
                att_gases_dias = -att_gases_dias;
                
                clf(1)
                
                figure(1)
                
                plot(eje_tiempo_2,atenuacion);
                hold on
                plot(eje_tiempo_1,att_gases_dias,'r','LineWidth',1.5);
                hold off
                legend('Atenuación total','Atenuación por gases (GNSS)','Location','southwest')
                xlim([0 48]);
                title('Atenuación total vs atenuación por gases (GNSS)');
                xlabel('Tiempo (horas)')
                ylabel('Atenuación (dB)')
                
            end
            
            primera_vez = 0;
            
            ref_aux = referencia_exp;
            referencia_exp=referencia_exp(1,1:1622592);
            att_gases_dia=att_gases_dias(1,1:288);
            vector_flag=vector_flag_total(1,1:1622592);
            vector_potencia_norm=vector_potencia_total(1,1:1622592);
            
            disp('Guardar el fichero .mat del primer día añadido');
            
            tiempo_inicial = tiempo_inicial-1;
            
            uisave({'referencia_exp','att_gases_dia','tiempo_inicial','vector_flag','vector_potencia_norm'},datestr(tiempo_inicial,'yyyymmdd'))
            
            tiempo_inicial = tiempo_inicial+1;

            prompt = '\n ¿Desea encadenar otro día más?: [S/N]';
            
            str = upper(input(prompt,'s'));
            
        end
        
        referencia_exp=ref_aux(1,1622593:end);
        att_gases_dia=att_gases_dias(1,289:end);
        vector_flag=vector_flag_total(1,1622593:end);
        vector_potencia_norm=vector_potencia_total(1,1622593:end);
                       
        disp('Guardar el fichero .mat del último día añadido');
        
        uisave({'referencia_exp','att_gases_dia','tiempo_inicial','vector_flag','vector_potencia_norm'},datestr(tiempo_inicial,'yyyymmdd'))
        
    case 2

        disp('Selecciona el fichero del día')
        uiimport('-file')
        disp('Sobreescriba y presione una tecla para continuar')
        pause
        
        muestra_gnss_dia = (tiempo_inicial-time(1))*288+1; %Se obtiene el índice de la primera muestra en el fichero de atenuación que pertenece al día concreto
        
        att_gases_dia = transpose(att_gases_gnss(muestra_gnss_dia:muestra_gnss_dia+287,1)/sin(34.8495*pi/180));
        
        %%Cálculo de la media de la potencia recibida. Deben obtenerse 288 muestras
        %%para poder procesar en conjunto con la atenuación.
        
        %%Para cada muestra media obtenida, se ha calculado la media de las muestras de la
        %%potencia recibida en una ventana que contiene 5634 muestras, excepto para
        %%la primera y para la última ventana, al no existir muestras antes ni
        %%después de la señal. El valor de 5634 procede de dividir el número total
        %%de muestras, 1622592, entre 288, el número de muestras totales para la
        %%señal de atenuación por gases.
        
        media_potencia_recibida = [];
        
        for i=0:287 %En total hay 288 arrays de 5634 muestras. De cada array se hará una media, proporcionando así en total 288 muestras
            
            memoria = [];
            
            if i == 0 %La primera muestra 'media' sólo puede calcularse haciendo media con la 'parte derecha' desde el instante inicial
                
                memoria = horzcat(memoria,vector_potencia_norm(1,1:2817));
                media_potencia_recibida = horzcat(media_potencia_recibida,mean(memoria)); %Se va llenando el array que contendrá las medias
                
            elseif i==287 %Igualmente, la última muestra sólo puede calcularse haciendo media entre todas las muestras a la izquierda desde el final
                
                memoria = horzcat(memoria,vector_potencia_norm(1,(5634*i+2818):end));
                media_potencia_recibida = horzcat(media_potencia_recibida,mean(memoria));
                
            else
                
                memoria = horzcat(memoria,vector_potencia_norm(1,(5634*i-2816):(5634*i+2817)));
                media_potencia_recibida = horzcat(media_potencia_recibida,mean(memoria));
                
            end
            clear memoria;
        end
        
        deriv_media = diff(media_potencia_recibida);
        deriv2a_media = diff(deriv_media);
        muestras_dudosas = NaN(1,288);
        
        for i=1:286
            if (deriv2a_media(i)/2)>0.1
                muestras_dudosas(i+1)=media_potencia_recibida(i+1);
            end
        end
        
        clear i;
        
        eje_tiempo_1 = 0:(24/288):(24-24/288); %Calculamos los ejes de tiempos para que indiquen horas
        eje_tiempo_2 = 0:(24/1622592):(24-24/1622592); %Eje para el caso de representar la potencia real, no media
        
        %Representación de las señales
        
        figure(1)
        plot(eje_tiempo_2,vector_potencia_norm);
        hold on
        plot(eje_tiempo_1,media_potencia_recibida,'g','LineWidth',1.5,'Marker','o');
        plot(eje_tiempo_1,muestras_dudosas,'mo','linewidth',2);
        xlim([0 24]);
        title('Nivel de potencia');
        xlabel('Tiempo (horas)')
        ylabel('Potencia recibida (dBm)')
        

        %Inicio de la interfaz para la selección de tramos
        
        str = 'S';
        prompt = '\n ¿Referenciar algún tramo?: [S/N]';
        
        while str == 'S' %Bucle: el programa pregunta si desea referenciar hasta que se diga alguna vez No, en cuyo caso finaliza.
            str = upper(input(prompt,'s'));
            if str == 'S'
                                              
                zoom on
                disp('Haga zoom sobre el área a interpolar y presione una tecla');
                pause
                
                disp('Pinchar en el principio y en el final del tramo, en dicho orden');
                
                puntos = ginput(2);
                hold on
                
                muestra_inf = round(puntos(1,1)/(24/288)); %Se calculan la muestras más cercanas a lo puntos pinchados por el usuario
                muestra_sup = round(puntos(2,1)/(24/288));
                
                muestras_aux = muestra_inf*24/288:24/288:muestra_sup*24/288;
                
                interpolacion = interp1([muestra_inf*24/288 muestra_sup*24/288],[puntos(1,2) puntos(2,2)],muestras_aux);
                plot(muestras_aux,interpolacion,'m','LineWidth',3);
                
                if muestra_inf == 0
                    media_potencia_recibida(1,1:muestra_sup+1)=interpolacion;
                else
                    media_potencia_recibida(1,muestra_inf:muestra_sup)=interpolacion;
                end
                
            end
            
            prompt = '\n ¿Volver a referenciar algún otro tramo?: [S/N]';
        end
        
        %Representación
        
        referencia = media_potencia_recibida + att_gases_dia; %Se obtiene la nueva señal de referencia
        
        referencia_exp = [];
        
        for i=2:289
            if i==289
                referencia_exp=horzcat(referencia_exp,linspace(referencia(i-1), referencia(i-1), 5634));
            else
                referencia_exp=horzcat(referencia_exp,linspace(referencia(i-1), referencia(i), 5634));
            end
        end
        
        atenuacion = referencia_exp-vector_potencia_norm;
        atenuacion = -atenuacion;
        att_gases_dia = -att_gases_dia;
        
        clf(1)
        
        figure(1)
        
        plot(eje_tiempo_2,atenuacion);
        hold on
        plot(eje_tiempo_1,att_gases_dia,'r','LineWidth',1.5);
        hold off
        legend('Atenuación total','Atenuación por gases (GNSS)','Location','southwest')
        xlim([0 24]);
        title('Atenuación total vs atenuación por gases (GNSS)');
        xlabel('Tiempo (horas)')
        ylabel('Atenuación (dB)')
        
        uisave({'referencia_exp','att_gases_dia','tiempo_inicial','vector_flag','vector_potencia_norm'},datestr(tiempo_inicial,'yyyymmdd'))

    otherwise
        disp('Opción incorrecta');
end