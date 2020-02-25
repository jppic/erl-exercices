-module(tennis2).
-export([startpartie/0,
finpartie/0,
startping/0,
startpong/0]).

startpartie() ->
	io:format("Bonjour l'arbitre ! ~n"),
	PongID = spawn(tennis2, startpong, []),
	register(joueurPong, PongID),
	PingID = spawn(tennis2, startping, []),
	register(joueurPing, PingID),
	joueurPing ! {joueurPong, pong}.

finpartie() ->
	joueurPing ! {self(), stop},
	joueurPong ! {self(), stop}.

startping() ->
    receive
					{PongID, pong} ->
					    io:format("Je recois Pong ~n"),
					    timer:sleep(1000),
					    io:format("je renvois Ping ~n"),
					    PongID ! {self(),'ping'},
					    startping();
					{_, stop} ->
					    io:format("Ici Ping, j'arrête de jouer ~n")
    end.


startpong() ->
    receive
					{PingID, ping} ->
				            io:format("Je recois Ping ~n"),
				            timer:sleep(1000),
				            io:format("je renvois Pong ~n"),
				            PingID ! {self(),'pong'},
				            startpong();
					{_, stop} ->
				            io:format("Ici Pong ,j'arrête de jouer ~n")
    end.
