<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <meta http-equiv="refresh" content=5>
    <style>
        body {
            background-color: bisque;

        }

    </style>

</head>

<body>
<%
    //先获取聊天室人数	
    String talkerstr = (String) application.getAttribute("talker");
%>
<font color=midnightgreen>
    <h4>【聊天室中现在有<%=talkerstr%>位访问者】</h4>
</font>
<table>
    <% //从application对象中获取可保存的聊天语句数sentence
        String sentencestr = (String) application.getAttribute("sentence");
        int sentence = Integer.parseInt(sentencestr);
        //循环输出application对象中的所有聊天语句talki。
        for (int i = 1; i <= sentence; i++) {
    %>
    <tr><%= application.getAttribute("talk" + i) %>
    </tr>
    <%
        }
    %>
</table>
</body>
</html>
