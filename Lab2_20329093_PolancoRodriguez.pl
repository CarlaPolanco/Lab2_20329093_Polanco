/* ------------------------------- TDAs --------------------------------------------
 *TDAUsuarioA=[Nombre,contrase?a]
 *TDAUsuario=[ID,Fecha,nombre,Contrase?a,[Seguidores],[PublicacionesMias],[PCompartidasConmigo]]
 *TDAPublicacion=[ID,Date,Autor,Tipo,Contenido,[UsuariosCompartido]]
 *TDAlistaUsuarios=[[TDAUsuario1],[TDAUsuario2],...,[TDAUsuarioN]]
 *TDAlistaPublicacion=[[TDAPublicacion1],[TDAPublicacion2],...,[TDAPublicaionN]]
 *PCompartidasConmigo=[FechaQueCompartio,IdPublicacion]
 *Date=[dd,mm,aaaa]
 *TDASOCIALNETWORK=[Nombre,Date,[TDAUsuarioA],[TDAlistaUsuarios],[TDAlistaPublicacion]],SOut]

 */
/*-------------------------------- DOMINIOS ------------------------------------- */

/*
 * Nombre/username = Nombre asignado para los usuarios.
 * Contrase?a/Pass = Contrase?a de los usuarios.
 * ID = identificador de cada usuario o publicacion.
 * Autor = Nombre del creador de la publicacion.
 * Seguidores = Otros usuarios que sigue la cuenta.
 * PublicacionesMias = ID's de las publicaciones que he compartido
 * Tipo = Tipo de publicacion, estas pueden ser
 *        url,video,text,audio,etc.
 * Contenido = Lo que contendra la publicacion .
 * Date = Fecha en que se creara la red social o la
 *        publicacion posee un formato de tipo; [dd,mm,aaaa], donde
 *        dd=dia, mm=mes, aaaa=a?o, con un a?o maximo 2021, mes varia
 *        entre 1 y 11 y dia entre 1 y 30 .
 */

 %-------------------------------------------PREDICADOS----------------------------------------------
/*
 isDate(DD,MM,AAAA)
 selectorNombre([Nombre,_,_,_,_],NombreSn)
 selectorFecha([_,Fecha,_,_,_],FechaSn)
 selectorUActivo([_,_,UA,_,_],UASn)
 selectorUsuarios([_,_,_,Usuarios,_],USn)
 selectorPublicaciones([_,_,_,_,Publicaciones],PSn)
 publicaciones(ID,[DD,MM,AAAA],Autor,Tipo,Contenido,OutP)
 editarPublicacion([ID,Date,Autor,Tipo,Contenido,Compartida],List,PublicacionEdit)
 encontrarPublicacion([[ID,Date,Autor,Tipo,Contenido,Compartida]|_],ID,[ID,Date,Autor,Tipo,Contenido,Compartida])
 usuario(ID,[DD,MM,AAAA],Nombre,Contrase?a,OutU)
 encontrarUsuario([[ID,Fecha,Username,Pass,List,List1,List2]|_],Username,[ID,Fecha,Username,Pass,List,List1,List2])
 existeUsuario([[_,_,Nombre,Contrase?a,_,_,_]|_],Nombre,Contrase?a)
 editarUsuario([ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCC],Username,Salida)
 editarUsuarioID([ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCC],IDF,UsuarioFF)
 agregarIDPost(UsuariosFFF,[],_,Salida)
 editarUsuarioIDShare([ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCC],IDF,UsuarioFF)
 agregarIDShare(UsuariosFFF,[],_,Salida)
 usuarioActivo(Nombre,Contrase?a,OutU)
 selectorNombreUA([U|_],Nombre)
 tamanoLista([],0)
 cambiar(E,NE,[E],[NE])
 socialNetworkString([Nombre,Fecha,_,ListaU,ListaP],[],Snout)
 socialNetworkString([Nombre,Fecha,_,ListaU,_],[Username,_],Snout)
 listaUsuarioString([],Aux, String)
 usuarioString([ID,[DD,MM,AAAA],Nombre,Contrase?a,Seguidores,PublicacionesMias,PublicacionesCompartidas],String)
 publicacionesListaE([],Aux,String)
 publicacionesListas(ID,String)
 publicacionesListaSeguidoresE([],Aux,String)
 publicacionesListasS([User],String)
 listaPublicacionesString([ ],Aux,String)
 publicacionString([ID,Date,Autor,Tipo,Contenido,Compartido],String)
 date([DD,MM,AAAA],String)
 listaCompartidoE([],Aux,String)
 listaCompartido([[DD,MM,AAAA],Nombre],String)

*/
%-------------------------------------------- REGLAS --------------------------------------------------------

