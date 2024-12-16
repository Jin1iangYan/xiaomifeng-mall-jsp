<%@ page import="java.util.Date" contentType="text/html; charset=utf-8" %>
<%@ page import="save.data.Login" %>
<%
    Login loginBean = (Login) session.getAttribute("loginBean");
    String guestnam = loginBean.getLogname();
    String talk = null;
    //整体向后挪一行，本次发言填入首行；application中的"sentence"为设定的聊天语句数。
    String sentencestr = (String) application.getAttribute("sentence");
    int sentence = Integer.parseInt(sentencestr);
    for (int i = sentence; i >= 2; i--) {
        talk = (String) application.getAttribute("talk" + (i - 1));
        application.setAttribute("talk" + i, talk);
    }
    Date dat = new Date();
    String hour = String.valueOf(dat.getHours());
    String minute = String.valueOf(dat.getMinutes());
    String second = String.valueOf(dat.getSeconds());
    String tim = hour + ":" + minute + ":" + second;
    //接收frame1.jsp传来的发言（"txttalk"），前后加入姓名和时间，填入记录数组首行.
    String talking = "<td><font size=3 color = green>" + guestnam + "【" + tim + "】 <br><font size=4 color = blue>" +
            request.getParameter("txttalk") + "</font></td>";
    application.setAttribute("talk1", talking);
    response.sendRedirect("frame0.jsp");
%>
