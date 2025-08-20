<%
Function GetConnection()
    Dim conn
    Set conn = Server.CreateObject("ADODB.Connection")
    conn.Open "Provider=SQLOLEDB;Data Source=localhost;Initial Catalog=BD_PRODUTOS;Integrated Security=SSPI;"
    Set GetConnection = conn
End Function
%>