socialnetwork(Nombre,[DD,MM,AAAA],Sout):-
    string(Nombre),
    integer(DD),DD>0,DD<31,
    integer(MM),MM<13,MM>0,
    integer(AAAA),AAAA<2022,AAAA>0,
    Sout=[Nombre,[DD,MM,AAAA],[],[],[]].

/*
 * Dominio: Number X Number X Number
 * Meta principal: Comprobar una correcta fecha
 * Recursion:-
*/

isDate(DD,MM,AAAA):-
    integer(DD),
    integer(MM),
    integer(AAAA).

% SELECTOR SOCIALNETWORK

/*
 * Dominio:  REDSOCIAL X STRING
 * Meta principal: Retornar el nombre de la red social
 * Recursion:-
*/

selectorNombre([Nombre,_,_,_,_],NombreSn):-
    NombreSn = Nombre.

/*
 * Dominio:  REDSOCIAL X Lista
 * Meta principal: Retornar la fecha de creacion de la red social
 * Recursion:-
*/

selectorFecha([_,Fecha,_,_,_],FechaSn):-
    FechaSn = Fecha.

/*
 * Dominio:  REDSOCIAL X Lista
 * Meta principal: Retornar el usuario activo de la red social
 * Recursion:-
*/

selectorUActivo([_,_,UA,_,_],UASn):-
    UASn = UA.

/*
 * Dominio:  REDSOCIAL X Lista
 * Meta principal: Retornar los usuarios de la red social
 * Recursion:-
*/

selectorUsuarios([_,_,_,Usuarios,_],USn):-
    USn = Usuarios.

/*
 * Dominio:  REDSOCIAL X Lista
 * Meta principal: Retornar las publicaciones de la red social
 * Recursion:-
*/

selectorPublicaciones([_,_,_,_,Publicaciones],PSn):-
    PSn = Publicaciones.

%---------------------------------------------------------------------

% CONSTRUCTOR PUBLICACIONES

/*
 * Dominio:  Number X Lista X String X String X String X lista
 * Meta principal: Construir una Publicacion
 * Recursion:-
*/


publicaciones(ID,[DD,MM,AAAA],Autor,Tipo,Contenido,OutP):-
    integer(ID),
    isDate(DD,MM,AAAA),
    string(Autor),
    string(Tipo),
    string(Contenido),
    OutP = [ID,[DD,MM,AAAA],Autor,Tipo,Contenido,[]].

% MODIFICADOR

/*
 * Dominio:[NumberXListaXStringXStringXStringXlista] X Lista X Lista
 * Meta principal: Editar una Publicacion
 * Recursion:-
*/

editarPublicacion([ID,Date,Autor,Tipo,Contenido,Compartida],List,PublicacionEdit):-
    append(Compartida,[List],Compartida2),
    PublicacionEdit = [ID,Date,Autor,Tipo,Contenido,Compartida2].


% PERTENENCIA

/*
 * Dominio:ListaPubicaciones X Number X listaPublicacion
 * Meta principal: Encontrar una Publicacion
 * Recursion: Cola
*/


encontrarPublicacion([[ID,Date,Autor,Tipo,Contenido,Compartida]|_],ID,[ID,Date,Autor,Tipo,Contenido,Compartida]):-!.
encontrarPublicacion([_|C],ID,Usuario):-encontrarPublicacion(C,ID,Usuario).



%--------------------------------------------------------------------

% CONSTRUCTOR USUARIO

/*
 * Dominio:  Number X Lista X String X String X listaUsuario
 * Meta principal: Construir un usuario
 * Recursion:-
*/

usuario(ID,[DD,MM,AAAA],Nombre,Contrase?a,OutU):-
    integer(ID),
    string(Nombre),
    string(Contrase?a),
    isDate(DD,MM,AAAA),
    OutU = [ID,[DD,MM,AAAA],Nombre,Contrase?a,[],[],[]].

% SELECTOR

/*
 * Dominio:  ListaUsuarios X String X ListaUsuario
 * Meta principal: Retornar los usuarios de la red social
 * Recursion: Cola
*/

