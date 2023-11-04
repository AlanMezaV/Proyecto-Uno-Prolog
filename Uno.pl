/*
baraja([[rojo,1], [rojo,2], [rojo,3], [rojo,4], [rojo,5],
        [rojo,6], [rojo,7], [rojo,8], [rojo,9],
        [rojo,1], [rojo,2], [rojo,3], [rojo,4], [rojo,5],
        [rojo,6], [rojo,7], [rojo,8], [rojo,9],
        [verde,1], [verde,2], [verde,3], [verde,4], [verde,5],
        [verde,6], [verde,7], [verde,8], [verde,9],
        [verde,1], [verde,2], [verde,3], [verde,4], [verde,5],
        [verde,6], [verde,7], [verde,8], [verde,9],
        [azul,1], [azul,2], [azul,3], [azul,4], [azul,5],
        [azul,6], [azul,7], [azul,8], [azul,9],
        [azul,1], [azul,2], [azul,3], [azul,4], [azul,5],
        [azul,6], [azul,7], [azul,8], [azul,9],
        [amarillo,1], [amarillo,2], [amarillo,3], [amarillo,4], [amarillo,5],
        [amarillo,6], [amarillo,7], [amarillo,8], [amarillo,9],
        [amarillo,1], [amarillo,2], [amarillo,3], [amarillo,4], [amarillo,5],
        [amarillo,6], [amarillo,7], [amarillo,8], [amarillo,9],
        [rojo, salto], [verde, salto], [azul, salto], [amarillo, salto],
        [rojo, salto], [verde, salto], [azul, salto], [amarillo, salto],
        [cambio, color],[cambio, color],[cambio, color],[cambio, color],
        [rojo, mas2], [verde, mas2], [azul, mas2], [amarillo, mas2],
        [rojo, mas2], [verde, mas2], [azul, mas2], [amarillo, mas2]]).
*/

baraja([[rojo,1], [rojo,1], [amarillo,1], [amarillo,1],[rojo, mas2],[amarillo, mas2],[cambio, color],
         [rojo, salto], [rojo, salto]]).

% Barajar la baraja de cartas
barajar(Barajeada):-
    baraja(Baraja),
    random_permutation(Baraja, Barajeada).

% Repartir cartas a dos jugadores
repartir_cartas(Jugador1, Jugador2, Centro, Mazo):-
    barajar(Barajeada), % Baraja las cartas
    repartir_cartas_aux(1,Barajeada, Jugador1, Jugador2, Centro, Mazo).

% Repartir cartas auxiliar
% Caso base: los dos jugadores no tienen cartas y el contador esta en 0.
repartir_cartas_aux(0, [Carta1|Resto], [], [], Centro, Mazo):-
    Centro = Carta1,
    Mazo = Resto. 
repartir_cartas_aux(N, [Carta1, Carta2 | Resto], [Carta1 | Jugador1Resto], 
                    [Carta2 | Jugador2Resto], Centro, Mazo):-
    N > 0,
    N1 is N-1,
    repartir_cartas_aux(N1, Resto, Jugador1Resto, Jugador2Resto, 
                        Centro, Mazo).

% Regla para agregar una carta a la mano del jugador
agregar_carta(_,[],_,_,_):-
    write('Se terminaron las cartas para agarrar'), nl, 
    write('Si ya no puedes hacer ningun movimiento escribe: paso'),nl, 
    false.

agregar_carta(0, Resto, Jugador, Mazo, Resultado):-
    Mazo = Resto,
    Resultado = Jugador.

agregar_carta(N, [Carta1|Resto], Jugador, Mazo, Resultado):-
    N > 0,
    N1 is N-1,
	append([Carta1], Jugador, JugadorSuma),
    agregar_carta(N1, Resto, JugadorSuma, Mazo, Resultado).

% Regla para ver si se puede jugar esa carta.
puede_jugar(Carta, [Color, Numero]):- 
    Carta = [Color, _] ; Carta = [_, Numero] ;
    [Color, Numero] = [cambio, color].

eliminar_carta(_, [], []).
eliminar_carta(Carta, [Carta|Resto], Resto).
eliminar_carta(Carta, [OtraCarta|Resto], [OtraCarta|NuevaMano]) :-
    Carta \= OtraCarta,
    eliminar_carta(Carta, Resto, NuevaMano).

tiene_carta(Carta, Jugador):-
    (not(member(Carta,Jugador)), Carta \= 'mas', Carta \= 'paso'),    
    write("No tienes esta carta!!"), nl.

mas_carta(Carta, RestoBaraja, Jugador, NuevoMazo, Resultado):-
    Carta == 'mas',
    agregar_carta(1, RestoBaraja, Jugador, NuevoMazo, Resultado),
    write("Se agrego una carta a tu mazo"), nl.

