package controller;

import entity.Product;
import entity.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.ProductService;
import service.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserController", value = "/auth")
public class UserController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String page = req.getParameter("page");
        if (page == null) page = "";
        switch (page) {
            case "signIn":
                showSignInPage(req, resp);
                break;
            case "signUp":
                showSignUpPage(req, resp);
                break;
            case "logout":
                logout(req, resp);
                break;
            case "favorite":
                showFavoriteProduct(req, resp);
                break;
            case "changePassword":
                showChangePasswordPage(req, resp);
                break;
            default:
                showNotFound(req, resp);
        }
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/auth?page=signIn");
    }

    private void showSignInPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("users/signIn.jsp");
        dispatcher.forward(req, resp);
    }

    private void showSignUpPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("users/signUp.jsp");
        dispatcher.forward(req, resp);
    }

    private void showChangePasswordPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?page=signIn");
            return;
        }
        RequestDispatcher dispatcher = req.getRequestDispatcher("users/changePassword.jsp");
        dispatcher.forward(req, resp);
    }

    private void showFavoriteProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=signIn");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        ProductService productService = new ProductService();

        List<Product> favorites = productService.getFavoriteByUser(currentUser.getId());

        req.setAttribute("favorites", favorites);

        req.getRequestDispatcher("/users/favorite.jsp").forward(req, resp);
    }

    private void showNotFound(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("errors/not-found.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";
        switch (action) {
            case "signIn":
                this.signIn(req, resp);
                break;
            case "signUp":
                this.signUp(req, resp);
                break;
            case "changePassword":
                changePassword(req, resp);
                break;
            default:
                showNotFound(req, resp);
        }
    }

    private void signUp(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User newUser = new User(username, password);
        userService.signUp(newUser);
        resp.sendRedirect("/auth?page=signIn");
    }

    private void signIn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User foundUser = userService.signIn(username, password);
        String errorMessage = null;
        if (foundUser == null) {
            errorMessage = "Sai tên đăng nhập hoặc mật khẩu";
            RequestDispatcher dispatcher = req.getRequestDispatcher("users/signIn.jsp");
            req.setAttribute("errorMessage", errorMessage);
            dispatcher.forward(req, resp);
        } else {
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", foundUser);
            resp.sendRedirect("/products?page=home");
        }
    }

    private void changePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");

        boolean success = userService.changePassword(currentUser.getId(), oldPassword, newPassword);
        if (success) {
            req.setAttribute("message", "Đổi mật khẩu thành công!");
        } else {
            req.setAttribute("message", "Mật khẩu cũ không đúng hoặc lỗi!");
        }

        RequestDispatcher dispatcher = req.getRequestDispatcher("users/changePassword.jsp");
        dispatcher.forward(req, resp);
    }
    
}
