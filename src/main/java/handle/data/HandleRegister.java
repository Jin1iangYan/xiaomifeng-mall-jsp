package handle.data;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import save.data.Register;

public class HandleRegister extends HttpServlet {
    //初始化方法
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    //处理注册请求的方法
    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8"); //设置请求字符集编码为utf-8
        Connection con = null; //数据库连接对象
        PreparedStatement sql = null; //预编译的sql语句对象
        Register userBean = new Register();  //创建注册数据模型对象
        request.setAttribute("userBean", userBean); //将数据模型对象存储到请求中
        String logname = request.getParameter("logname").trim(); //获取请求中的用户名并去除空格
        String password = request.getParameter("password").trim(); //获取请求中的密码并去除空格
        String again_password = request.getParameter("again_password").trim(); //获取请求中的确认密码并去除空格
        String phone = request.getParameter("phone").trim(); //获取请求中的手机号并去除空格
        String address = request.getParameter("address").trim(); //获取请求中的地址并去除空格
        String realname = request.getParameter("realname").trim(); //获取请求中的真实姓名并去除空格
        if (logname == null)
            logname = "";
        if (password == null)
            password = "";
        if (!password.equals(again_password)) { //判断密码和确认密码是否相同
            userBean.setBackNews("两次密码不同，注册失败，");
            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("inputRegisterMess.jsp"); //转发请求到inputRegisterMess.jsp页面
            dispatcher.forward(request, response); //执行转发
            return;
        }
        boolean isLD = true; //判断用户名是否合法，默认为真
        for (int i = 0; i < logname.length(); i++) { //遍历用户名的每个字符
            char c = logname.charAt(i);
            if (!(Character.isLetterOrDigit(c) || c == '_')) //如果字符不是字母、数字或下划线，则用户名非法
                isLD = false;
        }
        boolean boo = logname.length() > 0 && password.length() > 0 && isLD; //判断用户名、密码和用户名的合法性
        String backNews = ""; //反馈信息
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds =
                    (DataSource) contextNeeded.lookup("mobileConn");//获取连接池
            con = ds.getConnection();//从连接池中获取连接
            String insertCondition = "INSERT INTO user VALUES (?,?,?,?,?)"; //插入数据的sql语句
            sql = con.prepareStatement(insertCondition); //创建预编译的sql语句对象
            if (boo) { //如果用户名、密码和用户名合法
                sql.setString(1, logname); //设置sql语句中的参数
                password =
                        Encrypt.encrypt(password, "javajsp");//给用户密码加密
                sql.setString(2, password);
                sql.setString(3, phone);
                sql.setString(4, address);
                sql.setString(5, realname);
                int m = sql.executeUpdate(); //执行插入语句
                if (m != 0) { //如果插入成功
                    backNews = "注册成功";
                    userBean.setBackNews(backNews);
                    userBean.setLogname(logname);
                    userBean.setPhone(phone);
                    userBean.setAddress(address);
                    userBean.setRealname(realname);
                }
            } else {
                backNews = "信息填写不完整或名字中有非法字符";
                userBean.setBackNews(backNews);
            }
            con.close();//关闭连接并返回连接池
        } catch (SQLException exp) {
            backNews = "该会员名已被使用，请您更换名字" + exp;
            userBean.setBackNews(backNews);
        } catch (NamingException exp) {
            backNews = "没有设置连接池" + exp;
            userBean.setBackNews(backNews);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("inputRegisterMess.jsp");
        dispatcher.forward(request, response);//转发请求到inputRegisterMess.jsp页面
    }
}