<%@ page contentType="text/html; charset=utf-8"
         import="java.util.Date,java.text.SimpleDateFormat" %>
<%@ page import="save.data.Login" %>
<%
    Login bean = (Login) session.getAttribute("loginBean");
    String guestnam = bean.getLogname();
    String talk = null;
    Object visitnam = null;
    Object visitsex = null;
    String visittmp = null;
    String vnmtmp = null;
    String sentencestr = (String) application.getAttribute("sentence");
    int sentence = Integer.parseInt(sentencestr);

    String tmp;
    int kint = 0;
    for (int i = 1; i <= sentence; i++) {
        tmp = (String) application.getAttribute("visitnam" + i);
        if (tmp.equals(guestnam)) kint = i;
    }

    for (int i = kint; i <= sentence; i++) {
        tmp = (String) application.getAttribute("visitnam" + (i + 1));
        application.setAttribute("visitnam" + i, tmp);
        tmp = (String) application.getAttribute("visitsex" + (i + 1));
        application.setAttribute("visitsex" + i, tmp);
    }
    application.setAttribute("visitnam" + sentence, "");
    application.setAttribute("visitsex" + sentence, "");

    for (int i = sentence; i >= 2; i--) {
        talk = (String) application.getAttribute("talk" + (i - 1));
        application.setAttribute("talk" + i, talk);
    }

    Date dat = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD HH:mm:ss");
    String tim = sdf.format(dat);
    String tking;
    tking = "<tr><td bgcolor = cyan align=left>谢谢"
            + guestnam + "光顾! 离开时间：" + tim + "</td></tr>";
    application.setAttribute("talk1", tking);
    String talkerstr = (String) application.getAttribute("talker");
    int talker = Integer.parseInt(talkerstr);
    application.setAttribute("talker", String.valueOf(talker - 1));
%>
<html>
<head>
    <script Language="javascript">

        function logoutcls() {
            self.close();
        }

    </script>
</head>
<body onload="logoutcls()"></body>
</html>
