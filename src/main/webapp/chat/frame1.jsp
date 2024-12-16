<%@ page import="save.data.Login" %>
<%@ page contentType="text/html; charset=utf-8"%>
<%
	//取出在login.jsp中存入的本人姓名
	Login loginBean = (Login) session.getAttribute("loginBean");
	String guestnam = loginBean.getLogname();
%>
<html>
<head>
	<script language = "javascript">

	function chk()
	{
		if(frm1.txttalk.value == "")return ;
		else
		{
			frm1.submit();
			frm1.txttalk.value = "";
		}
	}
	function lgot()
	{
		self.close();
	}

	</Script>

	<style>
		body{
			background-color: burlywood;
		}

	</style>

</head>
<body>
	<form name=frm1 action="talking.jsp" method=post  target="fram0">
	<%= guestnam %>:<br> 
	<textarea rows=2 cols=60 name="txttalk"></textarea><br>
	<input type=button value="发言" onClick = "chk()"> 
	<input  name=reset1 type=reset value=清除>&nbsp;
	</form>
	<form action="logout.jsp" method=post name=frm2>
	<input type=submit  value=退出聊天 onClick="lgot()">
	</form>
</body>
</html>
