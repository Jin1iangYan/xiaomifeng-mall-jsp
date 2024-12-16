<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <meta http-equiv="refresh" content=5>

    <style>
        body {
            background-color: darksalmon;
        }

    </style>

</head>
<body>
<font size=2 color=darkblue>
    聊天室顾客名单：
    <hr>
    <%
        String talkerstr = (String) application.getAttribute("talker");
        int talker = Integer.parseInt(talkerstr);
        for (int i = 1; i <= talker; i++) {
    %>
    <%= application.getAttribute("visitnam" + i)%>
    <%
        }
    %>
</font>
</body>
</html>
