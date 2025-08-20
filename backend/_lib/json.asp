<%
' Função para enviar um objeto/array em JSON
Sub JsonResponse(jsonText)
    Response.Clear
    Response.ContentType = "application/json"
    Response.Write jsonText
    Response.End
End Sub
%>
