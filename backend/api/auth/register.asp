<!--#include virtual="/backend/_lib/db.asp"-->
<!--#include virtual="/backend/_lib/json.asp"-->
<%

If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then 
    JsonResponse "{""success"":false,""message"":""Método não permitido""}"
    Response.End
End If

Dim conn, rs, sql, nome, usernome, senha

nome     = Trim(Request.Form("nome"))
usernome = Trim(Request.Form("usernome"))
senha    = Trim(Request.Form("senha"))

If nome = "" Or usernome = "" Or senha = "" Then
    JsonResponse "{""success"":false,""message"":""Parâmetros faltando""}"
    Response.End
End If

Set conn = GetConnection()

'--- Verificar se já existe usuário ---
sql = "SELECT COUNT(*) as Total FROM Usuarios WHERE UserNome='" & Replace(usernome, "'", "''") & "'"
Set rs = conn.Execute(sql)

If rs("Total") > 0 Then
    JsonResponse "{""success"":false,""message"":""Usuário já existe""}"
    rs.Close
    Set rs = Nothing
    conn.Close
    Set conn = Nothing
    Response.End
End If

rs.Close
Set rs = Nothing

'--- Inserir usuário com senha criptografada (SHA1 + SALT) ---
sql = "INSERT INTO Usuarios (Nome, UserNome, Senha) VALUES (" & _
      "'" & Replace(nome, "'", "''") & "'," & _
      "'" & Replace(usernome, "'", "''") & "'," & _
      "CONVERT(VARCHAR(40), HASHBYTES('SHA1', '" & Replace(senha, "'", "''") & "Teste@2025'), 2))"

conn.Execute(sql)

JsonResponse "{""success"":true,""message"":""Usuário registrado com sucesso""}"

conn.Close
Set conn = Nothing

%>
