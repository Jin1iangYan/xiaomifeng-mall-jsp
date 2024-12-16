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

public class HandleUpdate extends HttpServlet {
    // 初始化方法
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    // 处理更新请求的方法
    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8"); // 设置请求字符集编码为utf-8
        String amount = request.getParameter("update"); // 获取请求中的更新数量
        String goodsId = request.getParameter("goodsId"); // 获取请求中的商品ID
        if (amount == null)
            amount = "1";
        int newAmount = 0;
        try {
            newAmount = Integer.parseInt(amount); // 将更新数量转换为整数
            if (newAmount < 0) {
                newAmount = 1;
            }
        } catch (NumberFormatException exp) {
            newAmount = 1;
        }
        Connection con = null; // 数据库连接对象
        PreparedStatement pre = null; // 预编译的sql语句对象
        Login loginBean = null;
        HttpSession session = request.getSession(true); // 获取session对象
        try {
            loginBean = (Login) session.getAttribute("loginBean"); // 从session中获取登录数据模型对象
            if (loginBean == null) {
                response.sendRedirect("login.jsp");// 重定向到登录页面
                return;
            } else {
                boolean b = loginBean.getLogname() == null ||
                        loginBean.getLogname().length() == 0;
                if (b) {
                    response.sendRedirect("login.jsp");// 重定向到登录页面
                    return;
                }
            }
        } catch (Exception exp) {
            response.sendRedirect("login.jsp");// 重定向到登录页面
            return;
        }
        Context contextNeeded = null;
        try {
            Context context = new InitialContext();
            contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds =
                    (DataSource) contextNeeded.lookup("mobileConn"); // 获取连接池
            con = ds.getConnection();// 从连接池中获取连接
            String updateSQL =
                    "update shoppingForm set goodsAmount =? where goodsId=?"; // 更新购物车的sql语句
            pre = con.prepareStatement(updateSQL); // 创建预编译的sql语句对象
            pre.setInt(1, newAmount); // 设置更新数量参数
            pre.setString(2, goodsId); // 设置商品ID参数
            pre.executeUpdate(); // 执行更新语句
            con.close(); // 关闭连接并返回连接池
            response.sendRedirect("lookShoppingCar.jsp"); // 查看购物车
        } catch (SQLException e) {
            response.getWriter().print("" + e); // 输出异常信息
        } catch (NamingException exp) {
            response.getWriter().print("" + exp); // 输出异常信息
        } finally {
            try {
                con.close(); // 关闭连接
            } catch (Exception ee) {
            }
        }
    }
}