encontrarUsuario([[ID,Fecha,Username,Pass,List,List1,List2]|_],Username,[ID,Fecha,Username,Pass,List,List1,List2]):-!.
encontrarUsuario([_|C],Username,Usuario):-encontrarUsuario(C,Username,Usuario).

% PERTENENCIA

/*
 * Dominio: lista usuario x string x string
 * Meta principal: verificar si existe el usuario registrado
 * Recursion: cola
*/
existeUsuario([[_,_,Nombre,Contrase?a,_,_,_]|_],Nombre,Contrase?a):-!.
existeUsuario([_|C],Nombre,Contrase?a):- existeUsuario(C,Nombre,Contrase?a).

% MODIFICADORES

/*
 * Dominio: ListaUsuario X String X ListaNuevooUsuario
 * Meta principal: Editar un Usuario
 * Recursion:-
*/

editarUsuario([ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCC],Username,Salida):-
    append(Seguidores,[Username],SeguidoresF),
    Salida = [ID,Fecha,Nombre,Contrase?a,SeguidoresF,QM,PCC].

/*
 * Dominio: ListaUsuario X Number X ListaNuevooUsuario
 * Meta principal: Editar un Usuario a?adiendo un ID
 * Recursion:-
*/

editarUsuarioID([ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCC],IDF,UsuarioFF):-
    append(PCC,[IDF],PCCF),
    UsuarioFF = [ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCCF].

/*
 * Dominio: ListaUsuario X ListaUser X Number X ListaNuevooUsuario
 * Meta principal: Editar un Usuario a?adiendo un ID
 * Recursion: Cola
*/

agregarIDPost(UsuariosFFF,[],_,Salida):-
    Salida=UsuariosFFF,
    !,true.
agregarIDPost(Usuarios,[Cabeza|Cola],IDF,Salida):-
    encontrarUsuario(Usuarios,Cabeza,UsuarioF),
    editarUsuarioID(UsuarioF,IDF,UsuarioFF),
    cambiar(UsuarioF,UsuarioFF,Usuarios,UsuariosFFF),
    agregarIDPost(UsuariosFFF,Cola,IDF,Salida).

/*
 * Dominio: ListaUsuario X Number X ListaNuevooUsuario
 * Meta principal: Editar un Usuario a?adiendo un ID
 * Recursion:-
*/

editarUsuarioIDShare([ID,Fecha,Nombre,Contrase?a,Seguidores,QM,PCC],IDF,UsuarioFF):-
    append(QM,[IDF],QMF),
    UsuarioFF = [ID,Fecha,Nombre,Contrase?a,Seguidores,QMF,PCC].

/*
 * Dominio: ListaUsuario X ListaUser X Number X ListaNuevooUsuario
 * Meta principal: Editar un Usuario a?adiendo un ID
 * Recursion: Cola
*/


agregarIDShare(UsuariosFFF,[],_,Salida):-
    Salida=UsuariosFFF,
    !,true.
agregarIDShare(Usuarios,[Cabeza|Cola],PostId,Salida):-
    encontrarUsuario(Usuarios,Cabeza,UsuarioF),
    editarUsuarioIDShare(UsuarioF,PostId,NE),
    cambiar(UsuarioF,NE,Usuarios,UsuariosF),
    agregarIDShare(UsuariosF,Cola,PostId,Salida).




% ----------------------------------------------------------------------

% CONSTRUCTOR USUARIO ACTIVO

/*
 * Dominio: String X String X listaUsuarioActivo
 * Meta principal: Construir un usuario activo
 * Recursion:-
*/

usuarioActivo(Nombre,Contrase?a,OutU):-
    string(Nombre),
    string(Contrase?a),
    OutU = [Nombre,Contrase?a].

% SELECTOR USUARIO ACTIVO

/*
 * Dominio: ListaUsuarioActivo X String
 * Meta principal: Retornar el nombre del usuario activo
 * Recursion: -
 */

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
 * Dominio: Elemento X Elemento X Lista X Lista
 * Meta Principal: Cambiar algo de la lista
 * Recursion: natural
 */

cambiar(E,NE,[E],[NE]):-!.
cambiar(E,NE,[E|Es],[NE|Es]):-!.
cambiar(E,NE,[Q|Es],[Q|NEs]):-cambiar(E,NE,Es,NEs).

% ----------------------------------------------------------------------


% ------------------------------ MANEJO DE STRING ----------------------

/*
 * Dominio: SocialNetwork X ListaUsuarioActivo X SocialNetworkSalida
 * Meta principal: tranformar la social network a string
 * Recursion:-
*/

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

