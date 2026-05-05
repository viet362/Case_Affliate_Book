package middleware;

import entity.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("*")
public class AuthMiddleware extends HttpFilter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("currentUser");
        String path = request.getServletPath();
        // Cho phép các trang public
        boolean isPublic = path.equals("/auth");
        if (!isPublic && user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?page=signIn");
            return;
        }
        chain.doFilter(req, res);
    }
}
