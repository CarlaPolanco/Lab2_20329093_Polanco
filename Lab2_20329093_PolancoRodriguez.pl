/* ------------------------------- TDAs --------------------------------------------
 * TDAUsuarioA=[Nombre,contraseña]
 *TDAUsuarios=[ID,Fecha,nombre,Contraseña,[Seguidores],[PublicacionesMias],[PCompartidasConmigo]]
 *TDAPublicacion=[ID,Date,Autor,Tipo,Contenido,[VecesCompartido]]
 *TDAlistaUsuarios=[[username1,pass1],[usernarme2,pass2],...,[usernameN,passN]]
 *TDAlistaPublicacion=[[TDAPublicacion1],[TDAPublicacion2],...,[TDAPublicaionN]]
 *TDASOCIALNETWORK=[Nombre,Date,[TDAUsuarioA],[TDAlistaUsuarios],[TDAlistaPublicacion]],SOut]
 *PCompartidasConmigo=[[TDAPublicacion1],[TDAPublicacion2],...,[TDAPublicacionN]]
 *Date=[dd,mm,aaaa]
 */
/*-------------------------------- DOMINIOS ------------------------------------- */

/*
 * Nombre/username = Nombre asignado para los usuarios
 * Contraseña/Pass = Contraseña de los usuarios
 * ID = identificador de cada usuario o publicacion
 * Autor = Nombre del creador de la publicacion
 * Seguidores = Otros usuarios que sigue la cuenta
 * QuienMesigue = Otros usuarios que siguen la cuenta
 * Tipo = Tipo de publicacion, estas pueden ser; url,video,text,audio,etc
 * Contenido = Lo que contendra la publicacion
 * Date = Fecha en que se creara la red social o la publicacion posee un
 *     formato de tipo; [dd,mm,aaaa], donde dd=dia, mm=mes, aaaa=año,
 *     con un año maximo 2021, mes varia entre 1 y 11 y dia entre 1 y 30
 */

% CONSTRUCTOR SOCIALNETWORK

socialnetwork(Nombre,[DD,MM,AAAA],Sout):-
    string(Nombre),
    integer(DD),DD>0,DD<31,
    integer(MM),MM<13,MM>0,
    integer(AAAA),AAAA<2022,AAAA>0,
    Sout=[Nombre,[DD,MM,AAAA],[],[],[]].


% PERTENENCIA SOCIALNETWORK

% isSocialNetwork(Nombre,[DD,MM,AAAA],UsuarioActivo,Usuarios,Publicaciones):-
    %string(Nombre),
    %isDate(DD,MM,AAAA),
    %isUsuarioActivo(UsuarioActivo).

isDate(DD,MM,AAAA):-
    integer(DD),
    integer(MM),
    integer(AAAA).

isUsuarioActivo([Cabeza|Cola]):-
    string(Cabeza),
    string(Cola).

% SELECTOR SOCIALNETWORK

selectorNombre([Nombre,_,_,_,_],NombreSn):-
    NombreSn = Nombre.

selectorFecha([_,Fecha,_,_,_],FechaSn):-
    FechaSn = Fecha.

selectorUActivo([_,_,UA,_,_],UASn):-
    UASn = UA.

selectorUsuarios([_,_,_,Usuarios,_],USn):-
    USn = Usuarios.

selectorPublicaciones([_,_,_,_,Publicaciones],PSn):-
    PSn = Publicaciones.

%---------------------------------------------------------------------

% CONSTRUCTOR PUBLICACIONES

publicaciones(ID,[DD,MM,AAAA],Autor,Tipo,Contenido,OutP):-
    integer(ID),
    isDate(DD,MM,AAAA),
    string(Autor),
    string(Tipo),
    string(Contenido),
    OutP = [ID,[DD,MM,AAAA],Autor,Tipo,Contenido,[]].


%--------------------------------------------------------------------

% CONSTRUCTOR USUARIO

usuario(ID,[DD,MM,AAAA],Nombre,Contraseña,OutU):-
    integer(ID),
    string(Nombre),
    string(Contraseña),
    isDate(DD,MM,AAAA),
    OutU = [ID,[DD,MM,AAAA],Nombre,Contraseña,[],[],[]].

% ----------------------------------------------------------------------

% CONSTRUCTOR USUARIO ACTIVO

usuarioActivo(Nombre,Contraseña,OutU):-
    string(Nombre),
    string(Contraseña),
    OutU = [Nombre,Contraseña].

% SELECTOR USUARIO ACTIVO

selectorNombreUA([U|_],Nombre):-
    string(U),
    Nombre = U.