masDos_carta(Carta, Contrincante, ContrincanteNuevoMazo, RestoBaraja, NuevoMazo):-
    Carta = [_, mas2],
    agregar_carta(2, RestoBaraja, Contrincante, NuevoMazo, ContrincanteNuevoMazo),
    write('Se le sumaron dos cartas al contrincante'), nl.
    
salto_carta(Carta, Centro):-
    Carta = [_, salto],
    puede_jugar(Carta, Centro),
    write('Skip jugado'), nl.

cambio_color(Carta, NuevaCarta):-
    Carta = [_, color],
    write('Introduce el color al cual cambiar (ejemplo: rojo): '), nl, read(Nuevocolor),
    NuevaCarta = [Nuevocolor,cambiado].

escoge_turno(N, NuevoTurno):-
    ( N = 2,
     NuevoTurno = 1);
    ( N = 1,
      NuevoTurno = 2).

escoge_turnoRepetido(N, NuevoTurno):-
    ( N = 2,
     NuevoTurno = 2);
    ( N = 1,
      NuevoTurno = 1).

% Predicado para el turno de un jugador
%Caso base de turno para terminar el programa
turno(_,[],[],_,[],_):-
    write('Reiniciando juego'), nl,
    iniciar_juego.

turno(_,_,_,_,_,2):-
    write('Ya no quedan mas movimientos'), nl,
    write('Reiniciando juego'), nl,
    iniciar_juego.

turno(N,_,[],_,_,_):-
    write('Se termino el Juego, gano el jugador '), 
    escoge_turno(N, NuevoTurno),
    write(NuevoTurno), nl,
    turno(NuevoTurno,[],[],_,[],_).

turno(N,[],_,_,_,_):-
    write('Se termino el Juego, gano el jugador '), 
	escoge_turnoRepetido(N, NuevoTurno),
    write(NuevoTurno), nl,
    turno(N,[],[],_,[],_).

turno(N,Jugador, Contrincante, Centro, RestoBaraja, Paso):-
    write("Jugador "), write(N), nl,
    write('Cartas en tu mano: '), write(Jugador), nl,
    write('Carta en la mesa: '), write(Centro),  nl,
   	write('Ingresa la carta a jugar (ejemplo [rojo,1])'), read(Carta), nl,
    (
    (tiene_carta(Carta, Jugador),
    turno(N, Jugador, Contrincante, Centro, RestoBaraja, Paso));
    
    (
    mas_carta(Carta, RestoBaraja, Jugador, NuevoMazo, Resultado),
    turno(N, Resultado, Contrincante, Centro, NuevoMazo, Paso)
    );
    
    (   
    puede_jugar(Carta, Centro),
    masDos_carta(Carta, Contrincante, ContrincanteNuevoMazo, RestoBaraja, NuevoMazo),
    eliminar_carta(Carta, Jugador, JugadorNuevaMano),
    escoge_turno(N, NuevoTurno),
    turno(NuevoTurno, ContrincanteNuevoMazo, JugadorNuevaMano, Carta, NuevoMazo, Paso)
    );
    
    (   
    Carta == 'paso',
    NuevoPaso is Paso + 1,
    escoge_turno(N, NuevoTurno),
    turno(NuevoTurno, Contrincante, Jugador, Centro, RestoBaraja, NuevoPaso)
    );
    
    (
    salto_carta(Carta, Centro),
    eliminar_carta(Carta, Jugador, JugadorNuevaMano),
    turno(N, JugadorNuevaMano, Contrincante, Carta, RestoBaraja, Paso)
    );
    
    (
    cambio_color(Carta, NuevaCarta),
    eliminar_carta(Carta, Jugador, JugadorNuevaMano),
	escoge_turno(N, NuevoTurno),
    turno(NuevoTurno, Contrincante, JugadorNuevaMano, NuevaCarta, RestoBaraja, Paso)
    );
    
    puede_jugar(Carta, Centro);
    
    (
    not(puede_jugar(Carta, Centro)),
    write("Esa carta no se puede poner, pon otra!"), nl,
    turno(N, Jugador, Contrincante, Centro, RestoBaraja, Paso)
    )
    ),
    
    eliminar_carta(Carta, Jugador, JugadorNuevaMano),
    escoge_turno(N, NuevoTurno),
    turno(NuevoTurno, Contrincante, JugadorNuevaMano, Carta, RestoBaraja, 0).

iniciar_juego:-
    repartir_cartas(Jugador1, Jugador2, Centro, Mazo),
    turno(1, Jugador1, Jugador2, Centro, Mazo, 0).