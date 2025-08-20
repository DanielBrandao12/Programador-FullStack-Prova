<!--#include virtual="/backend/_lib/db.asp"-->
<!--#include virtual="/backend/_lib/json.asp"-->
<%
If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    JsonResponse "{""success"":false,""message"":""Método não permitido""}"
    Response.End
End If

Dim conn, rs, sql, usernome, senha, token, userId, nome
Set conn = GetConnection()

' Lê os dados do form
usernome = Trim(Request.Form("usernome"))
senha    = Trim(Request.Form("senha"))

If usernome = "" Or senha = "" Then
    JsonResponse "{""success"":false,""message"":""Parâmetros faltando""}"
    Response.End
End If

' --- Verifica usuário e senha ---
sql = "SELECT Id, Nome FROM Usuarios " & _
      "WHERE UserNome='" & Replace(usernome, "'", "''") & "' " & _
      "AND Senha=CONVERT(VARCHAR(40), HASHBYTES('SHA1', '" & Replace(senha, "'", "''") & "Teste@2025'), 2)"

Set rs = conn.Execute(sql)

If Not rs.EOF Then
    userId = rs("Id")
    nome   = rs("Nome")
    
    ' --- Gera token diretamente no UPDATE e retorna --- 
    sql = "UPDATE Usuarios SET Token = CONVERT(VARCHAR(100), HASHBYTES('SHA1', '" & Replace(usernome, "'", "''") & "' + CAST(GETDATE() AS NVARCHAR)), 2) " & _
          "OUTPUT INSERTED.Token WHERE Id = " & userId
          
    Set rsToken = conn.Execute(sql)
    token = rsToken("Token")
    rsToken.Close
    Set rsToken = Nothing

    ' --- Função para escapar caracteres especiais no JSON ---
    Function JsonEscape(str)
        str = Replace(str, "\", "\\")
        str = Replace(str, """", "\""")
        str = Replace(str, vbCrLf, "\n")
        str = Replace(str, vbLf, "\n")
        JsonEscape = str
    End Function

    ' --- Envia JSON com userId, nome e token ---
    JsonResponse "{""success"":true,""message"":""Login bem-sucedido"",""userId"":" & userId & ",""nome"":""" & JsonEscape(nome) & """,""token"":""" & token & """}"

Else
    JsonResponse "{""success"":false,""message"":""Usuário ou senha inválidos""}"
End If

rs.Close
Set rs = Nothing
conn.Close
Set conn = Nothing
%>