socialNetworkString([Nombre,Fecha,_,ListaU,_],[Username,_],Snout):-
    encontrarUsuario(ListaU,Username,UsuarioNuevo),
    string_concat(" \n        ******** RED SOCIAL: ",Nombre,A),
    string_concat(A," ******* \n",B),
    date(Fecha,C),
    string_concat("        FECHA DE CREACION: ",C,D),
    string_concat(D,"\n",E),
    string_concat(B,E,F),
    string_concat(F,"       ******** USUARIO ACTIVO: ******** \n",K),
    usuarioString(UsuarioNuevo,J),
    string_concat(K,J,M),
    string_concat(F,M,Snout).


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

usuarioString([ID,[DD,MM,AAAA],Nombre,Contrase?a,Seguidores,PublicacionesMias,PublicacionesCompartidas],String):-
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
    string_concat(O,Contrase?a,G),
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

% ----------------------------------------------------------------------


% ------------------------------ BLOQUE PRIINCIPAL ---------------------

% ----------------------------------------------------------------------


% REGISTER

/*
 * Dominio: SocialNetwork x Date X String X String X SocialnetworkSalida
 * Meta principal: Registra un usuario en la SocialNetwork
 * Recursion:-.
*/

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

/*
 * Dominio: SocialNetwork X String X String X SocialnetworkSalida
 * Meta principal: Loguea un usuario en la SocialNetwork
 * Recursion:-.
*/

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

/*
 * Dominio: SocialNetwork X Date X String X Lista X SocialnetworkSalida
 * Meta principal: Crea una publicacion en la SocialNetwork
 * Recursion:-.
*/


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

/*
 * Dominio: SocialNetwork X Date X String X Lista X SocialnetworkSalida
 * Meta principal: Crea una publicacion en la SocialNetwork
 * Recursion:-.
*/

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



% Follow

/*
 * Dominio: SocialNetwork X String X  SocialnetworkSalida
 * Meta principal: Sigue a otro usuario de la SocialNetwork
 * Recursion:-.
*/

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

% SHARE

/*
 * Dominio: SocialNetwork X Date X Number X Lista X SocialnetworkSalida
 * Meta principal: Comparte una publicacion en la SocialNetwork
 * Recursion:-.
*/

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

/*
 * Dominio: SocialNetwork X Date X Number X Lista X SocialnetworkSalida
 * Meta principal: Comparte una publicacion en la SocialNetwork
 * Recursion:-.
*/

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


%  TO STRING

/*
 * Dominio: SocialNetwork X SocialnetworkSalida
 * Meta principal: Transforma la SocialNetwork en string
 * Recursion:-.
*/

socialNetworkToString(Sn,SnOut):-
    selectorUActivo(Sn,Activo),
    socialNetworkString(Sn,Activo,SnOut), !.


/* ------------------------------------------------------EJEMPLOS---------------------------------------------------------------------------------
 *
 ---------------------- EJEMPLO DE REGISTER Y LOGIN --------------------

 socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user2","pass2",SN4).

---------------------- EJEMPLO DE LOGIN Y FOLLOW --------------------

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkFollow(SN4,"user1",SN5).

 ---------------------- EJEMPLO DE POST Y SHARE -----------------------

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user1","pass1",SN8),socialNetworkShare(SN8,[22,10,2005],1,[],SN9).

 ---------------------- EJEMPLO DE POST Y SHARE -----------------------

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user2","pass2",SN8),socialNetworkShare(SN8,[10,10,2010],1,[],SN9).

 ------------------ EJEMPLO DE ToString con usuario logeado -----------

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user2","pass2",SN8),socialNetworkShare(SN8,[10,10,2010],1,[],SN9),socialNetworkLogin(SN9,"user2","pass2",SN10),socialNetworkToString(SN10,SN11).

 ------------------ EJEMPLO DE ToString sin usuario logeado -----------

socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user3","pass3",SN4),socialNetworkPost(SN4,[8,11,1999],"Esta es una prueba",[],SN5),socialNetworkLogin(SN5,"user3","pass3",SN6),socialNetworkPost(SN6,[23,12,2008],"Probando como funciona esta vaina",["user2","user1"],SN7),socialNetworkLogin(SN7,"user2","pass2",SN8),socialNetworkShare(SN8,[10,10,2010],1,[],SN9),socialNetworkToString(SN9,SN10).
*/
