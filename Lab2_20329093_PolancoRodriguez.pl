/* ------------------------------- TDAs --------------------------------------------
 * TDAUsuarioA=[Nombre,contraseña]
 *TDAUsuarios=[ID,nombre,Contraseña,[Seguidores],[QuienMesigue],[PCompartidasConmigo]]
 *TDAPublicacion=[ID,Date,Autor,Tipo,Contenido]
 *TDAlistaUsuarios=[[username1,pass1],[usernarme2,pass2],...,[usernameN,passN]]
 *TDAlistaPublicacion=[[TDAPublicacion1],[TDAPublicacion2],...,[TDAPublicaionN]]
 *TDASOCIALNETWORK=[Date,nombre,[TDAUsuarioA],[TDAlistaUsuarios],[TDAlistaPublicacion]],SOut]
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

isSocialNetwork(Nombre,[DD,MM,AAAA],UsuarioActivo,Usuarios,Publicaciones):-
    string(Nombre),
    isDate(DD,MM,AAAA),
    isUsuarioActivo(UsuarioActivo).

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

usuario(ID,Nombre,Contraseña,OutU):-
    integer(ID),
    string(Nombre),
    string(Contraseña),
    OutU = [ID,Nombre,Contraseña,[],[],[]].

% ----------------------------------------------------------------------

% CONSTRUCTOR USUARIO ACTIVO

usuarioActivo(Nombre,Contraseña,OutU):-
    string(Nombre),
    string(Contraseña),
    OutU = [Nombre,Contraseña].

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
 * Dominio: Lista X integer
 * Meta Principal: Corroborar la existencia de un ID
 * Recursion: cola
 */

existeIdU([ID,_,_,_,_,_|_],IdU):-!.
existeIdU([_|Cola],ID):- existeIdU(Cola,ID).

/*
 * Dominio: lista usuario x string x string
 * Meta principal: verificar si existe el usuario registrado
 * Recursion: cola
*/
existeUsuario([[_,Nombre,Contraseña,_,_,_]|_],Nombre,Contraseña):-!.
existeUsuario([_|C],Nombre,Contraseña):- existeUsuario(C,Nombre,Contraseña).

% ------------------------------ BLOQUE PRIINCIPAL ---------------------

% REGISTER

socialNetworkRegister(Sn,[DD,MM,AAAA],Username,Password,OutSn):-
    selectorPublicaciones(Sn,Publicacion),
    tamanoLista(Publicacion,ID),IDF is ID+1,
    existeIdU(Sn,IDF),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    selectorUActivo(Sn,Activo),
    selectorUsuarios(Sn,UsuariosI),
    usuario(IDF,Username,Password,Usuario),
    append(UsuariosI,[Usuario],Usuarios),
    selectorPublicaciones(Sn,Publicaciones),
    OutSn = [Nombre,Fecha,Activo,Usuarios,Publicaciones].

% LOGIN

socialNetworkLogin(Sn,Username,Password,OutSn):-selectorUsuarios(Sn,Usuarios),
    existeUsuario(Usuarios,Username,Password),
    selectorNombre(Sn,Nombre),
    selectorFecha(Sn,Fecha),
    usuarioActivo(Username,Password,Activo),
    selectorPublicaciones(Sn,Publicaciones),
    OutSn = [Nombre,Fecha,Activo,Usuarios,Publicaciones].
