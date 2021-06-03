/* ------------------------------- TDAs --------------------------------------------
 * TDAUsuarioA=[Nombre,contraseña]
 * TDAUsuarios=[ID,nombre,Contraseña,Seguidores,QuienMesigue,[PCompartidasConmigo]]
 * TDAPublicacion=[ID,Date,Autor,Tipo,Contenido]
 * TDAlistaUsuarios=[[username1,pass1],[usernarme2,pass2],...,[usernameN,passN]]
 * TDAlistaPublicacion=[[TDAPublicacion1],[TDAPublicacion2],...,[TDAPublicaionN]]
 * TDASOCIALNETWORK=[Date,nombre,[[TDAUsuarioA],[TDAlistaUsuarios],[TDAlistaPublicacion]],SOut]
 * PCompartidasConmigo=[[TDAPublicacion1],[TDAPublicacion2],...,[TDAPublicacionN]]
 * Date=[dd,mm,aaaa]
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

socialnetwork([dd,mm,aaaa],nombre,[usuarioA],[usuarios],[publicaciones],sOut).