% ----------------------------------------------------------------------


    % ------------------------------ Funciones extras ----------------------

/*
 * Dominio: Lista X integer
 * Meta Principal: Calcular el largo de una lista
 * Recursion: natural
 */

tamanoLista([],0).
tamanoLista([_|COLA],NUMERO) :- tamanoLista(COLA,M), NUMERO is M+1.

/*
 * Dominio: lista usuario x string x string
 * Meta principal: verificar si existe el usuario registrado
 * Recursion: cola
*/
existeUsuario([[_,_,Nombre,Contraseña,_,_,_]|_],Nombre,Contraseña):-!.
existeUsuario([_|C],Nombre,Contraseña):- existeUsuario(C,Nombre,Contraseña).

/*
 * Dominio: listaUsuarios x integer x listaSalida
 * Meta principal: Agrega el id de la publicacion creada al usuario
 * Recursion: cola
*/
/*
usuarioEditado([],_,_):-!.
usuarioEditado([ID,[DD,MM,AAAA],Nombre,Contraseña,Seguidores,QuienSigue,PCConmigo|Cola],IDP,UsuarioE):-
    ID=IDP,
    append(PCConmigo,[ID],PCConmigoF),
    UsuarioE =[ID,[DD,MM,AAAA],Nombre,Contraseña,Seguidores,QuienSigue,PCConmigoF),
    usuarioEditado(Cola,IDP,UsuarioE).
*/

% ------------------------------ BLOQUE PRIINCIPAL ---------------------

% REGISTER
%Comprobar socialnetwork

