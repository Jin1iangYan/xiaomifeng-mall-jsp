package handle.data;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import save.data.Login;

public class HandleDelete extends HttpServlet {

    // 初始化方法
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    // 服务方法
    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException,IOException {

        // 设置请求字符编码
        request.setCharacterEncoding("utf-8");

        // 获取商品ID参数
        String goodsId = request.getParameter("goodsId");

        Connection con = null;
        PreparedStatement pre = null; // 预处理语句。
        Login loginBean = null;
        HttpSession session = request.getSession(true);

        try {
            // 获取登录信息
            loginBean = (Login) session.getAttribute("loginBean");
            if (loginBean == null) {
                response.sendRedirect("login.jsp"); // 重定向到登录页面。
                return;
            } else {
                boolean b = loginBean.getLogname() == null ||
                        loginBean.getLogname().length() == 0;
                if (b) {
                    response.sendRedirect("login.jsp"); // 重定向到登录页面。
                    return;
                }
            }
        } catch (Exception exp) {
            response.sendRedirect("login.jsp"); // 重定向到登录页面。
            return;
        }

        try {
            // 获取数据源
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn"); // 获得连接池。
            con = ds.getConnection(); // 使用连接池中的连接。

            // 从购物车中删除货物
            String deleteSQL = "delete  from shoppingForm where goodsId=?";
            pre = con.prepareStatement(deleteSQL);
            pre.setString(1,goodsId);
            pre.executeUpdate();

            con.close(); // 连接放回连接池。
            response.sendRedirect("lookShoppingCar.jsp"); // 查看购物车。
        }
        catch(SQLException e) {
            response.getWriter().print(""+e);
        }
        catch(NamingException exp){
            response.getWriter().print(""+exp);
        }
        finally{
            try{
                con.close();
            }
            catch(Exception ee){}
        }
    }
}