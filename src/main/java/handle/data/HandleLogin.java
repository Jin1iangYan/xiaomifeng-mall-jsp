package handle.data;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
import jakarta.servlet.http.HttpSession;
import save.data.Login;

public class HandleLogin extends HttpServlet {
    //初始化方法
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    //处理登录请求的方法
    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //设置请求字符集编码为utf-8
        request.setCharacterEncoding("utf-8");
        Connection con = null; //数据库连接对象
        Statement sql; //sql语句对象
        String logname = request.getParameter("logname").trim(), //获取请求中的用户名并去除空格
                password = request.getParameter("password").trim(); //获取请求中的密码并去除空格
        password = Encrypt.encrypt(password, "javajsp"); //对用户密码进行加密
        boolean boo = (logname.length() > 0) && (password.length() > 0); //判断用户名和密码是否为空
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env"); //获取上下文对象
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn"); //获取连接池
            con = ds.getConnection(); //从连接池中获取连接
            String condition = "select * from user where logname = '" + logname +
                    "' and password ='" + password + "'"; //查询条件sql语句
            sql = con.createStatement(); //创建sql语句对象
            if (boo) { //如果用户名和密码都不为空
                ResultSet rs = sql.executeQuery(condition); //执行查询语句
                boolean m = rs.next(); //判断是否有查询结果
                if (m == true) { //如果查询结果为真
                    //调用登录成功的方法
                    success(request, response, logname, password);
                    RequestDispatcher dispatcher =
                            request.getRequestDispatcher("login.jsp"); //转发请求到login.jsp页面
                    dispatcher.forward(request, response);
                } else {
                    String backNews = "您输入的用户名不存在，或密码不般配";
                    //调用登录失败的方法
                    fail(request, response, logname, backNews);
                }
            } else {
                String backNews = "请输入用户名和密码";
                fail(request, response, logname, backNews);
            }
            con.close(); //关闭连接并返回连接池
        } catch (SQLException exp) {
            String backNews = "" + exp;
            fail(request, response, logname, backNews);
        } catch (NamingException exp) {
            String backNews = "没有设置连接池" + exp;
            fail(request, response, logname, backNews);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
    }

    //处理登录成功的方法
    public void success(HttpServletRequest request, HttpServletResponse response,
                        String logname, String password) {
        Login loginBean = null; //创建登录数据模型对象
        HttpSession session = request.getSession(true); //获取会话对象
        try {
            loginBean = (Login) session.getAttribute("loginBean"); //从会话中获取数据模型对象
            if (loginBean == null) {
                loginBean = new Login();  //创建新的数据模型对象
                session.setAttribute("loginBean", loginBean); //将数据模型对象存储到会话中
                loginBean = (Login) session.getAttribute("loginBean");
            }
            String name = loginBean.getLogname();
            if (name.equals(logname)) { //如果登录用户与之前登录用户相同
                loginBean.setBackNews(logname + "已经登录了");
                loginBean.setLogname(logname);
            } else {  //数据模型存储新的登录用户
                loginBean.setBackNews(logname + "登录成功");
                loginBean.setLogname(logname);
            }
        } catch (Exception ee) {
            loginBean = new Login();
            session.setAttribute("loginBean", loginBean);
            loginBean.setBackNews(ee.toString());
            loginBean.setLogname(logname);
        }
    }

    //处理登录失败的方法
    public void fail(HttpServletRequest request, HttpServletResponse response,
                     String logname, String backNews) {
        response.setContentType("text/html;charset=utf-8"); //设置响应文本类型和编码
        try {
            PrintWriter out = response.getWriter(); //获取响应输出流
            out.println("<html><body>");
            out.println("<h2>" + logname + "登录反馈结果<br>" + backNews + "</h2>");
            out.println("返回登录页面或主页<br>");
            out.println("<a href =login.jsp>登录页面</a>");
            out.println("<br><a href =index.jsp>主页</a>");
            out.println("</body></html>");
        } catch (IOException exp) {
        }
    }
}