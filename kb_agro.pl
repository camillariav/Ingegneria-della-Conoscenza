% ==============================================================================
% LIVELLO 1: ONTOLOGIA E TASSONOMIA BOTANICA (Fatti)
% ==============================================================================

% 1. Vite e Cucurbitacee
famiglia_pianta(grapes, vite).
famiglia_pianta(watermelon, cucurbitacea).
famiglia_pianta(muskmelon, cucurbitacea).

suscettibile_oidio(X) :- famiglia_pianta(X, vite).
suscettibile_oidio(X) :- famiglia_pianta(X, cucurbitacea).

% 2. Cereali (Graminacee)
famiglia_pianta(rice, graminacea).
famiglia_pianta(maize, graminacea).

suscettibile_brusone(X) :- famiglia_pianta(X, graminacea).

% 3. Leguminose
famiglia_pianta(chickpea, leguminosa).
famiglia_pianta(kidneybeans, leguminosa).
famiglia_pianta(pigeonpeas, leguminosa).
famiglia_pianta(mothbeans, leguminosa).
famiglia_pianta(mungbean, leguminosa).
famiglia_pianta(blackgram, leguminosa).
famiglia_pianta(lentil, leguminosa).

suscettibile_ascochyta(X) :- famiglia_pianta(X, leguminosa).

% 4. Rubiaceae
famiglia_pianta(coffee, rubiaceae).

suscettibile_ruggine_caffe(X) :- famiglia_pianta(X, rubiaceae).

% 5. Malvaceae
famiglia_pianta(cotton, malvaceae).
famiglia_pianta(jute, malvaceae).

suscettibile_fusarium(X) :- famiglia_pianta(X, malvaceae).

% 6. Rosaceae (Fruttiferi Temperati)
famiglia_pianta(apple, rosaceae).

suscettibile_ticchiolatura(X) :- famiglia_pianta(X, rosaceae).

% 7. Rutaceae (Agrumi)
famiglia_pianta(orange, rutaceae).

suscettibile_malsecco(X) :- famiglia_pianta(X, rutaceae).

% 8. Fruttiferi Eduli Diversi
suscettibile_phytophthora(coconut).
suscettibile_phytophthora(pomegranate).

% 9. Fruttiferi Tropicali
categoria_pianta(papaya, fruttifero_tropicale).
categoria_pianta(mango, fruttifero_tropicale).
categoria_pianta(banana, fruttifero_tropicale).

suscettibile_antracnosi_tropicale(X) :- categoria_pianta(X, fruttifero_tropicale).


% ==============================================================================
% LIVELLO 2: REGOLE INTERMEDIE (Astrazione di Clima e Suolo)
% ==============================================================================
% Spezzare le regole permette di rendere la Knowledge Base modulare. 
% Se il clima cambia, si aggiorna solo questa sezione senza toccare l'inferenza.

% --- Oidio ---
clima_favorevole(Temp, Umidita, Pioggia, 'Oidio') :- 
    Temp >= 20.0, Temp =< 27.0, Umidita > 70.0, Pioggia < 50.0.
suolo_vulnerabile(N, _P, K, _PH, 'Oidio') :- 
    N > 70, K < 50.

% --- Brusone del Riso ---
clima_favorevole(Temp, Umidita, Pioggia, 'Brusone del Riso') :- 
    Temp >= 25.0, Temp =< 30.0, Umidita > 80.0, Pioggia > 100.0.
suolo_vulnerabile(N, _P, K, PH, 'Brusone del Riso') :- 
    N >= 70, K < 45, PH =< 6.5.

% --- Ascochyta / Rabbia del Cece ---
clima_favorevole(Temp, Umidita, Pioggia, 'Ascochyta / Rabbia del Cece') :- 
    Temp >= 15.0, Temp =< 25.0, Umidita > 75.0, Pioggia > 50.0.
suolo_vulnerabile(N, P, _K, PH, 'Ascochyta / Rabbia del Cece') :- 
    (N > 40 ; P < 50), PH =< 6.2.

% --- Ruggine del Caffè ---
clima_favorevole(Temp, Umidita, Pioggia, 'Ruggine del Caffe') :- 
    Temp >= 21.0, Temp =< 25.0, Umidita > 85.0, Pioggia > 100.0.