socialNetworkRegister(Sn,[DD,MM,AAAA],Username,Password,OutSn):-
    isDate(DD,MM,AAAA),
    string(Username),
    string(Password),
    selectorNombre(Sn,Nombre),
    selectorUActivo(Sn,Activo),
    selectorUsuarios(Sn,UsuariosI),
    not(existeUsuario(UsuariosI,Username,Password)),
    selectorFecha(Sn,Fecha),
    tamanoLista(UsuariosI,ID),IDF is ID+1,
    usuario(IDF,[DD,MM,AAAA],Username,Password,Usuario),
    append(UsuariosI,[Usuario],Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    OutSn = [Nombre,Fecha,Activo,Usuarios,Publicaciones], !.

% LOGIN
%Comprobar socialnetwork

socialNetworkLogin(Sn,Username,Password,OutSn):-
    string(Username),
    string(Password),
    selectorUsuarios(Sn,Usuarios),
    existeUsuario(Usuarios,Username,Password),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    LusuarioA == [],
    usuarioActivo(Username,Password,Activo),
    selectorPublicaciones(Sn,Publicaciones),
    OutSn = [Nombre,Fecha,Activo,Usuarios,Publicaciones], !.

% POST
% post para añadir el post a mismo usuario activo

socialNetworkPost(Sn,[DD,MM,AAAA],Texto,[],OutSn):-
    isDate(DD,MM,AAAA),
    string(Texto),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    not(LusuarioA == []),
    selectorUsuarios(Sn,Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    tamanoLista(Publicaciones,ID),IDF is ID+1,
    selectorNombreUA(LusuarioA,Autor),
    publicaciones(IDF,[DD,MM,AAAA],Autor,"Texto",Texto,PublicacionF),
    append(Publicaciones,[PublicacionF],PublicacionesFF),
    encontrarUsuario(Usuarios,Autor,UsuarioF),
    editarUsuarioID(UsuarioF,IDF,UsuarioFF),
    cambiar(UsuarioF,UsuarioFF,Usuarios,UsuariosFFF),
    OutSn=[Nombre,Fecha,[],UsuariosFFF,PublicacionesFF], !.

socialNetworkPost(Sn,[DD,MM,AAAA],Texto,DeseoSeguir,OutSn):-
    isDate(DD,MM,AAAA),
    string(Texto),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    not(LusuarioA == []),
    selectorUsuarios(Sn,Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    tamanoLista(Publicaciones,ID),IDF is ID+1,
    selectorNombreUA(LusuarioA,Autor),
    publicaciones(IDF,[DD,MM,AAAA],Autor,"Texto",Texto,PublicacionF),
    append(Publicaciones,[PublicacionF],PublicacionesFF),
    agregarIDPost(Usuarios,DeseoSeguir,IDF,UsuariosFFF),
    OutSn=[Nombre,Fecha,[],UsuariosFFF,PublicacionesFF], !.

agregarIDPost(UsuariosFFF,[],_,Salida):-
    Salida=UsuariosFFF,
    !,true.
agregarIDPost(Usuarios,[Cabeza|Cola],IDF,Salida):-
    encontrarUsuario(Usuarios,Cabeza,UsuarioF),
    editarUsuarioID(UsuarioF,IDF,UsuarioFF),
    cambiar(UsuarioF,UsuarioFF,Usuarios,UsuariosFFF),
    agregarIDPost(UsuariosFFF,Cola,IDF,Salida).



% Follow

socialNetworkFollow(Sn,Username,OutSn):-
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    selectorNombreUA(LusuarioA,NombreA),
    selectorUsuarios(Sn,Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    encontrarUsuario(Usuarios,Username,UsuarioF),
    editarUsuario(UsuarioF,NombreA,NE),
    cambiar(UsuarioF,NE,Usuarios,UsuariosFF),
    Username\= NombreA,
    OutSn = [Nombre,Fecha,[],UsuariosFF,Publicaciones], !.

cambiar(E,NE,[E],[NE]):-!.
cambiar(E,NE,[E|Es],[NE|Es]):-!.
cambiar(E,NE,[Q|Es],[Q|NEs]):-cambiar(E,NE,Es,NEs).

encontrarUsuario([[ID,Fecha,Username,Pass,List,List1,List2]|_],Username,[ID,Fecha,Username,Pass,List,List1,List2]):-!.
encontrarUsuario([_|C],Username,Usuario):-encontrarUsuario(C,Username,Usuario).

editarUsuario([ID,Fecha,Nombre,Contraseña,Seguidores,QM,PCC],Username,Salida):-
    append(Seguidores,[Username],SeguidoresF),
    Salida = [ID,Fecha,Nombre,Contraseña,SeguidoresF,QM,PCC].

editarUsuarioID([ID,Fecha,Nombre,Contraseña,Seguidores,QM,PCC],IDF,UsuarioFF):-
    append(PCC,[IDF],PCCF),
    UsuarioFF = [ID,Fecha,Nombre,Contraseña,Seguidores,QM,PCCF].

% SHARE


editarUsuarioIDShare([ID,Fecha,Nombre,Contraseña,Seguidores,QM,PCC],IDF,UsuarioFF):-
    append(QM,[IDF],QMF),
    UsuarioFF = [ID,Fecha,Nombre,Contraseña,Seguidores,QMF,PCC].

editarPublicacion([ID,Date,Autor,Tipo,Contenido,Compartida],List,PublicacionEdit):-
    append(Compartida,[List],Compartida2),
    PublicacionEdit = [ID,Date,Autor,Tipo,Contenido,Compartida2].

encontrarPublicacion([[ID,Date,Autor,Tipo,Contenido,Compartida]|_],ID,[ID,Date,Autor,Tipo,Contenido,Compartida]):-!.
encontrarPublicacion([_|C],ID,Usuario):-encontrarPublicacion(C,ID,Usuario).

socialNetworkShare(Sn,[DD,MM,AAAA],PostId,[],OutSn):-
    isDate(DD,MM,AAAA),
    not(LusuarioA == []),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    selectorNombreUA(LusuarioA,NombreA),
    selectorUsuarios(Sn,Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    encontrarUsuario(Usuarios,NombreA,UsuarioF),
    editarUsuarioIDShare(UsuarioF,PostId,NE),
    cambiar(UsuarioF,NE,Usuarios,UsuariosFF),
    DateShare = [[DD,MM,AAAA],NombreA],
    encontrarPublicacion(Publicaciones,PostId,Publicacion),
    editarPublicacion(Publicacion,DateShare,PublicacionEdit),
    cambiar(Publicacion,PublicacionEdit,Publicaciones,PublicacionesF),
    OutSn = [Nombre,Fecha,[],UsuariosFF,PublicacionesF], !.

socialNetworkShare(Sn,[DD,MM,AAAA],PostId,Acompartir,OutSn):-
    isDate(DD,MM,AAAA),
    not(LusuarioA == []),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    selectorUsuarios(Sn,Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    agregarIDShare(Usuarios,Acompartir,PostId,UsuariosFF),
    DateShare = [[DD,MM,AAAA],Acompartir],
    encontrarPublicacion(Publicaciones,PostId,Publicacion),
    editarPublicacion(Publicacion,DateShare,PublicacionEdit),
    cambiar(Publicacion,PublicacionEdit,Publicaciones,PublicacionesF),
    OutSn = [Nombre,Fecha,[],UsuariosFF,PublicacionesF], !.


agregarIDShare(UsuariosFFF,[],_,Salida):-
    Salida=UsuariosFFF,
    !,true.
agregarIDShare(Usuarios,[Cabeza|Cola],PostId,Salida):-
    encontrarUsuario(Usuarios,Cabeza,UsuarioF),
    editarUsuarioIDShare(UsuarioF,PostId,NE),
    cambiar(UsuarioF,NE,Usuarios,UsuariosF),
    agregarIDShare(UsuariosF,Cola,PostId,Salida).

% -------------------------------- TO STRING ---------------------------

socialNetworkToString(Sn,SnOut):-
    selectorUActivo(Sn,Activo),
    socialNetworkString(Sn,Activo,SnOut), !.



socialNetworkString([Nombre,Fecha,_,ListaU,ListaP],[],Snout):-
    string_concat(" \n        ******** RED SOCIAL: ",Nombre,A),
    string_concat(A," *******",W),
    string_concat(W,"\n",B),
    date(Fecha,C),
    string_concat("        FECHA DE CREACION: ",C,D),
    string_concat(D,"\n",E),
    string_concat(B,E,F),
    string_concat(F,"\n        ******************************************************************** USUARIOS REGISTRADOS ********************************************************************  \n",Q),
    listaUsuarioString(ListaU,"",G),
    string_concat(Q,G,H),
    string_concat(H,"\n        ************************************************************************* PUBLICACIONES *************************************************************************  \n",S),
    listaPublicacionesString(ListaP," ",I),
    string_concat(S,I,Snout).

socialNetworkString([Nombre,Fecha,_,ListaU,ListaP],Ua,Snout):-
    string_concat(" \n        ******** RED SOCIAL: ",Nombre,A),
    string_concat(A," ******* \n",B),
    date(Fecha,C),
    string_concat("        FECHA DE CREACION: ",C,D),
    string_concat(D,"\n",E),
    string_concat(B,E,F),
    usuarioActivoToString(Ua,J),
    string_concat("        USUARIO ACTIVO: ",J,K),
    string_concat(F,K,M),
    listaUsuarioString(ListaU," ",G),
    string_concat(M,G,H),
    listaPublicacionesString(ListaP," ",I),
    string_concat(H,I,Snout).



 /*
 * Dominio: lista de usuarios x string
 * Meta principal: tranformar la lista de usuarios en un string
 * Recursion: Natural.
*/

listaUsuarioString([],Aux, String):- String = Aux, !.
listaUsuarioString([H|T],Aux, String):-
    usuarioString(H,S1),
    string_concat(Aux,S1,S2),
    listaUsuarioString(T,S2,String).

/*
 * Dominio: Usuarios x String
 * Meta principal: tranformar un usuario en un string
 * Recursion:-.
*/

usuarioString([ID,[DD,MM,AAAA],Nombre,Contraseña,Seguidores,PublicacionesMias,PublicacionesCompartidas],String):-
    number_string(ID,A),
    string_concat("        ID: ",A,Q),
    date([DD,MM,AAAA],C),
    string_concat("FECHA DE REGISTRO: ",C,W),
    string_concat(Q," ",B),
    string_concat(B, W, D),
    string_concat(D," ",E),
    string_concat(E,"USERNAME: ", R),
    string_concat(R,Nombre,F),
    string_concat(F," PASSWORD: ", O),
    string_concat(O,Contraseña,G),
    publicacionesListaSeguidoresE(Seguidores,"ID: ",H),
    string_concat(" SEGUIDORES: ",H,P),
    string_concat(G,P,I),
    publicacionesListaE(PublicacionesMias,"ID: ",J),
    string_concat(" PUBLICACIONES MIAS: " ,J,S),
    string_concat(I,S,K),
    publicacionesListaE(PublicacionesCompartidas,"ID: ",L),
    string_concat("     PUBLICACIONES COMPARTIDAS CONMIGO: ",L,T),
    string_concat(K,T,M),
    string_concat(M,"\n",String).

 /*
 * Dominio: lista de ID x string
 * Meta principal: tranformar la lista de ID de las publicaciones enString
 * Recursion: Natural.
*/

publicacionesListaE([],Aux,String):-String = Aux,!.
publicacionesListaE([H|T],Aux,String):-
    publicacionesListas(H,S1),
    string_concat(Aux,S1,S2),
    publicacionesListaE(T,S2,String).

/*
 * Dominio: ID x String
 * Meta principal: tranformar un ID en un string
 * Recursion:-.
*/

publicacionesListas(ID,String):-
     number_string(ID,A),
     string_concat(A," ",String).

/*
 * Dominio: lista de seguidores x string
 * Meta principal: tranformar la lista de seguidores de la
 *                 publicaciones en String
 * Recursion: Natural.
*/

publicacionesListaSeguidoresE([],Aux,String):-String = Aux,!.
publicacionesListaSeguidoresE([H|T],Aux,String):-
    publicacionesListasS(H,S1),
    string_concat("ID: ",Aux,Aux2),
    string_concat(Aux2, S1,S2),
    publicacionesListaSeguidoresE(T,S2,String).

/*
 * Dominio: User x String
 * Meta principal: concadena todos los usuarios en un solo string
 * Recursion:-.
*/
publicacionesListasS([User],String):-
     string_concat(User," ",String).




 /*
 * Dominio: lista de publicaciones x string
 * Meta principal: tranformar la lista de Publicaciones en un string
 * Recursion: Natural.
*/


listaPublicacionesString([ ],Aux,String):-String = Aux,!.
listaPublicacionesString([H|T],Aux,String):-
    publicacionString(H,S1),
    string_concat(Aux,S1,S2),
    listaPublicacionesString(T,S2,String).

/*
 * Dominio: Usuarios x String
 * Meta principal: tranformar un usuario en un string
 * Recursion:-.
*/

publicacionString([ID,Date,Autor,Tipo,Contenido,Compartido],String):-
    number_string(ID,IDS),
    string_concat("       ID: ", IDS,L),
    string_concat(L," ",A),
    date(Date,DateS),
    string_concat(" FECHA DE CREACION: ",DateS,M),
    string_concat(A,M,B),
    string_concat(B," AUTOR: ",C),
    string_concat(C,Autor,D),
    string_concat(D," TIPO: ",E),
    string_concat(E,Tipo,F),
    string_concat(F," CONTENIDO: ",G),
    string_concat(G,Contenido,H),
    string_concat(H," USUARIOS COMPARTIDOS: ",I),
    listaCompartidoE(Compartido,"",K),
    string_concat(I,K,String).

/*
 * Dominio: Lista Fecha x String
 * Meta principal: tranformar una Fecha en un string
 * Recursion:-.
*/

date([DD,MM,AAAA],String):-
    number_string(DD,A),
    number_string(MM,B),
    number_string(AAAA,C),
    string_concat(A," ",D),
    string_concat(B," ",E),
    string_concat(C," ",F),
    string_concat(D,E,G),
    string_concat(G,F,String).

 /*
 * Dominio: lista de Compartido [[Fecha],Username] x string
 * Meta principal: tranformar la lista compartido en string
 * Recursion: Natural.
*/

listaCompartidoE([],Aux,String):-String = Aux, !.
listaCompartidoE([H|T],Aux, String):-
    listaCompartido(H,S1),
    string_concat(Aux, S1,S2),
    listaCompartidoE(T,S2, String).

/*
 * Dominio: ListaCompartido x String
 * Meta principal: tranforma una feccha y un usuario en un string
 * Recursion:-.
*/
listaCompartido([[DD,MM,AAAA],Nombre],String):-
     date([DD,MM,AAAA],A),
     string_concat("FECHA COMPARTIDO",A,M),
     string_concat(M,"USERNAME DE QUIEN LO COMPARTIO: ",B),
     string_concat(B,Nombre,S),
     string_concat(S,"\n ",String).

/*
 * Dominio: ListaUsuarioActivo x String
 * Meta principal: tranforma al usuario activo en un string
 * Recursion:-.
*/

usuarioActivoToString([],_):-!.
usuarioActivoToString([Nombre,Contrasena],String):-
    string_concat("USERNAME: ",Nombre,A),
    string_concat(" PASSWORD: ",Contrasena ,M),
    string_concat(A,M,B),
    string_concat(B,"\n",String).




/*
 Ejemplo:
 socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user2","pass2",SN4).

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user1","pass1",SN8),socialNetworkShare(SN8,[22,10,2005],1,[],SN9).

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user3","pass3",SN8),selectorUsuarios(SN8,Usuarios),selectorUActivo(SN8,LusuarioA),selectorNombreUA(LusuarioA,NombreA),encontrarUsuario(Usuarios,NombreA,UsuarioEncontrado),editarUsuarioIDShare(UsuarioEncontrado,2,NU),cambiar(UsuarioEncontrado,NU,Usuarios,UsuariosFinalesListos).

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user2","pass2",SN8),socialNetworkShare(SN8,[10,10,2010],1,[],SN9).


socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user2","pass2",SN8),socialNetworkShare(SN8,[10,10,2010],1,[],SN9),socialNetworkLogin(SN9,"user2","pass2",SN10),socialNetworkToString(SN10,SN11).

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user2","pass2",SN8),socialNetworkShare(SN8,[10,10,2010],1,[],SN9),socialNetworkToString(SN9,SN10).
*/
