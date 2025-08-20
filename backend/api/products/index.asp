<!--#include virtual="/backend/_lib/db.asp"-->
<!--#include virtual="/backend/_lib/json.asp"-->

<%
' Detecta o método real, simulando PUT/DELETE via POST
Dim method
method = Request.ServerVariables("REQUEST_METHOD")
If method = "POST" Then
    Dim simMethod
    simMethod = Request.Form("_method")
    If simMethod <> "" Then method = UCase(simMethod)
End If

Dim conn, rs, sql
Set conn = GetConnection()

Select Case method

' ----------------- GET -----------------
Case "GET"
    sql = "EXEC sp_ListarProdutos"
    Set rs = conn.Execute(sql)
    Dim arr: arr = "["
    Dim precoStr

    Do Until rs.EOF
        ' Converte o preço para string e troca vírgula por ponto
        precoStr = Replace(CStr(rs("Preco")), ",", ".")
        
        arr = arr & "{""id"":" & rs("Id") & _
              ",""nome"":""" & rs("Nome") & """,""preco"":" & precoStr & _
              ",""quantidade"":" & rs("Quantidade") & _
              ",""datacadastro"":""" & rs("DataCadastro") & """},"
        rs.MoveNext
    Loop

    If Right(arr,1) = "," Then arr = Left(arr,Len(arr)-1)
    arr = arr & "]"
    JsonResponse "{""success"":true,""data"":" & arr & "}"


' ----------------- POST -----------------
Case "POST"
    Dim nome, preco, quantidade
    nome = Replace(Request.Form("nome"), "'", "''")
    preco = Request.Form("preco")
    quantidade = Request.Form("quantidade")

    If nome <> "" And preco <> "" And quantidade <> "" Then
        sql = "EXEC sp_CriarProduto '" & Replace(nome,"'","''") & "'," & preco & "," & quantidade
        conn.Execute(sql)
        JsonResponse "{""success"":true,""message"":""Produto inserido""}"
    Else
        JsonResponse "{""success"":false,""message"":""Faltam parâmetros""}"
    End If

' ----------------- PUT (simulado) -----------------

Case "PUT"
    Dim putId, putNome, putPreco, putQuantidade
    putId = Request.Form("id")
    putNome = Replace(Request.Form("nome"), "'", "''")
    putPreco = Request.Form("preco")
    putQuantidade = Request.Form("quantidade")

If putId <> "" And putNome <> "" And putPreco <> "" And putQuantidade <> "" Then
    On Error Resume Next
    sql = "EXEC sp_AtualizarProduto @Id=" & putId & ", @Nome='" & putNome & "', @Preco=" & putPreco & ", @Quantidade=" & putQuantidade & ", @Usuario='" & usuario & "'"
    conn.Execute(sql)
    If Err.Number = 0 Then
        JsonResponse "{""success"":true,""message"":""Produto atualizado""}"
    Else
        JsonResponse "{""success"":false,""message"":""Erro ao atualizar produto""}"
    End If
    On Error GoTo 0
End If


' ----------------- DELETE (simulado) -----------------
Case "DELETE"
    Dim delId
    delId = Request.Form("id")
If delId <> "" Then
    On Error Resume Next
    sql = "EXEC sp_DeletarProduto @Id=" & delId & ", @Usuario='" & usuario & "'"
    conn.Execute(sql)
    If Err.Number = 0 Then
        JsonResponse "{""success"":true,""message"":""Produto excluído""}"
    Else
        JsonResponse "{""success"":false,""message"":""Erro ao excluir produto""}"
    End If
    On Error GoTo 0
End If

' ----------------- Método não permitido -----------------
Case Else
    JsonResponse "{""success"":false,""message"":""Método não permitido""}"
End Select

If Not rs Is Nothing Then rs.Close
Set rs = Nothing
conn.Close
Set conn = Nothing
%>