suolo_vulnerabile(N, _P, K, PH, 'Ruggine del Caffe') :- 
    N > 90, K < 35, PH =< 6.0.

% --- Fusarium ---
clima_favorevole(Temp, Umidita, Pioggia, 'Fusarium') :- 
    Temp >= 27.0, Temp =< 32.0, Umidita > 80.0, Pioggia > 80.0.
suolo_vulnerabile(N, _P, K, PH, 'Fusarium') :- 
    N > 75, K < 30, PH =< 6.2.

% --- Ticchiolatura ---
clima_favorevole(Temp, Umidita, Pioggia, 'Ticchiolatura') :- 
    Temp >= 15.0, Temp =< 22.0, Umidita > 85.0, Pioggia > 50.0.
suolo_vulnerabile(N, _P, _K, PH, 'Ticchiolatura') :- 
    N > 30, PH =< 6.0.

% --- Mal Secco degli Agrumi ---
clima_favorevole(Temp, Umidita, Pioggia, 'Mal Secco degli Agrumi') :- 
    Temp >= 14.0, Temp =< 28.0, Umidita > 85.0, Pioggia > 100.0.
suolo_vulnerabile(N, _P, K, PH, 'Mal Secco degli Agrumi') :- 
    N > 30, K < 15, (PH < 6.0 ; PH > 7.8).

% --- Phytophthora ---
clima_favorevole(Temp, Umidita, Pioggia, 'Phytophthora') :- 
    Temp >= 25.0, Temp =< 30.0, Umidita > 85.0, Pioggia > 120.0.
suolo_vulnerabile(_N, P, _K, PH, 'Phytophthora') :- 
    P < 25, PH =< 6.0.

% --- Antracnosi Tropicale ---
clima_favorevole(Temp, Umidita, Pioggia, 'Antracnosi Tropicale') :- 
    Temp >= 25.0, Temp =< 30.0, Umidita > 85.0, Pioggia > 100.0.
suolo_vulnerabile(N, _P, K, _PH, 'Antracnosi Tropicale') :- 
    N > 60, K < 50.


% ==============================================================================
% LIVELLO 3: INFERENZA FINALE (Unione Logica)
% ==============================================================================
% Il ragionamento deduce il rischio combinando vulnerabilità intrinseca (pianta), 
% fattori scatenanti atmosferici (clima) e fattori predisponenti (suolo).

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Oidio') :-
    suscettibile_oidio(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Oidio'),
    suolo_vulnerabile(N, P, K, PH, 'Oidio').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Brusone del Riso') :-
    suscettibile_brusone(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Brusone del Riso'),
    suolo_vulnerabile(N, P, K, PH, 'Brusone del Riso').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Ascochyta / Rabbia del Cece') :-
    suscettibile_ascochyta(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Ascochyta / Rabbia del Cece'),
    suolo_vulnerabile(N, P, K, PH, 'Ascochyta / Rabbia del Cece').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Ruggine del Caffe') :-
    suscettibile_ruggine_caffe(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Ruggine del Caffe'),
    suolo_vulnerabile(N, P, K, PH, 'Ruggine del Caffe').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Fusarium') :-
    suscettibile_fusarium(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Fusarium'),
    suolo_vulnerabile(N, P, K, PH, 'Fusarium').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Ticchiolatura') :-
    suscettibile_ticchiolatura(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Ticchiolatura'),
    suolo_vulnerabile(N, P, K, PH, 'Ticchiolatura').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Mal Secco degli Agrumi') :-
    suscettibile_malsecco(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Mal Secco degli Agrumi'),
    suolo_vulnerabile(N, P, K, PH, 'Mal Secco degli Agrumi').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Phytophthora') :-
    suscettibile_phytophthora(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Phytophthora'),
    suolo_vulnerabile(N, P, K, PH, 'Phytophthora').

rischio_patogeno(Coltura, Temp, Umidita, Pioggia, N, P, K, PH, 'Antracnosi Tropicale') :-
    suscettibile_antracnosi_tropicale(Coltura),
    clima_favorevole(Temp, Umidita, Pioggia, 'Antracnosi Tropicale'),
    suolo_vulnerabile(N, P, K, PH, 'Antracnosi Tropicale').