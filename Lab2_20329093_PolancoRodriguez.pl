/* ------------------------------- TDAs --------------------------------------------
 * TDAUsuarioA=[Nombre,contraseña]
 *TDAUsuarios=[ID,Fecha,nombre,Contraseña,[Seguidores],[QuienMesigue],[PCompartidasConmigo]]
 *TDAPublicacion=[ID,Date,Autor,Tipo,Contenido]
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
    OutP = [ID,[DD,MM,AAAA],Autor,Tipo,Contenido].


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
usuarioEditado([],_,_):-!.
usuarioEditado([ID,[DD,MM,AAAA],Nombre,Contraseña,Seguidores,QuienSigue,PCConmigo|Cola],IDP,UsuarioE):-
    ID=IDP,
    append(PCConmigo,[ID],PCConmigoF),
    UsuarioE =[ID,[DD,MM,AAAA],Nombre,Contraseña,Seguidores,QuienSigue,PCConmigoF],
    usuarioEditado(Cola,IDP,UsuarioE).


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
    OutSn = [Nombre,Fecha,Activo,Usuarios,Publicaciones].

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
    OutSn = [Nombre,Fecha,Activo,Usuarios,Publicaciones].

% POST
% post para añadir el post a mismo usuario activo

socialNetworkPost(Sn,[DD,MM,AAAA],Texto,[],OutSn):-
    isDate(DD,MM,AAAA),
    string(Texto),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,LusuarioA),
    selectorUsuarios(Sn,Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    tamanoLista(Publicaciones,ID),IDF is ID+1,
    selectorNombreUA(LusuarioA,Autor),
    publicaciones(IDF,[DD,MM,AAAA],Autor,"Texto",Texto,PublicacionF),
    append(Publicaciones,[PublicacionF],PublicacionesFF),
    usuarioEditado(Usuarios,IDF,UsuarioE),
    eliminarUsuaio(),
    OutSn=[Nombre,Fecha,[],UsuariosFF,PublicacionesFF].


/*
 Ejemplo:
 socialnetwork("FB", [10,10,2010], SN), socialNetworkRegister(SN, [10,10,2010], "user1", "pass1", SN1), socialNetworkRegister(SN1, [10,10,2010], "user2", "pass2", SN2), socialNetworkRegister(SN2, [10,10,2010], "user3", "pass3", SN3),socialNetworkLogin(SN3,"user2","pass2",SN4),socialNetworkLogin(SN3,"user1","pass1",SN4).

*/
